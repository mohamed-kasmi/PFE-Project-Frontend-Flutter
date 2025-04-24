import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import '../models/production_data.dart';

class MqttService {
  final _controller = StreamController<ProductionData>.broadcast();

  Stream<ProductionData> get stream => _controller.stream;
  late final MqttClient _client;

  MqttService() {
    const broker = '192.168.81.16';
    const port = 9001;
    const clientId = 'flutter_dashboard';

    if (kIsWeb) {
      _client = MqttBrowserClient('ws://$broker:$port', clientId);
    } else {
      final mobileClient = MqttServerClient.withPort(broker, clientId, port)
        ..useWebSocket = true;
      _client = mobileClient;
    }

    _client.port = port;
    _client.websocketProtocols = ['mqtt'];
    _client.onConnected = () => print('✅ MQTT Connected');
    _client.onDisconnected = () => print('❌ MQTT Disconnected');
    _client.logging(on: false); // fixed ✅
  }


  Future<void> connect() async {
    try {
      await _client.connect();
      _client.subscribe('testtopic', MqttQos.atMostOnce);

      _client.updates?.listen((events) {
        for (var event in events!) {
          final msg = event.payload as MqttPublishMessage;
          final payload =
          MqttPublishPayload.bytesToStringAsString(msg.payload.message);
          try {
            final data = json.decode(payload);
            if (data is Map<String, dynamic> && data.containsKey("qtplanifier")) {
              final parsed = ProductionData.fromJson(data);
              _controller.add(parsed);
            }
          } catch (e) {
            print("⚠️ MQTT JSON decode error: $e");
          }
        }
      });
    } catch (e) {
      print("🚫 MQTT connect error: $e");
    }
  }

  void disconnect() {
    _client.disconnect();
    _controller.close();
  }
}
