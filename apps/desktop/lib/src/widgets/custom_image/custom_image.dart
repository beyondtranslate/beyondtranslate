import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage(
    this.url, {
    Key? key,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        return progress == null
            ? child
            : Center(
                child: CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          (progress.expectedTotalBytes ?? 0)
                      : null,
                ),
              );
      },
      errorBuilder: (ctx, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.red,
        );
      },
    );
  }
}
