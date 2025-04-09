import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/app_theme.dart';
import 'package:matching_network_wizard_app/utils/app_widgets.dart';
import 'package:matching_network_wizard_app/utils/button_funcs.dart';

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

  @override
  Widget build(BuildContext context) {
    // inputs for epsilon_r, height, width, length, and thickness
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
                    AppWidgets.buildPCBParametersCard(),
                    AppWidgets.buildPCBDiagram(),
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
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 55, left: 35),
                  child: AppWidgets.greenButton(
                      'Regenerate', () => ButtonFuncs.regenBtn(context)),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 49, right: 32),
        child: FloatingActionButton(
          onPressed: () {
            // Add your action here
          },
          backgroundColor: AppTheme.bg2,
          foregroundColor: AppTheme.text2,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
