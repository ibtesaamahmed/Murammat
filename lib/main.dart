import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:murammat_app/providers/appointment.dart';
import 'package:murammat_app/providers/auth.dart';
import 'package:murammat_app/providers/customer.dart';
import 'package:murammat_app/providers/history.dart';
import 'package:murammat_app/providers/worker.dart';
import 'package:provider/provider.dart';

import 'providers/my_garage.dart';
import 'screens/costumer/customer_appointment_screen.dart';
import 'screens/costumer/my_garage_screen.dart';
import 'screens/costumer/services_screen.dart';
import 'screens/costumer/shops_customers_screen.dart';
import 'screens/costumer/costumer_tab_screen.dart';
import 'screens/worker/worker_tab_screen.dart';
import 'screens/costumer/costumer_login_screen.dart';
import 'screens/costumer/costumer_signup_screen.dart';
import 'screens/worker/worker_signup_screen.dart';
import 'screens/worker/worker_login_screen.dart';
import 'startpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialColor myColor = MaterialColor(
      Color.fromRGBO(24, 45, 75, 1).value,
      <int, Color>{
        50: Color.fromRGBO(24, 45, 75, 0.1),
        100: Color.fromRGBO(24, 45, 75, 0.2),
        200: Color.fromRGBO(24, 45, 75, 0.3),
        300: Color.fromRGBO(24, 45, 75, 0.4),
        400: Color.fromRGBO(24, 45, 75, 0.5),
        500: Color.fromRGBO(24, 45, 75, 0.6),
        600: Color.fromRGBO(24, 45, 75, 0.7),
        700: Color.fromRGBO(24, 45, 75, 0.8),
        800: Color.fromRGBO(24, 45, 75, 0.9),
        900: Color.fromRGBO(24, 45, 75, 1),
      },
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Garage>(
          create: ((context) => Garage('', '', [])),
          update: ((context, auth, previousGarage) => Garage(
                auth.token,
                auth.userId,
                previousGarage == null ? [] : previousGarage.items,
              )),
        ),
        ChangeNotifierProxyProvider<Auth, Worker>(
          create: (context) => Worker('', ''),
          update: (context, auth, _) => Worker(
            auth.token,
            auth.userId,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Customer>(
          create: (context) => Customer('', ''),
          update: (context, auth, _) => Customer(auth.token, auth.userId),
        ),
        ChangeNotifierProxyProvider<Auth, MyHistory>(
          create: (context) => MyHistory(''),
          update: (context, auth, _) => MyHistory(auth.userId),
        ),
        ChangeNotifierProxyProvider<Auth, Appointments>(
          create: (context) => Appointments(''),
          update: (context, auth, _) => Appointments(auth.userId),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Murammat',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(24, 45, 75, 1),
          canvasColor: const Color.fromRGBO(206, 206, 206, 1),
          textTheme: const TextTheme(
              headline6: TextStyle(color: Colors.black, fontSize: 18)),
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.white,
            color: Color.fromRGBO(24, 45, 75, 1),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: Color.fromRGBO(24, 45, 75, 1)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(24, 45, 75, 1)),
            ),
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: myColor)
              .copyWith(secondary: const Color.fromRGBO(206, 206, 206, 100)),
        ),
        initialRoute: '/',
        routes: {
          '/': ((context) => StartPage()),
          //--//
          CostumerLoginScreen.routeName: (context) => CostumerLoginScreen(),
          CostumerSignupScreen.routeName: (context) => CostumerSignupScreen(),
          //--//
          WorkerLoginScreen.routeName: (context) => WorkerLoginScreen(),
          WorkerSignupScreen.routeName: (context) => WorkerSignupScreen(),
          //--//
          CostumerTabScreen.routeName: (context) => CostumerTabScreen(),
          WorkerTabScreen.routeName: (context) => WorkerTabScreen(),
          //--//
          ServicesScreen.routeName: (context) => ServicesScreen(),
          //--//
          ShopsCustomerScreen.routeName: (context) => ShopsCustomerScreen(),
          //--//
          CutomerAppointmentScreen.routeName: (context) =>
              CutomerAppointmentScreen(),
          //--//
          MyGarageScreen.routeName: (context) => MyGarageScreen(),
          //--//
        },
      ),
    );
  }
}
