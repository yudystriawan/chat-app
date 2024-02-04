import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageRender extends StatelessWidget {
  const ImageRender(
    this.assetPath, {
    super.key,
    this.width,
    this.height,
    this.package,
  });

  final String assetPath;
  final String? package;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(assetPath, package: package),
      width: width,
      height: height,
      loadingBuilder: (_, child, loadingProgress) {
        return SizedBox(
          width: width,
          height: height,
          child: loadingProgress?.cumulativeBytesLoaded ==
                  loadingProgress?.expectedTotalBytes
              ? child
              : const CircularProgressIndicator.adaptive(),
        );
      },
      errorBuilder: (_, error, __) {
        log('cannot render image', error: error);
        return SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              size: width == null ? 48.w : width! * .25,
            ),
          ),
        );
      },
    );
  }
}
