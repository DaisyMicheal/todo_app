import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      SplashPage(
        imagePath: 'assets/splash2.png',  // Use PNG for transparency
        title: 'TO DO',
        description: '',
        buttonLabel: 'Next',
        onNext: _nextPage,
        onSkip: _skip,
      ),
      SplashPage(
        imagePath: 'assets/splash1.png',  // Use PNG for transparency
        title: 'Add Task',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        buttonLabel: 'Next',
        onNext: _nextPage,
        onSkip: _skip,
      ),
      SplashPage(
        imagePath: 'assets/splash3.png',  // Use PNG for transparency
        title: 'Reminder',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        buttonLabel: 'Get Started',
        onNext: _skip,
        onSkip: _skip,
      ),
    ]);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // Navigate to home page or any other page
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => TodoHomePage()),
      // );
    }
  }

  void _skip() {
    // Navigate to home page or any other page
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) => TodoHomePage()),
    // );
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _pages[index];
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: _skip,
              child: Text(
                'Skip',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  SplashPage({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: ElevatedButton(
              onPressed: onNext,
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
