import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';


class CustomImageView extends StatelessWidget {
  final String imgUrl;
  final double? imgHeight;
  final Color? svgColor;
  final EdgeInsets? imgPadding;
  final BoxFit? imgFit;
  final Uint8List? dummyAssetUrl;

  const CustomImageView(
      {super.key,
        required this.imgUrl,
        this.dummyAssetUrl,
        this.imgHeight,
        this.svgColor,
        this.imgPadding,
        this.imgFit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    AssetImage? assetImage;
    if (imgUrl.contains("assets/") &&
        (imgUrl.endsWith(".png") ||
            imgUrl.endsWith(".jpg") ||
            imgUrl.endsWith(".jpeg"))) {
      assetImage = AssetImage(imgUrl);
      precacheImage(assetImage, context);
    }

    return checkUIType(assetImage);
  }

  Widget checkUIType(assetImage) {
    if ((imgUrl.contains("http://") || imgUrl.contains("https://")) &&
        (imgUrl.endsWith(".png") ||
            imgUrl.endsWith(".jpg") ||
            imgUrl.endsWith(".jpeg"))) {
      return loadNetworkImageFile();
    } else if (imgUrl.contains("assets/") &&
        (imgUrl.endsWith(".json"))) {
      return loadLottieImageFile();
    } else if (imgUrl.contains("assets/") &&
        (imgUrl.endsWith(".png") ||
            imgUrl.endsWith(".jpg") ||
            imgUrl.endsWith(".jpeg"))) {
      return loadAssetImageFile(assetImage);
    } else if (((imgUrl.contains("http://") || imgUrl.contains("https://")) &&
        imgUrl.endsWith(".svg"))) {
      return loadNetworkSvgFile();
    } else if ((imgUrl.endsWith(".svg"))) {
      return loadAssetSvgFile();
    }
    return loadNetworkImageFile();
  }

  Widget loadAssetSvgFile() {
    return Container(
      padding: imgPadding,
      height: imgHeight,
      child: SvgPicture.asset(
        imgUrl,
        height: imgHeight,
        color: svgColor,
        fit: imgFit!,
        placeholderBuilder: (context) => Container(
            width: 30,
            height: 30,
            padding: const EdgeInsets.all(5.0),
            child: const Center(child: CircularProgressIndicator())),
      ),
    );
  }

  Widget loadLottieImageFile() {
    return Container(
        padding: imgPadding,
        height: imgHeight,
        child: Lottie.asset(
          imgUrl,
          height: imgHeight,
          fit: imgFit,
          frameBuilder: (
              _,
              image,
              loadingBuilder,
              ) {
            if (loadingBuilder == null) {
              return Center(
                child: Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.all(5.0),
                    child: const Center(child: CircularProgressIndicator())),
              );
            }
            return image;
          },
          errorBuilder: (_, __, ___) => Image.asset(
            "",
            height: imgHeight,
            fit: BoxFit.contain,
          ),
        ));
  }

  Widget loadNetworkSvgFile() {
    return Container(
      padding: imgPadding,
      height: imgHeight,
      child: SvgPicture.network(
        imgUrl,
        fit: imgFit!,
        height: imgHeight,
        placeholderBuilder: (BuildContext context) => Center(
          child: Container(
              width: 30,
              height: 30,
              padding: const EdgeInsets.all(5.0),
              child: const CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget loadAssetImageFile(AssetImage assetImage) {
    return Container(
      padding: imgPadding,
      height: imgHeight,
      // child: Image.asset(
      //   imgUrl,
      //   height: imgHeight,
      //   fit: imgFit,
      //   frameBuilder: (_, image, loadingBuilder, __) {
      //     if (loadingBuilder == null) {
      //       return const SizedBox(
      //         height: 30,
      //         width: 30,
      //         child: Center(child: CircularProgressIndicator()),
      //       );
      //     }
      //     return image;
      //   },
      //   errorBuilder: (context, error, stacktrace)  {
      //
      //     print("error ${error}");
      //    print("stacktrace  ${stacktrace}");
      //
      //     return Image.asset(
      //       AppImageNames.dummyImage,
      //       height: imgHeight,
      //       width: imgHeight,
      //       fit: BoxFit.contain,
      //     );
      //   }
      // )
      child: assetImage != null
          ? Image(image: assetImage)
          : Image.asset(
        "",
        height: imgHeight,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget loadNetworkImageFile() {
    print("url ******$imgUrl");
    return Container(
      padding: imgPadding,
      height: imgHeight,
      child: Image.network(
        imgUrl.trim(),
        height: imgHeight,
        fit: imgFit,
        frameBuilder: (_, image, loadingBuilder, __) {
          if (loadingBuilder == null) {
            return const SizedBox(
              height: 30,
              width: 30,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return image;
        },
        loadingBuilder: (BuildContext context, Widget image,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return image;
          return SizedBox(
            height: 30,
            width: 30,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder:
        // (_, __, ___) => Image.asset(
        //   AppImageNames.dummyImage,
            (_, __, ___) => Image.memory(
          // AppImageNames.dummyImage,
          dummyAssetUrl as Uint8List,
          height: imgHeight,

          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
