import 'dart:math';

import 'package:flutter/material.dart';

import 'models/beer.dart';
import 'models/touch_slice.dart';

class CanvasArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CanvasAreaState();
  }
}

class _CanvasAreaState<CanvasArea> extends State {
  int score = 0;
  TouchSlice touchSlice;
  List<Beer> beers = List();

  @override
  void initState() {
    _spawnRandomBeers();
    _tick();
    super.initState();
  }

  void _spawnRandomBeers() {
    beers.add(new Beer(
      position: Offset(0, 200),
      width: 80,
      height: 80,
      additionalForce: Offset(5 + Random().nextDouble() * 5, Random().nextDouble() * -10),
      rotation: Random().nextDouble() / 3 - 0.16
    ));
  }

  void _tick() {
    setState(() {
      for (Beer beer in beers) {
        beer.applyGravity();
      }


      if (Random().nextDouble() > 0.97) {
        _spawnRandomBeers();
      }
    });

    Future.delayed(Duration(milliseconds: 30), _tick);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _getStack()
    );
  }

  List<Widget> _getStack() {
    List<Widget> widgetsOnStack = List();

    widgetsOnStack.add(_getBackground());
    widgetsOnStack.add(_getSlice());
    widgetsOnStack.addAll(_getBeer());
    widgetsOnStack.add(
      Positioned(
        right: 16,
        top: 16,
        child: Text(
          'Score: $score',
          style: TextStyle(
            fontSize: 24
          ),
        )
      )
    );

    return widgetsOnStack;
  }

  Container _getBackground() {
    return Container(
      decoration: new BoxDecoration(
        gradient: new RadialGradient(
          stops: [0.2, 1.0],
          colors: [
            Color(0xff5ef2ff),
            Color(0xff4975de)
          ],
        )
      ),
    );
  }

  Widget _getSlice() {
    if (touchSlice == null) {
      return Container();
    }

    return CustomPaint(
      size: Size.infinite,
    );
  }

  List<Widget> _getBeer() {
    List<Widget> list = new List();

    for (Beer beer in beers) {
      list.add(
        Positioned(
          top: beer.position.dy,
          left: beer.position.dx,
          child: Transform.rotate(
            angle: beer.rotation * pi * 2,
              child: GestureDetector(
                onTap: ()  {
                  beers.remove(beer);
                  score += 10;
                },
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                      child: _getBeerGlass(beer)
                  ),
                ),
              ),
          ),
        )
      );
    }

    return list;
  }

  Widget _getBeerGlass(Beer beer) {
    return Image.asset(
      'assets/beer.png',
      height: 80,
      fit: BoxFit.fitHeight
    );
  }





 /* _checkCollision() {
    if (touchSlice == null) {
      return;
    }

    for (Beer beer in List.from(beers)) {
      bool firstPointOutside = false;
      bool secondPointInside = false;

      for (Offset point in touchSlice.pointsList) {
        if (!firstPointOutside&& !beer.isPointInside(point)) {
          firstPointOutside = true;
          continue;
        }

        if (firstPointOutside && beer.isPointInside(point)) {
          secondPointInside = true;
          continue;
        }

        if (secondPointInside && !beer.isPointInside(point)) {
          beers.remove(beer);
          score += 10;
          break;
        }
      }
    }
  }*/




}