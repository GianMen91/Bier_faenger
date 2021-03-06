import 'dart:ui';

import 'gravitational_object.dart';

class Pretzel extends GravitationalObject {
  Pretzel({
    position,
    this.width,
    this.height,
    gravitySpeed = 0.0,
    //additionalForce = const Offset(0,0),
    rotation = 0.25
  }) : super(position: position, gravitySpeed: gravitySpeed);

  double width;
  double height;

  bool isPointInside(Offset point) {
    if (point.dx < position.dx) {
      return false;
    }

    if (point.dx > position.dx + width) {
      return false;
    }

    if (point.dy < position.dy) {
      return false;
    }

    if (point.dy > position.dy + height) {
      return false;
    }

    return true;
  }
}