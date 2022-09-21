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
  var topic = "flutter/test";

  void _publish(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString('Hello from flutter_client');
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('title'),
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
            // ElevatedButton(
            //   child: Text('Subscribe'),
            //   onPressed: () {
            //     return {client?.subscribe(topic, MqttQos.atLeastOnce)};
            //   },
            // ),
            ElevatedButton(
              child: const Text('Publish'),
              onPressed: () => {_publish('Hello')},
            ),
            // ElevatedButton(
            //   child: Text('Unsubscribe'),
            //   onPressed: () => {client?.unsubscribe(topic)},
            // ),
            // ElevatedButton(
            //   child: Text('Disconnect'),
            //   onPressed: () => {client?.disconnect()},
            // ),
          ],
        ),
      ),
    );
  }
}
