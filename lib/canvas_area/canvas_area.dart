import 'dart:math';

import 'package:flutter/material.dart';

import 'models/beer.dart';
import 'models/pretzel.dart';

class CanvasArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CanvasAreaState();
  }
}

class _CanvasAreaState<CanvasArea> extends State {
  int score = 0;
  int alcool = 0;
  List<Beer> beers = List();
  List<Pretzel> pretzels = List();
  Stopwatch _stopwatch;



  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void initState() {
    _spawnRandomBeers();
    _tick();
    _stopwatch = Stopwatch();
    super.initState();
  }

  void _spawnRandomBeers() {
    beers.add(new Beer(
        position: Offset(Random().nextDouble() * 300, 0),
        width: 80,
        height: 80));
  }

  void _spawnRandomPretzel() {
    pretzels.add(new Pretzel(
        position: Offset(Random().nextDouble() * 300, 0),
        width: 80,
        height: 80));
  }

  void _tick() {
    setState(() {
      for (Beer beer in beers) {
        beer.applyGravity();
      }

      for (Pretzel pretzel in pretzels) {
        pretzel.applyGravity();
      }

      if (Random().nextDouble() > 0.97) {
        _spawnRandomBeers();

      }

      if (Random().nextDouble()*100 > 99) {
        _spawnRandomPretzel();
      }
    });

    Future.delayed(Duration(milliseconds: 70), _tick);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _getStack());
  }

  List<Widget> _getStack() {
    List<Widget> widgetsOnStack = List();
    _stopwatch.start();

    widgetsOnStack.add(_getBackground());
    widgetsOnStack.addAll(_getBeer());
    widgetsOnStack.addAll(_getPretzel());
    widgetsOnStack.add(Positioned(
        left: 16,
        top: 16,
        child: Text(formatTime(_stopwatch.elapsedMilliseconds),
            style: TextStyle(fontSize: 20))));
    widgetsOnStack.add(Positioned(
        left: 120,
        top: 16,
        child: Text(
          'Drunk: $alcool%',
          style: TextStyle(fontSize: 20),
        )));
    widgetsOnStack.add(Positioned(
        right: 16,
        top: 16,
        child: Text(
          'Score: $score',
          style: TextStyle(fontSize: 20),
        )));

    return widgetsOnStack;
  }

  Container _getBackground() {
    return Container(
      decoration: new BoxDecoration(
          gradient: new RadialGradient(
        stops: [0.2, 1.0],
        colors: [Color(0xff5ef2ff), Color(0xff4975de)],
      )),
    );
  }

  List<Widget> _getBeer() {
    List<Widget> list = new List();

    for (Beer beer in beers) {
      list.add(Positioned(
        top: beer.position.dy,
        left: beer.position.dx,

          child: GestureDetector(
            onTap: () {
              beers.remove(beer);
              score += 10;
              if(alcool<=100){
                alcool += 5;
              }
            },
            child: Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: _getBeerGlass(beer)),
            ),
          ),
        ));

    }

    return list;
  }

  Widget _getBeerGlass(Beer beer) {
    return Image.asset('assets/beer.png', height: 80, fit: BoxFit.fitHeight);
  }


  List<Widget> _getPretzel() {
    List<Widget> list = new List();

    for (Pretzel pretzel in pretzels) {
      list.add(Positioned(
        top: pretzel.position.dy,
        left: pretzel.position.dx,

          child: GestureDetector(
            onTap: () {
              pretzels.remove(pretzel);
              if(alcool>0){
                alcool -= 5;
              }
            },
            child: Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: _getPretzelBrot(pretzel)),
            ),
          ),
        ),
      );
    }

    return list;
  }

  Widget _getPretzelBrot(Pretzel pretzel) {
    return Image.asset('assets/pretzel.png', height: 80, fit: BoxFit.fitHeight);
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
