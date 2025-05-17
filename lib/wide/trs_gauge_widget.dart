import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TRSGaugeWidget extends StatelessWidget {
  final double trsValue;

  const TRSGaugeWidget({super.key, required this.trsValue});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizing
    final bool isSmallScreen = screenWidth < 500;
    final double cardWidth = isSmallScreen ? screenWidth * 0.9 : 400;
    final double gaugeHeight = isSmallScreen ? 200 : 220;
    final double fontSizeTitle = isSmallScreen ? 16 : 18;
    final double fontSizeValue = isSmallScreen ? 20 : 24;
    final double fontSizeLabel = isSmallScreen ? 10 : 12;
    final double legendBoxSize = isSmallScreen ? 10 : 12;
    final double spacingLegend = isSmallScreen ? 6 : 15;

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            children: [
              Text(
                'OEE LIVE',
                style: TextStyle(
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              SizedBox(height: isSmallScreen ? 10 : 12),
              SizedBox(
                height: gaugeHeight,
                width: cardWidth,
                child: SfRadialGauge(
                  axes: [
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
                          labelStyle: GaugeTextStyle(fontSize: fontSizeLabel),
                          sizeUnit: GaugeSizeUnit.factor,
                          startWidth: 0.15,
                          endWidth: 0.15,
                        ),
                        GaugeRange(
                          startValue: 70,
                          endValue: 90,
                          color: Colors.orange,
                          label: 'Warning',
                          labelStyle: GaugeTextStyle(fontSize: fontSizeLabel),
                          sizeUnit: GaugeSizeUnit.factor,
                          startWidth: 0.15,
                          endWidth: 0.15,
                        ),
                        GaugeRange(
                          startValue: 90,
                          endValue: 100,
                          color: Colors.green,
                          label: 'Optimal',
                          labelStyle: GaugeTextStyle(fontSize: fontSizeLabel),
                          sizeUnit: GaugeSizeUnit.factor,
                          startWidth: 0.15,
                          endWidth: 0.15,
                        ),
                      ],
                      pointers: [
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
                      annotations: [
                        GaugeAnnotation(
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${trsValue.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: fontSizeValue,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                              Text(
                                'Efficiency',
                                style: TextStyle(
                                  fontSize: fontSizeLabel,
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
              SizedBox(height: isSmallScreen ? 6 : 8),
              _buildLegend(legendBoxSize, spacingLegend, fontSizeLabel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(double boxSize, double spacing, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.red, '0-70%', boxSize, fontSize),
        SizedBox(width: 1),
        _buildLegendItem(Colors.orange, '70-90%', boxSize, fontSize),
        SizedBox(width: 1),
        _buildLegendItem(Colors.green, '90-100%', boxSize, fontSize),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text, double boxSize, double fontSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: boxSize,
          height: boxSize,
          color: color,
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
