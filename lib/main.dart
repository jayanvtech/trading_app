import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradingapp/Authentication/Login_bloc/login_bloc.dart';
import 'package:tradingapp/Authentication/tpin_screen.dart';
import 'package:tradingapp/Screens/IPOsScreen/IPOsScreen.dart';
import 'package:tradingapp/Screens/option_chain_screen/option_chain_screen.dart';
import 'package:tradingapp/Utils/changenotifier.dart';
import 'package:tradingapp/Authentication/login_screen.dart';
import 'package:tradingapp/Utils/Bottom_nav_bar_screen.dart';
import 'package:tradingapp/Screens/Mainscreens/position_screen.dart';
import 'package:tradingapp/Sockets/market_feed_scoket.dart';
import 'package:tradingapp/master/nscm_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  MarketFeedSocket marketFeedSocket = MarketFeedSocket();
  //await ApiService().GetNSCEMMaster();
  // marketFeedSocket.connect();
  // await NscmDataProvider().fetchAndStoreData();

  //MarketFeedSocket marketFeedSocket = MarketFeedSocket();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: marketFeedSocket,
        ),
        ChangeNotifierProvider(
          create: (_) => MarketFeedSocket()..connect(),
        ),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => TradeProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

Future<bool> isUserLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  return token != null;
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool? isLoginValue = false;

  @override
  void initState() {
    super.initState();
    isLogin();
    init();
  }

  Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoginValue = prefs.getBool('isLogin');
    return isLoginValue != null;
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MarketWatchManager(),
            child: MyApp(),
          ),
          ChangeNotifierProvider(
            create: (context) => NscmDataProvider(),
          ),
        ],
        child: ChangeNotifierProvider(
          create: (_) => MarketFeedSocket()..connect(),
          // child: isLoginValue == false ? LoginScreen() : ValidPasswordScreen(),
          child: FutureBuilder<bool>(
            future: isLogin(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                if (snapshot.data == true && isLoginValue == true) {
                  return ValidPasswordScreen(
                    isFromMainScreen: "true",
                  );
                } else {
                  return LoginScreen();
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
