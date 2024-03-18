import 'package:adminmmas/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/allKPIWidgets.dart';
import 'package:adminmmas/componnents/responsive.dart';

class RespDashboardView extends StatelessWidget {
  const RespDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                color: Colors.grey[200]
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //if (Responsive.isDesktop(context))
                  //   SideBar(
                  //     postion: 0,
                  //       msg:"Coach"
                  //   ),
                  Expanded(
                    flex: 3,
                    child: DashboardScreen(),
                  ),
                ],
              ),
            )));
  }
}