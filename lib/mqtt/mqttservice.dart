import 'dart:async';
import 'dart:convert';
import '../models/machine.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/foundation.dart' ;
import 'package:mqtt_client/mqtt_browser_client.dart';

class MqttService {
  final List<Map<String, dynamic>> _messages = [];
  final _controller = StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get messageStream => _controller.stream;

  late final MqttClient _client;
  final List<String> _topics = ['testtopic', 'testtopic2','testtopic3'];


  MqttService() {
    const broker = '192.168.81.16';
    const port = 9001;
    const clientId = 'flutter_unified_client';

    if (kIsWeb) {

      _client = MqttBrowserClient('ws://$broker:$port', clientId);
    } else {
      final mobileClient = MqttServerClient.withPort('ws://$broker', clientId, port)
        ..useWebSocket = true;
      _client = mobileClient;
    }

    _client
      ..port = port
      ..websocketProtocols = ['mqtt']
      ..logging(on: true)
      ..onConnected = () {
        print('MQTT Connected');
      }
      ..onDisconnected = () {
        print('MQTT Disconnected');
      };
  }


  Future<void> connect() async {
    try {
      await _client.connect();

      for (final topic in _topics) {
        _client.subscribe(topic, MqttQos.atLeastOnce);
        print('Subscribed to $topic');
      }

      _client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? events) {
        for (var event in events!) {
          final topic = event.topic;
          final recMess = event.payload as MqttPublishMessage;
          final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

          try {
            final jsonData = jsonDecode(payload);
            _messages.add({'topic': topic, 'data': jsonData});
            _controller.add(List.from(_messages.reversed));
            print("Received from $topic: $jsonData");
          } catch (e) {
            print('Error decoding message: $e');
          }
        }
      });
    } catch (e) {
      print('MQTT Connection error: $e');
    }
  }
  void disconnect() {
    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      _client.disconnect();
      print("MQTT Disconnected manually.");
    } else {
      print("MQTT already disconnected.");
    }
  }
}
