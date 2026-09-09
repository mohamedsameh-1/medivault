import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/feature/history/views/history_view.dart';
import 'package:medivault/feature/home/ui/views/home_view.dart';
import 'package:medivault/feature/navigation/view/custom_button_nav_bar.dart';
import 'package:medivault/feature/profile/view/profile_view.dart';
import 'package:medivault/feature/report/view/report_view.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _HomeViewState();
}

class _HomeViewState extends State<NavigationView> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeView(),
    HistoryView(),
    ReportView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        onAddVisitPressed: () {
          // Navigate to Add Visit
          print('Add Visit');
        },
      ),
    );
  }
}
