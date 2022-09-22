// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'mqtt_client.dart';

// import 'dart:async';
// import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MQTT Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MqttClient client;
  var pubTopic = "flutter/pub";
  var subTopic = "flutter/sub";

  void _publish(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString('Hello from flutter_client');
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Client Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Connect'),
              onPressed: () => {
                connect().then((value) {
                  client = value;
                })
              },
            ),
            ElevatedButton(
              child: const Text('Subscribe'),
              onPressed: () {
                print({client.subscribe('flutter/set', MqttQos.atLeastOnce)});
              },
            ),
            ElevatedButton(
              child: const Text('Publish'),
              onPressed: () => {_publish('Hello')},
            ),
            ElevatedButton(
              child: const Text('Unsubscribe'),
              onPressed: () => {client.unsubscribe(subTopic)},
            ),
            ElevatedButton(
              child: const Text('Disconnect'),
              onPressed: () => {client.disconnect()},
            ),
          ],
        ),
      ),
    );
  }
}
