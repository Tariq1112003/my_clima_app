import 'dart:ffi';

import 'package:clima/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class loadingWidget extends StatelessWidget {
  const loadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      backgroundColor: Colors.white10,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min  ,
          children: [
            SpinKitPulse (
              color: kLightColor,
              size: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Fetching data',
              style: TextStyle(fontSize: 22, color:kMidLightColor),
            )
          ],
        ),
      ),
    );
  }
}
