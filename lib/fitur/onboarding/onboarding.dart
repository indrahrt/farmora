import 'package:flutter/material.dart';
import '../login/pages/login.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "teks": "Sedih karna harga jual beli panen tidak sesuai ekspetasi",
      "petani": "assets/images/petani_sedih.png",
    },
    {
      "teks": "Bingung mau jual beli dimana??",
      "petani": "assets/images/petani_bingung.png",
    },
    {
      "teks": "Disini saja, harga sesuai tanpa ada potongan!!",
      "petani": "assets/images/petani_ceria.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFC5E898), Color(0xFF74B95E)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingContent(
                    teks: _onboardingData[index]["teks"]!,
                    petani: _onboardingData[index]["petani"]!,
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage != 0
                      ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.black,
                            ),
                            elevation: WidgetStateProperty.all(0),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),

                            overlayColor:
                                WidgetStateProperty.resolveWith<Color?>((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Colors.green.withValues(alpha: 0.5);
                                  }
                                  return null;
                                }),
                          ),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          child: const Text('Sebelumnya'),
                        )
                      : const SizedBox.shrink(),

                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      foregroundColor: WidgetStateProperty.all(Colors.black),
                      elevation: WidgetStateProperty.all(0),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      overlayColor: WidgetStateProperty.resolveWith<Color?>((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.green.withValues(alpha: 0.5);
                        }
                        return null;
                      }),
                    ),
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                    child: Text(
                      _currentPage == _onboardingData.length - 1
                          ? 'Daftar Sekarang'
                          : 'Selanjutnya',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String teks, petani;
  const OnboardingContent({
    super.key,
    required this.teks,
    required this.petani,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned(
              bottom: 0,
              left: -150,
              right: 20,
              child: Image.asset(
                petani,
                height: constraints.maxHeight * 0.7,
                fit: BoxFit.contain,
              ),
            ),

            Positioned(
              top: constraints.maxHeight * 0.25,
              right: 20,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/pikiran.png', width: 250),
                  Container(
                    width: 150,
                    padding: const EdgeInsets.only(bottom: 35),
                    child: Text(
                      teks,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
