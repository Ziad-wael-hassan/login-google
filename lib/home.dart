import 'package:flutter/material.dart';
import 'package:nadaushd/profile_page.dart';
import 'package:nadaushd/notifications_page.dart';
import 'package:nadaushd/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  AnimationController? _controller;
  late Animation<double> _animation;

  final List<Widget> _pages = [
    ProfilePage(),
    NotificationsPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeOutBack));
  }

  void _onItemTapped(int index) {
    if (!mounted || _controller == null) return;
    setState(() {
      _currentIndex = index;
      _controller!.reset();
      _controller!.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipPath(
            child: Container(
              height: 80,
              decoration: BoxDecoration(color: Color(0xFF18181B)),
              child: Stack(),
            ),
          ),
          BottomAppBar(
            shape: CircularNotchedRectangle(),
            color: Colors.transparent,
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 0.3, color: Colors.grey),
                SizedBox(height: 6.1),
                Expanded(
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(vertical: 0.3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(3, (index) {
                        return GestureDetector(
                          onTap: () => _onItemTapped(index),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_currentIndex == index)
                                AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(0, -_animation.value * 6),
                                      child: child,
                                    );
                                  },
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              AnimatedScale(
                                scale: _currentIndex == index ? 1.2 : 1.0,
                                duration: Duration(milliseconds: 200),
                                child: Icon(
                                  _getIcon(index),
                                  color:
                                      _currentIndex == index
                                          ? const Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          )
                                          : Colors.grey,
                                ),
                              ),
                              AnimatedOpacity(
                                opacity: _currentIndex == index ? 1.0 : 0.6,
                                duration: Duration(milliseconds: 200),
                                child: Text(
                                  _getLabel(index),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        _currentIndex == index
                                            ? const Color.fromARGB(
                                              255,
                                              255,
                                              255,
                                              255,
                                            )
                                            : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person;
      case 1:
        return Icons.notifications;
      case 2:
        return Icons.settings;
      default:
        return Icons.home;
    }
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return "Profile";
      case 1:
        return "Notifications";
      case 2:
        return "Settings";
      default:
        return "";
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
