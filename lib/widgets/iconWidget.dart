import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconFutureWidget extends FutureBuilder<SvgPicture?> {
  IconFutureWidget({
    super.key,
    required Future<SvgPicture?> super.future,
    Widget Function(BuildContext, SvgPicture data)? onSuccess,
    Widget Function(BuildContext)? onLoading,
    Widget Function(BuildContext, Object error)? onError,
    required bool isRounded,
  }) : super(
         builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return onLoading?.call(context) ??
                 Image.file(
                   File("assets/icons/position/LANE.svg"),
                   width: 200,
                   fit: BoxFit.contain,
                 );
           } else if (snapshot.hasError) {
             return onError?.call(context, snapshot.error!) ??
                 Center(child: Text("Error: ${snapshot.error}"));
           } else if (snapshot.hasData) {
             return onSuccess?.call(context, snapshot.data!) ??
                 _defaultIconDisplay(snapshot.data!, isRounded);
           } else {
             return const Center(child: Text("No data found"));
           }
         },
       );

  static Widget _defaultIconDisplay(SvgPicture icon, bool isRounded) {
    return icon;
  }
}
