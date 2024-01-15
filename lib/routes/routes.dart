import 'package:agenda_canchas/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../screens/scheduling_screen.dart';



Route<dynamic>? onGeneratedRoutes(RouteSettings settings) {
    switch (settings.name) {
        case "Home":
            return PageTransition(
                duration: const Duration(milliseconds: 200),
                //child: const PublicHomeScreen(),
                child:  const HomeScreen(),
                type: PageTransitionType.rightToLeft);

        default:
            return PageTransition(
                duration: const Duration(milliseconds: 200),
                child: customRoutes[settings.name]!,
                type: PageTransitionType.fade,
                settings: settings);
    }
}

var customRoutes = <String, Widget>{
    "home"  : const HomeScreen(),
    "Scheduling"  :  SchedulingScreen(),
};
