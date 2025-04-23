import 'mqttservice.dart';
import '../models/machine.dart';

extension MachineStream on MqttService {
  Stream<List<Machine>> get machineStream => messageStream.map((dataList) {
    return dataList.map((msg) {
      return Machine.fromJson(msg['topic'], msg['data']);
    }).toList();
  });
}