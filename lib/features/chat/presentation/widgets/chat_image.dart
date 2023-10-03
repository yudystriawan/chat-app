import 'package:cached_network_image/cached_network_image.dart';
import '../../../../shared/show_image_dialog.dart';
import 'package:core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatImageNetwork extends StatelessWidget {
  const ChatImageNetwork({
    Key? key,
    required this.imageUrl,
    this.height,
    this.width,
    this.borderRadius,
  }) : super(key: key);

  final String imageUrl;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return GestureDetector(
          onTap: () => showImageDialog(context, imageUrl: imageUrl),
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(4.r),
            clipBehavior: Clip.hardEdge,
            child: Container(
              height: height ?? 218.w,
              width: width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.centerLeft,
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return const SizedBox();
      },
      errorWidget: (context, url, error) {
        if (url.isEmpty) return const SizedBox();

        return Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(4.r),
          ),
          child: Icon(
            Icons.broken_image_outlined,
            size: 24.w,
            color: NeutralColor.white,
          ),
        );
      },
    );
  }
}
