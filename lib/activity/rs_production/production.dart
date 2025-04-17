import 'package:flutter/material.dart';
import 'package:pdcs_frontend/widget/side_bar.dart';
import '../../provider/production_function/app_bar.dart';
import '../../provider/production_function/drawer.dart';
import '../../provider/production_function/tabbed_selector.dart';
import '../../provider/production_function/data_content.dart';
import '../../provider/production_function/chart_section.dart';

class ProductionPage extends StatelessWidget {
  const ProductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildProductionAppBar(),
      drawer: SideBar(),
      body: Column(
        children: [
          buildTabbedSelector(),
          Expanded(child: buildDataContent()),
          const SizedBox(height: 16),
          Expanded(child: buildChartSection()),
        ],
      ),
    );
  }
}
