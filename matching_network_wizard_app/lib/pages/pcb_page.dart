import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:complex/complex.dart';
import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/app_theme.dart';
import 'package:matching_network_wizard_app/utils/app_widgets.dart';
import 'package:matching_network_wizard_app/utils/button_funcs.dart';
import 'package:matching_network_wizard_app/utils/calculations.dart';
import 'package:matching_network_wizard_app/utils/saved_data.dart';

class PcbPage extends StatefulWidget {
  const PcbPage({super.key});

  @override
  State<PcbPage> createState() => _PcbPageState();
}

class _PcbPageState extends State<PcbPage> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final List<String> _pageLabels = ['Parameters', 'PCB'];
  int _currentIndex = 0;

  String matchingNetwork = '';
  List<double> userInputs = [
    0,
    0,
    0,
    0,
    0
  ]; // [height, epsilonR, z0, f, zLRe, zLIm]
  List<double> calculatedData = [0, 0, 0]; // [width, length]
  Map<String, double>? quarterWaveResults;
  Map<String, double>? singleStubResults;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  Future<void> loadResults() async {
    double height = await SavedData.getHeight();
    double epsilonR = await SavedData.getEpsilonR();
    double z0 = await SavedData.getZ0();
    double f = await SavedData.getF();
    Complex zL = await SavedData.getZL();
    double zLRe = zL.real;
    double zLIm = zL.imaginary;
    userInputs = [height * 1000, epsilonR, z0, f, zLRe, zLIm];

    // Calculate both solutions
    quarterWaveResults =
        Calculations.quarterWaveTransformer(z0, zLRe, f, height, epsilonR);
    singleStubResults = Calculations.singleStubMatch(
        z0, zLRe, zLIm, f, height, epsilonR, true); // true for open stub

    String matchingNetworkType = await SavedData.getMatchingNetworkType();
    if (matchingNetworkType == 'quarterwave') {
      matchingNetwork = 'Quarter-Wave\n';

      double width = quarterWaveResults!['width']!;
      double length = quarterWaveResults!['length']!;
      calculatedData = [width, length];
    } else if (matchingNetworkType == 'singlestub') {
      matchingNetwork = 'Stub ';

      double width = Calculations.estimateWidth(z0, height, epsilonR);
      double stubLength = singleStubResults!['stubLength']!;
      double distanceToStub = singleStubResults!['distanceToStub']!;
      calculatedData = [width, stubLength, distanceToStub];
    } else {
      // Default case
      matchingNetwork = 'Unknown';
      calculatedData = [];
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    // output area
    return Scaffold(
      backgroundColor: AppTheme.bg5,
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

                  // heading: PCB Design
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 35),
                    child: AppWidgets.headingText('PCB Design', AppTheme.text2),
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
                            ? AppTheme.bg2
                            : AppTheme.bg3.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: _currentIndex == index
                              ? AppTheme.text2
                              : AppTheme.text3,
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
                    AppWidgets.buildPCBParametersCard(
                      userInputs,
                      calculatedData,
                      matchingNetwork,
                      quarterWaveResults: matchingNetwork.contains('Quarter')
                          ? quarterWaveResults
                          : null,
                      singleStubResults: matchingNetwork.contains('Stub')
                          ? singleStubResults
                          : null,
                    ),
                    AppWidgets.buildPCBDiagram(
                      calculatedData,
                      userInputs,
                      matchingNetwork,
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

              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(bottom: 55),
                child: AppWidgets.greenButton(
                    'Regenerate', () => ButtonFuncs.regenBtn(context, true)),
              ),

              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom: 55, left: 35),
              //     child: AppWidgets.greenButton(
              //         'Regenerate', () => ButtonFuncs.regenBtn(context)),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 49, right: 32),
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       // Add your action here
      //     },
      //     backgroundColor: AppTheme.bg2,
      //     foregroundColor: AppTheme.text2,
      //     child: const Icon(Icons.save),
      //   ),
      // ),
    );
  }
}
