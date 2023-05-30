import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry borderRadius;
  final double blurRadius;
  final EdgeInsetsGeometry external_padding;
  final EdgeInsetsGeometry internal_padding;
  final double dx;
  final double dy;

  const CardContainer({
    Key? key,
    required this.child,
    required this.borderRadius,
    required this.blurRadius,
    required this.external_padding,
    required this.internal_padding,
    required this.dx,
    required this.dy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: external_padding,
      child: Container(
        padding: internal_padding,
        decoration: _crearTarjeta(),
        child: child,
      ),
    );
  }

  BoxDecoration _crearTarjeta() => BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: blurRadius,
              offset: Offset(dx, dy),
            ),
          ]);
}
