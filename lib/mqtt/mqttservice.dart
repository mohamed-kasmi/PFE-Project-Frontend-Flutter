import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/foundation.dart' ;
import 'package:mqtt_client/mqtt_browser_client.dart';

class MqttService {
  bool _isConnected = false;
  final List<Map<String, dynamic>> _messages = [];
  final _controller = StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get messageStream => _controller.stream;
  late final MqttClient _client;
  final List<String> _topics = ['machine/#'];
  final Map<String, Map<String, dynamic>> _machineData = {};
  final Map<String, String> _machineStatus = {};
  final Map<String, Timer> _machineTimers = {};

  MqttService() {


    const broker = '192.168.82.128';
    const port = 9001;
    final clientId = 'Client_${DateTime.now().millisecondsSinceEpoch}';

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
        _isConnected = true;
      }
      ..onDisconnected = () {
        print('MQTT Disconnected');
        _isConnected = false;
      };
  }
  Future<void> connect() async {
    try {
      if (_client.connectionStatus?.state != MqttConnectionState.connected) {
        await _client.connect();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> SubscribeMsg() async {
    if (!_isConnected) await connect();
    for (final topic in _topics) {
      _client.subscribe(topic, MqttQos.atLeastOnce);
      print('Subscribed to $topic');
    }

    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? events) {
      for (var event in events!) {
        final topic = event.topic;
        final recMess = event.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        final parts = topic.split('/');
        if (parts.length < 3) continue;

        final type = parts[1];
        final machineId = parts[2];
        _resetMachineTimer(machineId);

        if (type == 'data') {
          try {
            final data = jsonDecode(payload);
            _machineData[machineId] = data;
          } catch (e) {
            print('Data decode error: $e');
          }
        } else if (type == 'status') {
          try {
            final status = jsonDecode(payload);
            final statusValue = status['status'];
            _machineStatus[machineId] = statusValue;
            print("Received status: $statusValue for machine: $machineId");
          } catch (e) {
            print('Error decoding status: $e');
          }
        }

        final fullData = _machineData[machineId] ?? {};
        fullData["status"] = _machineStatus[machineId] ?? 'offline';

        _messages.removeWhere((msg) => msg['topic'] == machineId);
        _messages.add({'topic': machineId, 'data': fullData});
      }

      _controller.add(List.from(_messages.reversed));
    });
  }
  void _resetMachineTimer(String machineId) {
    _machineTimers[machineId]?.cancel();

    _machineTimers[machineId] = Timer(Duration(seconds: 30), () {
      _machineStatus[machineId] = 'offline';

      final fullData = _machineData[machineId] ?? {};
      fullData["status"] = 'offline';

      _messages.removeWhere((msg) => msg['topic'] == machineId);
      _messages.add({'topic': machineId, 'data': fullData});

      _controller.add(List.from(_messages.reversed));
      print("Timer expired: $machineId set to OFFLINE");
    });
  }



  Future<void> publishMsg(String topic, dynamic payload, bool retain) async {
    if (!_isConnected) await connect();
    final builder = MqttClientPayloadBuilder();
    builder.addUTF8String(jsonEncode(payload));
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!, retain: retain);
    print('Message published to $topic: $payload');
  }

  void disconnect() {
    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      _client.disconnect();
      _isConnected = false;
    }
  }
}