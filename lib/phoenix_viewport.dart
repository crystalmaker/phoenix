import 'package:flutter/material.dart';

class PhoenixViewport extends StatelessWidget {
  final Widget child;

  const PhoenixViewport({
    super.key,
    required this.child,
  });

  // Dimensione logica di riferimento del telefono
  static const double designWidth = 838.9;
  static const double designHeight = 392.7;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleX = constraints.maxWidth / designWidth;
        final scaleY = constraints.maxHeight / designHeight;

        // Mantiene sempre le proporzioni originali
        final scale = scaleX < scaleY ? scaleX : scaleY;

        return Center(
          child: SizedBox(
            width: designWidth * scale,
            height: designHeight * scale,
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: designWidth,
                height: designHeight,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    size: const Size(
                      designWidth,
                      designHeight,
                    ),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}