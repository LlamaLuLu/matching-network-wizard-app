import 'package:complex/complex.dart';
import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/models/impedance_point.dart';
import 'package:matching_network_wizard_app/models/matching_networks.dart';
import 'package:matching_network_wizard_app/utils/app_theme.dart';
import 'package:matching_network_wizard_app/utils/app_widgets.dart';
import 'package:matching_network_wizard_app/utils/button_funcs.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:matching_network_wizard_app/utils/calculations.dart';
import 'package:matching_network_wizard_app/utils/saved_data.dart';
import 'package:matching_network_wizard_app/models/impedance_graph.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final List<String> _pageLabels = ['Parameters', 'Circuit', 'Graph'];
  int _currentIndex = 0;

  // retrieved data
  String matchingNetworkType = '';
  String matchingNetwork = '';
  bool autoMode = false;
  bool isMatched = false;
  List<double> userInputs = [0, 0, 0, 0]; // [z0, zLRe, zLIm, f]
  List<double> calculatedData = [0, 0, 0, 0, 0, 0, 0, 0]; //
  List<double> capIndValues = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; // [xA[0], xA[1], bA[0], bA[1], xB[0], xB[1], bB[0], bB[1]]

  // for quarterwave
  List<ImpedancePoint> quarterWavePts = [];
  List<FlSpot> flSpots = [];
  // for lumped
  List<FlSpot> lumpedSeriesPts = [];
  List<FlSpot> lumpedShuntPts = [];
  // for single stub
  List<FlSpot> singleStubPts = [];

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  Future<void> loadResults() async {
    // auto-mode
    bool auto = await SavedData.getAutoMode();
    autoMode = auto;
    debugPrint('Auto Mode: $autoMode');
    // matched
    bool matched = await SavedData.getMatched();
    isMatched = matched;
    debugPrint('Matched: $isMatched');

    // user inputs
    double z0 = await SavedData.getZ0();
    Complex zL = await SavedData.getZL();
    double f = await SavedData.getF();
    userInputs = [z0, zL.real, zL.imaginary, f];
    debugPrint('Retrieved User Inputs: $userInputs');

    // matching network type & calculated data
    matchingNetworkType = await SavedData.getMatchingNetworkType();
    debugPrint('Retrieved Matching Network Type: $matchingNetworkType');

    if (matchingNetworkType == 'quarterwave') {
      matchingNetwork = 'Quarter Wave Transformer';

      double zQWT = await SavedData.getZQWT();
      double lambdaDiv4 = Calculations.lambdaDiv4(f);
      debugPrint('ZQWT: $zQWT, LambdaDiv4: $lambdaDiv4');

      calculatedData = [zQWT, lambdaDiv4];

      quarterWavePts = computeQuarterWaveSweep(
        ZL: zL,
        Z0: z0,
        f0MHz: f,
      );
      flSpots = ImpedanceGraph.impedancePointsToFlSpots(quarterWavePts,
          mode: 'magnitude');
    } else if (matchingNetworkType == 'lumped') {
      matchingNetwork = 'Lumped Element Matching';

      List<double> xA = await SavedData.getXA();
      List<double> bA = await SavedData.getBA();
      List<double> xB = await SavedData.getXB();
      List<double> bB = await SavedData.getBB();
      debugPrint('XA: $xA, BA: $bA, XB: $xB, BB: $bB');

      calculatedData = [xA[0], xA[1], bA[0], bA[1], xB[0], xB[1], bB[0], bB[1]];

      List<double> capIndValuesList = await SavedData.getCapIndValues();
      capIndValues = [
        capIndValuesList[0],
        capIndValuesList[1],
        capIndValuesList[2],
        capIndValuesList[3],
        capIndValuesList[4],
        capIndValuesList[5],
        capIndValuesList[6],
        capIndValuesList[7],
      ];
      debugPrint('Capacitance and Inductance Values: $capIndValues');

      lumpedSeriesPts = ImpedanceGraph.generateLumpedElementImpedanceGraph(
        zlReal: zL.real,
        zlImag: zL.imaginary,
        z0: z0,
        f0MHz: f,
        seriesFirst: true,
      );
      lumpedShuntPts = ImpedanceGraph.generateLumpedElementImpedanceGraph(
        zlReal: zL.real,
        zlImag: zL.imaginary,
        z0: z0,
        f0MHz: f,
        seriesFirst: false, // <- switch to shunt-first
      );
    } else if (matchingNetworkType == 'singlestub') {
      matchingNetwork = 'Single Stub Tuning';

      List<double> t = await SavedData.getT();
      List<double> dDivLambda = await SavedData.getDDivLambda();
      List<double> b = await SavedData.getB();
      List<double> lOpenDivLambda = await SavedData.getLOpenDivLambda();
      List<double> lShortDivLambda = await SavedData.getLShortDivLambda();
      debugPrint(
          'T: $t, DDivLambda: $dDivLambda, B: $b, LOpenDivLambda: $lOpenDivLambda, LShortDivLambda: $lShortDivLambda');

      calculatedData = [
        t[0],
        t[1],
        dDivLambda[0],
        dDivLambda[1],
        b[0],
        b[1],
        lOpenDivLambda[0],
        lOpenDivLambda[1],
        lShortDivLambda[0],
        lShortDivLambda[1]
      ];

      Map<String, double> stubParams =
          ImpedanceGraph.computeSingleStubParameters(
        zL: zL,
        z0: z0,
      );

      // Get the calculated parameters
      double distanceToLoad = stubParams['distanceToLoad']!;
      double stubLength = stubParams['stubLength']!;

      // Generate impedance graph data
      singleStubPts = ImpedanceGraph.generateSingleStubImpedanceGraph(
        zlReal: zL.real,
        zlImag: zL.imaginary,
        z0: z0,
        f0MHz: f,
        distanceToLoad: distanceToLoad,
        stubLength: stubLength,
      );
    } else {
      matchingNetwork = 'Auto-Matching Wizard';
    }

    setState(() {});
  }

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
                    padding: const EdgeInsets.only(top: 5, bottom: 25),
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
                    AppWidgets.buildParametersCard(
                        matchingNetworkType,
                        matchingNetwork,
                        autoMode,
                        isMatched,
                        calculatedData,
                        userInputs,
                        capIndValues),
                    AppWidgets.buildCircuitDiagram(
                        matchingNetwork, matchingNetworkType),
                    if (matchingNetworkType == 'quarterwave')
                      AppWidgets.buildImpedanceGraph(flSpots,
                          userFrequency: userInputs[3]),
                    if (matchingNetworkType == 'lumped')
                      AppWidgets.buildImpedanceGraph(
                        lumpedSeriesPts,
                        secondaryData: lumpedShuntPts,
                        userFrequency: userInputs[3],
                      ),
                    if (matchingNetworkType == 'singlestub')
                      AppWidgets.buildImpedanceGraph(
                        singleStubPts,
                      ),
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

              if (matchingNetworkType != 'lumped')
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 35, top: 25, left: 27, right: 27),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppWidgets.greenButton(
                        'Regenerate',
                        () => ButtonFuncs.regenBtn(context, false),
                      ),
                      AppWidgets.greenButton(
                        'PCB Design',
                        () => ButtonFuncs.pcbBtn(context),
                      ),
                    ],
                  ),
                ),

              // if lumped -> regenerate button
              if (matchingNetworkType == 'lumped')
                Padding(
                  padding: const EdgeInsets.only(bottom: 35, top: 25),
                  child: AppWidgets.greenButton(
                      'Regenerate', () => ButtonFuncs.regenBtn(context, false)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
