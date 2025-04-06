import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/app_theme.dart';
import 'package:matching_network_wizard_app/utils/app_widgets.dart';
import 'package:matching_network_wizard_app/utils/button_funcs.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final List<String> _pageLabels = ['Parameters', 'Circuit', 'Graph'];

  // Sample data for the impedance graph (replace with your actual data)
  final List<FlSpot> impedanceData = [
    FlSpot(1, 2.5),
    FlSpot(2, 3.1),
    FlSpot(3, 4.0),
    FlSpot(4, 3.8),
    FlSpot(5, 3.5),
    FlSpot(6, 4.2),
    FlSpot(7, 5.1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg3,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // back arrow button
                  Padding(
                    padding: const EdgeInsets.only(left: 11),
                    child: AppWidgets.backButton(context),
                  ),

                  // heading: Results
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 30),
                    child: AppWidgets.headingText('Results', AppTheme.text2),
                  ),
                ],
              ),

              // Text labels for carousel pages
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _pageLabels.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final String label = entry.value;
                  return GestureDetector(
                    onTap: () {
                      _carouselController.animateToPage(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? AppTheme.bg4
                            : AppTheme.bg2.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: _currentIndex == index
                              ? AppTheme.text4
                              : AppTheme.text1,
                          fontWeight: _currentIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 18),

              Expanded(
                child: CarouselSlider(
                  items: [
                    AppWidgets.buildParametersCard(),
                    AppWidgets.buildCircuitDiagram(),
                    AppWidgets.buildImpedanceGraph(impedanceData),
                  ],
                  options: CarouselOptions(
                    height: double.infinity,
                    viewportFraction: 0.9,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  carouselController: _carouselController,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 25, top: 25),
                child: AppWidgets.greenButton(
                    'PCB Design', () => ButtonFuncs.nextBtnResults(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
