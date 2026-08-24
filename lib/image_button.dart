import 'package:flutter/material.dart';

class ImageButton extends StatefulWidget {
  final String image;
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final TextStyle textStyle;

  const ImageButton({
    super.key,
    required this.image,
    required this.text,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.textStyle,
  });

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTapDown: (_) {
        setState(() {
          _pressed = true;
        });
      },

      onTapUp: (_) {
        setState(() {
          _pressed = false;
        });

        widget.onPressed();
      },

      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },

      child: SizedBox(
        width: widget.width,
        height: widget.height,

        child: Stack(
          alignment: Alignment.center,
          children: [

            // IMMAGINE DEL PULSANTE
            Image.asset(
              widget.image,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.contain,
            ),

            // OSCURAMENTO SOLO DEL PULSANTE
            if (_pressed)
              Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.25),
                ),
              ),

            // TESTO
            Text(
              widget.text,
              style: widget.textStyle.fontFamily == null
                  ? widget.textStyle.copyWith(fontFamily: 'Arial')
                  : widget.textStyle,
            ),
          ],
        ),
      ),
    );
  }
}