import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/app_theme.dart';
import 'package:matching_network_wizard_app/utils/calculations.dart';
import 'package:matching_network_wizard_app/utils/quarter_wave_painter.dart';
import 'package:matching_network_wizard_app/utils/saved_data.dart';
import 'package:matching_network_wizard_app/utils/stub_match_painter.dart';

class AppWidgets {
  //--------------------- BUTTONS ------------------------//
  static Widget backButton(BuildContext context, {String? path}) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: AppTheme.text2,
        onPressed: () async {
          await SavedData.setAutoMode(false);
          if (path != null) {
            Navigator.pushNamed(context, path);
          } else {
            Navigator.pop(context);
          }
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

  static Widget resultHeading1(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppTheme.text1,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  static Widget resultHeading2(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppTheme.text1,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static Widget resultHeading3(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppTheme.text1,
        fontSize: 14,
        fontWeight: FontWeight.w600,
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
    // if X pos -> inductor, if X neg -> capacitor
    // if B pos -> capacitor, if B neg -> inductor

    // X
    if ((param == 'x' || param == 'X') && (value > 0)) {
      return 'Inductor';
    } else if ((param == 'x' || param == 'X') && (value < 0)) {
      return 'Capacitor';
    }
    // B
    else if ((param == 'b' || param == 'B') && (value > 0)) {
      return 'Capacitor';
    } else if ((param == 'b' || param == 'B') && (value < 0)) {
      return 'Inductor';
    } else {
      return 'None';
    }
  }

  static String capOrIndValue(double value, String capOrInd) {
    if (capOrInd == 'Capacitor') {
      return '${value.toStringAsExponential(3)} F';
    } else if (capOrInd == 'Inductor') {
      return '${value.toStringAsExponential(3)} H';
    } else {
      return 'NaN';
    }
  }

  static bool isValidCap(double cVal) {
    if (cVal < pow(1, -12) || cVal > pow(5, -9)) {
      return false;
    } else {
      return true;
    }
  }

  static bool isValidInd(double lVal) {
    if (lVal < pow(5, -9) || lVal > pow(1, -6)) {
      return false;
    } else {
      return true;
    }
  }

  static bool isValidSolution(List<bool> validComponents) {
    // Check if all components are valid
    for (bool isValid in validComponents) {
      if (!isValid) {
        return false; // Return false if any component is invalid
      }
    }
    return true; // All components are valid
  }

  static Widget buildParametersCard(
      String matchingNetworkType,
      String matchingNetwork,
      bool autoMode,
      bool isMatched,
      List<double> calculatedData,
      List<double> userInputs,
      List<double> capIndValues) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 20),
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
            if (isMatched || autoMode)
              Center(child: resultHeading1('Design Parameters')),
            if (!isMatched && !autoMode)
              Center(child: resultHeading1('$matchingNetwork Parameters')),

            const SizedBox(height: 15),

            // already matched
            if (isMatched)
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 70),
                child: Center(child: resultHeading2('Circuit is Matched')),
              ),
            // not matched yet
            if (!isMatched)
              Column(
                children: [
                  if (autoMode)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child:
                          buildParameterRow('Best\nSolution', matchingNetwork),
                    ),
                  if (matchingNetworkType == 'quarterwave')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          buildParameterRow(
                              'ZQWT',
                              (userInputs[2] != 0)
                                  ? 'Load not\npurely real'
                                  : '${calculatedData[0].toStringAsFixed(3)} Ω'),
                          buildParameterRow(('\u03BB/4'),
                              '${calculatedData[1].toStringAsExponential(3)} m'),
                        ],
                      ),
                    ),
                  if (matchingNetworkType == 'lumped')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // series first
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: resultHeading2('Series First Solution'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: resultHeading3('Design 1'),
                        ),
                        buildParameterRow(
                            'X1', calculatedData[4].toStringAsExponential(3)),
                        buildParameterRow(
                            (capOrInd('X', calculatedData[4])),
                            capOrIndValue(capIndValues[4],
                                capOrInd('X', calculatedData[4]))),

                        buildParameterRow(
                            'B1', calculatedData[6].toStringAsExponential(3)),
                        buildParameterRow(
                            (capOrInd('b', calculatedData[6])),
                            capOrIndValue(capIndValues[6],
                                capOrInd('b', calculatedData[6]))),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: resultHeading3('Design 2'),
                        ),
                        buildParameterRow(
                            'X2', calculatedData[5].toStringAsExponential(3)),
                        buildParameterRow(
                            (capOrInd('X', calculatedData[5])),
                            capOrIndValue(capIndValues[5],
                                capOrInd('X', calculatedData[5]))),

                        buildParameterRow(
                            'B2', calculatedData[7].toStringAsExponential(3)),
                        buildParameterRow(
                            (capOrInd('b', calculatedData[7])),
                            capOrIndValue(capIndValues[7],
                                capOrInd('b', calculatedData[7]))),

                        // shunt first
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 8),
                          child: resultHeading2('Shunt First Solution'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: resultHeading3('Design 1'),
                        ),
                        buildParameterRow(
                            'B1', calculatedData[2].toStringAsExponential(3)),
                        buildParameterRow(
                            (capOrInd('b', calculatedData[2])),
                            capOrIndValue(capIndValues[2],
                                capOrInd('b', calculatedData[2]))),

                        buildParameterRow(
                            'X1', calculatedData[0].toStringAsExponential(3)),
                        buildParameterRow(
                            (capOrInd('X', calculatedData[0])),
                            capOrIndValue(capIndValues[0],
                                capOrInd('X', calculatedData[0]))),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: resultHeading3('Design 2'),
                        ),
                        buildParameterRow(
                            'B2', calculatedData[3].toStringAsExponential(3)),
                        buildParameterRow(
                            (capOrInd('b', calculatedData[3])),
                            capOrIndValue(capIndValues[3],
                                capOrInd('b', calculatedData[3]))),

                        buildParameterRow(
                            'X2', calculatedData[1].toStringAsExponential(3)),
                        buildParameterRow(
                            (capOrInd('X', calculatedData[1])),
                            capOrIndValue(capIndValues[1],
                                capOrInd('X', calculatedData[1]))),
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
                        buildParameterRow('d/\u03BB',
                            calculatedData[2].toStringAsExponential(3)),
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
                        buildParameterRow('d/\u03BB',
                            calculatedData[3].toStringAsExponential(3)),
                        buildParameterRow(
                            'B', calculatedData[5].toStringAsExponential(3)),
                        buildParameterRow('L/\u03BB (open)',
                            calculatedData[7].toStringAsExponential(3)),
                        buildParameterRow('L/\u03BB (short)',
                            calculatedData[9].toStringAsExponential(3)),
                      ],
                    ),
                ],
              ),

            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: resultHeading2('Your Inputs:'),
            ),
            // show user inputs: Z0, ZL, f
            buildParameterRow('Z0', '${userInputs[0].toStringAsFixed(1)} Ω'),
            buildParameterRow('ZL',
                '(${userInputs[1].toStringAsFixed(1)}) +\nj(${userInputs[2].toStringAsFixed(1)}) Ω'),
            buildParameterRow(
                'Frequency', '${userInputs[3].toStringAsExponential(3)} Hz'),
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
          const SizedBox(width: 7), // Add spacing between label and value
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

  static Widget buildCircuitDiagram(String label, String matchingNetworkType) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
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
          resultHeading1('Circuit Diagram'),

          const SizedBox(height: 8),
          Expanded(
            child: Center(
              // Replace this placeholder with your actual image loading
              child: Image.asset(
                (matchingNetworkType == 'quarterwave')
                    ? 'assets/qwt_diag.PNG'
                    : (matchingNetworkType == 'lumped')
                        ? 'assets/lumped_diag.PNG'
                        : 'assets/stub_diag.PNG',
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
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.text1,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildImpedanceGraph(List<FlSpot> impedanceData,
      {List<FlSpot>? secondaryData, double? userFrequency}) {
    const double paddingX = 0.1; // MHz
    const double paddingY = 1.0; // Ohms

    // Combine datasets for calculating bounds
    List<FlSpot> allData = [...impedanceData];
    if (secondaryData != null && secondaryData.isNotEmpty) {
      allData.addAll(secondaryData);
    }

    // Calculate data bounds with padding
    double minX =
        allData.map((e) => e.x).reduce((a, b) => a < b ? a : b) - paddingX;
    double maxX =
        allData.map((e) => e.x).reduce((a, b) => a > b ? a : b) + paddingX;
    double minY =
        (allData.map((e) => e.y).reduce((a, b) => a < b ? a : b) - paddingY)
            .clamp(0.0, double.infinity);
    double maxY =
        allData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + paddingY;

    // Calculate appropriate intervals - FIXED: Use fewer intervals to prevent overlapping
    double xRange = maxX - minX;
    // Reduce number of x-axis labels to prevent overlapping
    double xInterval = (xRange / 4).roundToDouble().clamp(1, double.infinity);

    double yRange = maxY - minY;
    double yInterval = (yRange / 5).roundToDouble().clamp(1, double.infinity);

    return Container(
      padding: const EdgeInsets.only(top: 25, left: 3, right: 8),
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
          resultHeading1('Impedance vs Frequency'),

          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
                left: 8.0,
                top: 8.0,
                bottom: 15,
              ),
              child: LineChart(
                LineChartData(
                  gridData: _buildGridData(xInterval, yInterval, userFrequency),
                  titlesData: _buildTitlesData(minX, maxX, minY, maxY,
                      xInterval, yInterval, userFrequency),
                  borderData: FlBorderData(
                    show: true,
                    border:
                        Border.all(color: AppTheme.bg2.withValues(alpha: 0.5)),
                  ),
                  minX: minX,
                  maxX: maxX,
                  minY: minY,
                  maxY: maxY,
                  lineTouchData: LineTouchData(enabled: true),
                  lineBarsData: _buildLineBarsData(
                      impedanceData, secondaryData, userFrequency),
                  extraLinesData: _buildExtraLinesData(userFrequency),
                ),
              ),
            ),
          ),
          // Legend for multiple data series
          if (secondaryData != null && secondaryData.isNotEmpty)
            _buildSeriesLegend(),
          // Legend for user frequency
          if (userFrequency != null) _buildFrequencyLegend(userFrequency),
        ],
      ),
    );
  }

  static Widget buildPCBParametersCard(List<double> userInputs,
      List<double> calculatedData, String matchingNetwork,
      {Map<String, double>? quarterWaveResults,
      Map<String, double>? singleStubResults}) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 20),
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
              'PCB Parameters',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.text1,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  if (matchingNetwork.contains('Quarter')) ...[
                    buildParameterRow('Transformer Width',
                        '${calculatedData[0].toStringAsExponential(2)} mm'),
                    buildParameterRow('Transformer Length',
                        '${calculatedData[1].toStringAsExponential(2)} mm'),
                    if (quarterWaveResults != null)
                      buildParameterRow('Transformer Impedance',
                          '${quarterWaveResults['impedance']?.toStringAsFixed(1)} Ω'),
                  ] else if (matchingNetwork.contains('Stub')) ...[
                    buildParameterRow('Main Line Width',
                        '${calculatedData[0].toStringAsExponential(2)} mm'),
                    buildParameterRow('Stub Length',
                        '${calculatedData[1].toStringAsExponential(2)} mm'),
                    if (calculatedData.length > 2)
                      buildParameterRow('Distance to Stub',
                          '${calculatedData[2].toStringAsExponential(2)} mm'),
                    if (singleStubResults != null) ...[
                      buildParameterRow('Stub Electrical Length',
                          '${singleStubResults['stubElectricalLength']?.toStringAsFixed(1)}°'),
                      buildParameterRow('Distance Electrical Length',
                          '${singleStubResults['electricalLengthToStub']?.toStringAsFixed(1)}°'),
                    ],
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 10),
              child: resultHeading2('Your Inputs:'),
            ),
            buildParameterRow('Dielectric height',
                '${userInputs[0].toStringAsExponential(2)} mm'),
            buildParameterRow('\u03B5r', userInputs[1].toString()),
            buildParameterRow('Z0', '${userInputs[2].toStringAsFixed(1)} Ω'),
            buildParameterRow(
                'Frequency', '${userInputs[3].toStringAsExponential(3)} GHz'),
            buildParameterRow('Load Impedance',
                '${userInputs[4].toStringAsFixed(1)} ${userInputs[5] >= 0 ? '+ j' : '- j'}${userInputs[5].abs().toStringAsFixed(1)} Ω'),
          ],
        ),
      ),
    );
  }

  static Widget buildPCBDiagram(List<double> calculatedData,
      List<double> userInputs, String matchingNetwork) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${matchingNetwork.contains('Quarter') ? 'Quarter-Wave' : 'Single Stub'} Dimensions',
              style: TextStyle(
                color: AppTheme.text1,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Image.asset('assets/microstrip_diag.PNG', fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
              return Container(
                  color: AppTheme.bg2.withValues(alpha: 0.3),
                  child: Center(
                      child: Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: AppTheme.text1,
                  )));
            }),
            // Expanded(
            //   child: matchingNetwork.contains('Quarter')
            //       ? CustomPaint(
            //           size: Size.infinite,
            //           painter: QuarterWavePainter(
            //             transformerWidth: calculatedData[0],
            //             mainLineWidth: Calculations.estimateWidth(
            //                 userInputs[2], userInputs[0], userInputs[1]),
            //             substrateHeight: userInputs[0],
            //           ),
            //         )
            //       : CustomPaint(
            //           size: Size.infinite,
            //           painter: SingleStubPainter(
            //             mainLineWidth: calculatedData[0],
            //             stubLength: calculatedData[1],
            //             distanceToStub:
            //                 calculatedData.length > 2 ? calculatedData[2] : 0,
            //             substrateHeight: userInputs[0],
            //           ),
            //         ),
            // ),
            const SizedBox(height: 20),
            if (matchingNetwork.contains('Quarter'))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    buildParameterRow('Width',
                        '${calculatedData[0].toStringAsExponential(2)} mm'),
                    buildParameterRow('Length',
                        '${calculatedData[1].toStringAsExponential(2)} mm'),
                    buildParameterRow('Dielectric Height',
                        '${userInputs[0].toStringAsExponential(2)} mm'),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    buildParameterRow('Line Width',
                        '${calculatedData[0].toStringAsExponential(2)} mm'),
                    buildParameterRow('Stub Length',
                        '${calculatedData[1].toStringAsExponential(2)} mm'),
                    if (calculatedData.length > 2)
                      buildParameterRow('Distance to Stub',
                          '${calculatedData[2].toStringAsExponential(2)} mm'),
                    buildParameterRow('Substrate Height',
                        '${userInputs[0].toStringAsExponential(2)} mm'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

// Helper method for grid data
  static FlGridData _buildGridData(
      double xInterval, double yInterval, double? userFrequency) {
    return FlGridData(
      show: true,
      horizontalInterval: yInterval,
      verticalInterval: xInterval,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: AppTheme.bg2.withValues(alpha: 0.3),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        // Highlight the user frequency with a different color if provided
        if (userFrequency != null && (value - userFrequency).abs() < 0.01) {
          return FlLine(
            color: Colors.orangeAccent.withValues(alpha: 0.7),
            strokeWidth: 2,
            dashArray: [5, 5],
          );
        }
        return FlLine(
          color: AppTheme.bg2.withValues(alpha: 0.3),
          strokeWidth: 1,
        );
      },
    );
  }

// Helper method for titles data
  static FlTitlesData _buildTitlesData(double minX, double maxX, double minY,
      double maxY, double xInterval, double yInterval, double? userFrequency) {
    return FlTitlesData(
      show: true,
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        axisNameWidget: Text(
          'Frequency (MHz)',
          style: TextStyle(color: AppTheme.text1, fontSize: 12),
        ),
        axisNameSize: 24,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: xInterval,
          getTitlesWidget: (value, meta) {
            // FIXED: Skip more labels to prevent overlapping
            // Only show labels at multiples of the interval to prevent overcrowding
            if (value < minX ||
                value > maxX ||
                (value % (xInterval) > 0.01 && value != userFrequency)) {
              return const SizedBox.shrink();
            }

            bool isUserFreq =
                userFrequency != null && (value - userFrequency).abs() < 0.01;

            String displayValue = (value / 1000000).toStringAsFixed(2);

            return Text(
              displayValue,
              style: TextStyle(
                color: isUserFreq ? AppTheme.bg5 : AppTheme.text1,
                fontSize: 12,
                fontWeight: isUserFreq ? FontWeight.bold : FontWeight.normal,
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        axisNameWidget: Text(
          'Impedance (Ω)',
          style: TextStyle(color: AppTheme.text1, fontSize: 12),
        ),
        axisNameSize: 24,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: yInterval,
          getTitlesWidget: (value, meta) {
            if (value < minY || value > maxY) {
              return const SizedBox.shrink();
            }
            return Text(
              value.toInt().toString(),
              style: TextStyle(color: AppTheme.text1, fontSize: 12),
            );
          },
        ),
      ),
    );
  }

// Helper method for line bars data
  static List<LineChartBarData> _buildLineBarsData(List<FlSpot> impedanceData,
      List<FlSpot>? secondaryData, double? userFrequency) {
    List<LineChartBarData> result = [
      LineChartBarData(
        spots: impedanceData,
        isCurved: true,
        color: AppTheme.bg4,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          checkToShowDot: (spot, barData) {
            if (userFrequency == null) return false;
            return (spot.x - userFrequency).abs() < 0.01;
          },
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 5,
              color: AppTheme.bg4,
              strokeWidth: 2,
              strokeColor: Colors.white,
            );
          },
        ),
        belowBarData: BarAreaData(
          show: true,
          color: AppTheme.bg4.withValues(alpha: 0.2),
        ),
      ),
    ];

    if (secondaryData != null && secondaryData.isNotEmpty) {
      result.add(
        LineChartBarData(
          spots: secondaryData,
          isCurved: true,
          color: AppTheme.bg2,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) {
              if (userFrequency == null) return false;
              return (spot.x - userFrequency).abs() < 0.01;
            },
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 5,
                color: AppTheme.bg2,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: AppTheme.bg2.withValues(alpha: 0.2),
          ),
        ),
      );
    }

    return result;
  }

// Helper method for extra lines data
  static ExtraLinesData? _buildExtraLinesData(double? userFrequency) {
    if (userFrequency == null) return null;

    return ExtraLinesData(
      verticalLines: [
        VerticalLine(
          x: userFrequency,
          color: AppTheme.bg5.withValues(alpha: 0.5),
          strokeWidth: 2,
          dashArray: [5, 5],
          label: VerticalLineLabel(
            show: true,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 5, right: 3),
            style: TextStyle(
              color: AppTheme.bg5.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
            ),
            labelResolver: (line) =>
                '${(userFrequency / 1e6).toStringAsFixed(2)} MHz',
          ),
        ),
      ],
    );
  }

// Helper method for series legend
  static Widget _buildSeriesLegend() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 16,
                height: 4,
                color: AppTheme.bg4,
              ),
              const SizedBox(width: 4),
              Text(
                'Series First',
                style: TextStyle(
                  color: AppTheme.text1,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Row(
            children: [
              Container(
                width: 16,
                height: 4,
                color: AppTheme.bg2,
              ),
              const SizedBox(width: 4),
              Text(
                'Shunt First',
                style: TextStyle(
                  color: AppTheme.text1,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Helper method for frequency legend
  static Widget _buildFrequencyLegend(double userFrequency) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 16,
            height: 4,
            color: AppTheme.bg5,
          ),
          const SizedBox(width: 4),
          Text(
            'Selected: ${(userFrequency / 1e6).toStringAsFixed(2)} MHz',
            style: const TextStyle(
              color: AppTheme.text1,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
