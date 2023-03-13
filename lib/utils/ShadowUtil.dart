import 'package:flutter/material.dart';

class ShadowUtil{

  static List<BoxShadow> getCommonShadow(){
    return [
      const BoxShadow(
        color: Colors.black,
        spreadRadius: 1,
        offset: Offset(0, 1),
        blurRadius: 4
      )
    ];
  }
}