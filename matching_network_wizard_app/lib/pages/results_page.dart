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
  // Labels for the carousel pages
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // back arrow button
                  AppWidgets.backButton(context),

                  // heading: Results
                  AppWidgets.headingText('Results', AppTheme.text2),
                ],
              ),

              // Carousel Slider for results
              Expanded(
                child: Column(
                  children: [
                    // Carousel
                    Expanded(
                      child: CarouselSlider(
                        items: [
                          // 1. Parameters Card
                          _buildParametersCard(),

                          // 2. Circuit Diagram
                          _buildCircuitDiagram(),

                          // 3. Impedance Graph
                          _buildImpedanceGraph(),
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

                    // Slider indicator
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [0, 1, 2].map((index) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? AppTheme.text2
                                : AppTheme.bg2,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 25, top: 25),
                child: AppWidgets.appButton(
                    'PCB Design', () => ButtonFuncs.nextBtnResults(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParametersCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bg1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Matching Network Parameters',
              style: TextStyle(
                color: AppTheme.text1,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildParameterRow('Network Type', 'Pi Network'),
            _buildParameterRow('Input Impedance', '50 Ω'),
            _buildParameterRow('Output Impedance', '75 Ω'),
            _buildParameterRow('Central Frequency', '2.4 GHz'),
            _buildParameterRow('Bandwidth', '200 MHz'),
            _buildParameterRow('Q Factor', '2.5'),
            _buildParameterRow('C1 Value', '4.7 pF'),
            _buildParameterRow('L1 Value', '2.2 nH'),
            _buildParameterRow('C2 Value', '3.3 pF'),
            const SizedBox(height: 16),
            Text(
              'Calculated VSWR: 1.15',
              style: TextStyle(
                color: AppTheme.text1,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.text1,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.text1,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircuitDiagram() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bg1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Circuit Diagram',
            style: TextStyle(
              color: AppTheme.text1,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              // Replace this placeholder with your actual image loading
              child: Image.asset(
                'assets/images/circuit_diagram.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.bg2.withValues(alpha: 0.3),
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: AppTheme.text1,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pi Network Configuration',
            style: TextStyle(
              color: AppTheme.text1,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpedanceGraph() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bg1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Impedance vs Frequency',
            style: TextStyle(
              color: AppTheme.text1,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
                left: 8.0,
                top: 8.0,
                bottom: 20.0,
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 1,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.bg2.withValues(alpha: 0.3),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: AppTheme.bg2.withValues(alpha: 0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text(
                        'Frequency (GHz)',
                        style: TextStyle(
                          color: AppTheme.text1,
                          fontSize: 12,
                        ),
                      ),
                      axisNameSize: 24,
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: TextStyle(
                              color: AppTheme.text1,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Text(
                        'Impedance (Ω)',
                        style: TextStyle(
                          color: AppTheme.text1,
                          fontSize: 12,
                        ),
                      ),
                      axisNameSize: 24,
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: TextStyle(
                              color: AppTheme.text1,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border:
                        Border.all(color: AppTheme.bg2.withValues(alpha: 0.5)),
                  ),
                  minX: 1,
                  maxX: 7,
                  minY: 0,
                  maxY: 6,
                  lineBarsData: [
                    LineChartBarData(
                      spots: impedanceData,
                      isCurved: true,
                      color: AppTheme.bg3,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.bg3.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
