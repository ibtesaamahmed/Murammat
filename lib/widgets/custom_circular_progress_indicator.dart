import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/images/logo.png",
            color: Theme.of(context).primaryColor,
            fit: BoxFit.cover,
            height: 30,
            width: 30,
          ),
          // you can replace
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            strokeWidth: 2,
          ),
        ],
      ),
    );
  }
}
