import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'package:tradingapp/Screens/Mainscreens/Dashboard/dashboard_screen.dart';
// Assuming this is for the Market tab
import 'package:tradingapp/Screens/Mainscreens/market_watch_screen.dart';
import 'package:tradingapp/Screens/Mainscreens/portfolio_screen.dart';
import 'package:tradingapp/Screens/Mainscreens/position_screen.dart';
import 'package:tradingapp/Screens/Mainscreens/profilepage_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
 

  @override
  void initState() {
    super.initState();
    
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
      ),
    );
    // Make Flutter draw behind navigation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  List<Widget> _buildScreens() {
    return [
      DashboardScreen(),
      PortfolioScreen(),
      MarketWatchScreen(),
      PositionScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        screen: DashboardScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.pie_chart),
          title: "Dashboard",
        ),
      ),
      PersistentTabConfig(
        screen: PortfolioScreen(), // Assuming MarketScreen for "Market" tab
        item: ItemConfig(
          icon: const Icon(Icons.attach_money), // Consider a more suitable icon
          title: "Portfolio",
        ),
      ),
      PersistentTabConfig(
        screen: MarketWatchScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.watch),
          title: "Market Watch",
        ),
      ),
      PersistentTabConfig(
        screen: PositionScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.podcasts),
          title: "Position",
        ),
      ),
      PersistentTabConfig(
        screen: ProfileScreen(),
        item: ItemConfig(
          icon: const Icon(Icons.person),
          title: "Profile",
        ),
      ),
    ];
  }


  Widget build(BuildContext context) => PersistentTabView(
        tabs: _tabs(),
        navBarBuilder: (navBarConfig) => Style6BottomNavBar(
          navBarConfig: navBarConfig,
        ),
      );
      
  }


