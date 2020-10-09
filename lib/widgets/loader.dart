import 'package:flutter/material.dart';

Widget showLoader(
    {@required BuildContext context,
    double size = 30.0,
    double opacity = 0.7,
    @required bool isLoadingVar}) {
  return Visibility(
    visible: isLoadingVar,
    child: Center(child: CircularProgressIndicator())
    // Container(
    //     width: double.infinity,
    //     height: MediaQuery.of(context).size.height,
    //     color: Colors.white.withOpacity(opacity),
    //     child: Container(height: 16.0, width: 16.0, child: )),
  );
}
