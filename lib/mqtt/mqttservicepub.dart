import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

class MqttPublisherService {
  static final MqttPublisherService _instance = MqttPublisherService._internal();
  factory MqttPublisherService() => _instance;

  late final MqttClient _client;
  bool _isConnected = false;

  MqttPublisherService._internal() {
    const broker = '192.168.1.14';
    const port = 9001;
    final clientId = 'Publisher_${DateTime.now().millisecondsSinceEpoch}';

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
        print('Publisher MQTT Connected');
        _isConnected = true;
      }
      ..onDisconnected = () {
        print('Publisher MQTT Disconnected');
        _isConnected = false;
      };
  }

  Future<void> connect() async {
    try {
      if (_client.connectionStatus?.state != MqttConnectionState.connected) {
        await _client.connect();
      }
    } catch (e) {
      print('Publisher MQTT Connection error: $e');
    }
  }

  Future<void> publishMessage(String topic, Map<String, dynamic> payload) async {
    if (!_isConnected) await connect();

    final builder = MqttClientPayloadBuilder();
    builder.addUTF8String(jsonEncode(payload));

    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    print('Message published to $topic: $payload');
  }

  void disconnect() {
    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      _client.disconnect();
      _isConnected = false;
    }
  }
}
