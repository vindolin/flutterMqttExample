// ignore_for_file: avoid_print

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:io';

const server = 'broker.emqx.io';
const port = 1883;
const username = 'user';
const password = 'password';
const clientIdentifier = 'flutter_client';

void onConnected() {
  print('Connected');
}

void onDisconnected() {
  print('Disconnected');
}

void onSubscribed(String? topic) {
  print('Subscribed topic: $topic');
}

void onUnsubscribed(String? topic) {
  print('Unsubscribed topic: $topic');
}

void onSubscribeFail(String topic) {
  print('Failed to subscribe topic: $topic');
}

void pong() {
  print('Ping response client callback invoked');
}

Future<MqttClient> connect() async {
  MqttServerClient client = MqttServerClient.withPort(
    server,
    'flutter_client',
    port,
  );
  client.logging(on: true);
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  client.onSubscribed = onSubscribed;
  client.onUnsubscribed = onUnsubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;
  client.keepAlivePeriod = 60;

  final connectionMessage = MqttConnectMessage()
      .withClientIdentifier(clientIdentifier)
      .authenticateAs(username, password)
      .withWillTopic('withWillTopic')
      .withWillMessage('withWillMessage')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);
  client.connectionMessage = connectionMessage;

  try {
    print('Connecting');
    await client.connect();
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
  }

  if (client.connectionStatus?.state == MqttConnectionState.connected) {
    print('client connected');

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final message = c![0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(
        message.payload.message,
      );

      print('Received message:$payload from topic: ${c[0].topic}>');
    });

    client.published!.listen((MqttPublishMessage message) {
      print('published');
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      print(
          'Published message: $payload to topic: ${message.variableHeader?.topicName}');
    });
  } else {
    print(
      'Client connection failed - disconnecting, status is ${client.connectionStatus}',
    );
    client.disconnect();
    exit(-1);
  }

  return client;
}
