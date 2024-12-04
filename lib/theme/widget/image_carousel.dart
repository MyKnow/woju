import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/image_zoom_dialog.dart';

// TODO : 화면을 가로로 돌렸을 때, 이미지 컨테이너가 좌우로 2배 더 넓어지는 문제 해결

class ImageCarousel extends StatefulWidget {
  final List<Uint8List> images;
  final double imageWidth;
  final double scale;

  const ImageCarousel(
      {super.key, required this.images, this.imageWidth = 200, this.scale = 1});

  @override
  ImageCarouselState createState() => ImageCarouselState();
}

class ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.6);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.images.length,
      onPageChanged: (index) {},
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double pageOffset = 0.0;
            if (_pageController.hasClients &&
                _pageController.position.haveDimensions) {
              pageOffset = _pageController.page! - index;
            } else {
              pageOffset = _pageController.initialPage.toDouble() - index;
            }

            double scaleFactor = 1 - (pageOffset.abs() * 0.2);
            double opacity = 1 - (pageOffset.abs() * 0.4);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Transform.scale(
                scale: scaleFactor.clamp(0.8, 1.0),
                child: Opacity(
                  opacity: opacity.clamp(0.6, 1.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      excludeFromSemantics: true,
                      onTap: () {
                        ImageZoomDialog.show(context, widget.images[index]);
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            width: widget.imageWidth, // 강제 정사각형 크기 유지
                            height: widget.imageWidth, // 강제 정사각형 크기 유지
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                image: MemoryImage(widget.images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: ClipOval(
                              child: Container(
                                color: Colors.black.withOpacity(0.6),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.zoom_in,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          // 첫 번째 이미지일 경우에만 표시
                          if (index == 0)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                height: 24 * widget.scale,
                                width: widget.imageWidth,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(24),
                                  ),
                                ),
                                child: const Center(
                                  child: CustomText(
                                    "addItem.imageItem.mainImageBanner",
                                    isWhite: true,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
