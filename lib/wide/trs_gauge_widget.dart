import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TRSGaugeWidget extends StatelessWidget {
  final double trsValue;

  const TRSGaugeWidget({
    super.key,
    required this.trsValue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'TRS LIVE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              width: 400,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    axisLineStyle: AxisLineStyle(
                      thickness: 0.15,
                      color: Colors.grey[300],
                    ),
                    ranges: [
                      GaugeRange(
                        startValue: 0,
                        endValue: 70,
                        color: Colors.red,
                        label: 'Critical',
                        sizeUnit: GaugeSizeUnit.factor,
                        startWidth: 0.15,
                        endWidth: 0.15,
                      ),
                      GaugeRange(
                        startValue: 70,
                        endValue: 90,
                        color: Colors.orange,
                        label: 'Warning',
                        sizeUnit: GaugeSizeUnit.factor,
                        startWidth: 0.15,
                        endWidth: 0.15,
                      ),
                      GaugeRange(
                        startValue: 90,
                        endValue: 100,
                        color: Colors.green,
                        label: 'Optimal',
                        sizeUnit: GaugeSizeUnit.factor,
                        startWidth: 0.15,
                        endWidth: 0.15,
                      ),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: trsValue,
                        enableAnimation: true,
                        animationDuration: 1000,
                        needleColor: Colors.black,
                        needleLength: 0.6,
                        knobStyle: KnobStyle(
                          color: Colors.blue,
                          knobRadius: 0.08,
                          borderWidth: 0.02,
                          borderColor: Colors.black,
                        ),
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${trsValue.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                            Text(
                              'Efficiency',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.red, '0-70%'),
        const SizedBox(width: 15),
        _buildLegendItem(Colors.orange, '70-90%'),
        const SizedBox(width: 15),
        _buildLegendItem(Colors.green, '90-100%'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}