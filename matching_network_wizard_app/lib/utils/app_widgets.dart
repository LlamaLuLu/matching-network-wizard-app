import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/app_theme.dart';
import 'package:matching_network_wizard_app/utils/saved_data.dart';

class AppWidgets {
  //--------------------- BUTTONS ------------------------//
  static Widget backButton(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: AppTheme.text2,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  static Widget pinkButton(String btnText, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.bg1,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 34),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        btnText,
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w500,
          color: AppTheme.text1,
        ),
      ),
    );
  }

  static Widget greenButton(String btnText, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.bg2,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        btnText,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppTheme.text2,
        ),
      ),
    );
  }

  //--------------------- HEADINGS ------------------------//
  static Widget headingText(String text, Color color) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  //--------------------- COMPONENTS ------------------------//
  static Widget networkTypeCard(
      String label, VoidCallback onPressed, Color fgColor, Color bgColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 6, horizontal: 35), // Adjust spacing
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            onPressed(); // Navigate to parallel plate page
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor, // Background color
            foregroundColor: fgColor, // Text color
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Smooth rounded corners
            ),
            elevation: 4,
            padding: const EdgeInsets.symmetric(vertical: 20), // Same height
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  static Widget textField(
      {bool hasSubscript = false,
      required String label,
      required TextEditingController controller,
      String? subscript,
      String? hintText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 30, vertical: 10), // More balanced padding
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Aligns text & input properly
        children: [
          // label
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.text2,
              ),
              children: [
                TextSpan(text: label),
                if (hasSubscript)
                  WidgetSpan(
                    child: Transform.translate(
                      offset: Offset(0, 4), // move subscript down
                      child: Text(
                        subscript!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.text2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 20), // Spacing between label & input field

          // Text Field
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: (hintText == null || hintText.isEmpty)
                    ? 'Enter value'
                    : hintText,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.text2,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTheme.bg1, // Border color when not focused
                  ),
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTheme.bg1, // Border color when focused
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.text2,
              ),
              keyboardType: TextInputType.number, // Allows numeric input
            ),
          ),
        ],
      ),
    );
  }

  // FOR CAROUSEL SLIDER:

  static String capOrInd(String param, double value) {
    // X
    if (param == 'x' || param == 'X') {
      if (value > 0) {
        return ' H';
      } else {
        return ' F';
      }
    }
    // B
    else if (param == 'b' || param == 'B') {
      // B
      if (value > 0) {
        return ' F';
      } else {
        return ' H';
      }
    } else {
      return '';
    }
  }

  // for params: heading name
  static Widget buildParametersCard(
      String matchingNetworkType,
      String matchingNetwork,
      bool autoMode,
      List<double> calculatedData,
      List<String> userInputs) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      decoration: BoxDecoration(
        color: AppTheme.bg1,
        borderRadius: BorderRadius.circular(18),
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
              '$matchingNetwork Parameters',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.text1,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),
            // show network type only if on 'auto'
            if (autoMode) buildParameterRow('Network Type', matchingNetwork),
            // if matchingNetworkType == 'quarterwave'
            // show: ZQWT
            if (matchingNetworkType == 'quarterwave')
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: buildParameterRow(
                    'ZQWT', '${calculatedData[0].toStringAsFixed(3)} Ω'),
              ),
            if (matchingNetworkType == 'lumped')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if X pos -> inductor, if X neg -> capacitor
                  // if B pos -> capacitor, if B neg -> inductor

                  // series first
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      'Series First Solution',
                      style: TextStyle(
                        color: AppTheme.text1,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  buildParameterRow('X1',
                      '${calculatedData[4].toStringAsExponential(3)}${capOrInd('X', calculatedData[4])}'),
                  buildParameterRow('B1',
                      '${calculatedData[6].toStringAsExponential(3)}${capOrInd('B', calculatedData[6])}'),
                  buildParameterRow('X2',
                      '${calculatedData[5].toStringAsExponential(3)}${capOrInd('X', calculatedData[5])}'),
                  buildParameterRow('B2',
                      '${calculatedData[7].toStringAsExponential(3)}${capOrInd('B', calculatedData[7])}'),

                  // shunt first
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 5),
                    child: Text(
                      'Shunt First Solution',
                      style: TextStyle(
                        color: AppTheme.text1,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  buildParameterRow('B1',
                      '${calculatedData[2].toStringAsExponential(3)}${capOrInd('B', calculatedData[2])}'),
                  buildParameterRow('X1',
                      '${calculatedData[0].toStringAsExponential(3)}${capOrInd('X', calculatedData[0])}'),
                  buildParameterRow('B2',
                      '${calculatedData[3].toStringAsExponential(3)}${capOrInd('B', calculatedData[3])}'),
                  buildParameterRow('X2',
                      '${calculatedData[1].toStringAsExponential(3)}${capOrInd('X', calculatedData[1])}'),
                ],
              ),
            if (matchingNetworkType == 'singlestub')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // shunt stub 1
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      'Shunt Stub Solution 1',
                      style: TextStyle(
                        color: AppTheme.text1,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  buildParameterRow(
                      't', calculatedData[0].toStringAsExponential(3)),
                  buildParameterRow(
                      'd/\u03BB', calculatedData[2].toStringAsExponential(3)),
                  buildParameterRow(
                      'B', calculatedData[4].toStringAsExponential(3)),
                  buildParameterRow('L/\u03BB (open)',
                      calculatedData[6].toStringAsExponential(3)),
                  buildParameterRow('L/\u03BB (short)',
                      calculatedData[8].toStringAsExponential(3)),

                  // shunt stub 2
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 5),
                    child: Text(
                      'Shunt Stub Solution 2',
                      style: TextStyle(
                        color: AppTheme.text1,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  buildParameterRow(
                      't', calculatedData[1].toStringAsExponential(3)),
                  buildParameterRow(
                      'd/\u03BB', calculatedData[3].toStringAsExponential(3)),
                  buildParameterRow(
                      'B', calculatedData[5].toStringAsExponential(3)),
                  buildParameterRow('L/\u03BB (open)',
                      calculatedData[7].toStringAsExponential(3)),
                  buildParameterRow('L/\u03BB (short)',
                      calculatedData[9].toStringAsExponential(3)),
                ],
              ),

            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                'Your Inputs:',
                style: TextStyle(
                  color: AppTheme.text1,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // show user inputs: Z0, ZL, f
            buildParameterRow('Z0', '${userInputs[0]} Ω'),
            buildParameterRow('ZL', '${userInputs[1]} Ω'),
            buildParameterRow('Frequency', '${userInputs[2]} Hz'),
          ],
        ),
      ),
    );
  }

  static Widget buildParameterRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.text1,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10), // Add spacing between label and value
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right, // Align to the right
              maxLines: 2, // Allow up to 2 lines
              overflow: TextOverflow.ellipsis, // Show '...' if it's too long
              style: TextStyle(
                color: AppTheme.text1,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // for params: img path, diagram label
  static Widget buildCircuitDiagram() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      decoration: BoxDecoration(
        color: AppTheme.bg1,
        borderRadius: BorderRadius.circular(18),
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
          const SizedBox(height: 15),
          // replace with diagram label
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

  static Widget buildImpedanceGraph(List<FlSpot> impedanceData) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
      decoration: BoxDecoration(
        color: AppTheme.bg1,
        borderRadius: BorderRadius.circular(18),
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
