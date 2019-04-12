import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'bubbles.dart';
import 'dart:async';

class PopParticles extends StatefulWidget {

  final Bubble _bubble;
  final double _screenWidth;
  final double _screenHeight;
  final DateTime _timeCreated = DateTime.now();

  PopParticles(this._bubble, this._screenWidth, this._screenHeight);

  bool expired()
  {
    return _timeCreated.difference(DateTime.now()).inSeconds.abs() > 5;
  }

  @override
  State<StatefulWidget> createState() => PopParticlesState(this._bubble, _screenWidth, _screenHeight);
}

class PopParticlesState extends State<PopParticles> {
  List<PopParticleNode> _particles = [];
  Bubble _bubble;
  double _screenWidth;
  double _screenHeight;
  final int _lifetimeMS = 1000;

  PopParticlesState(this._bubble, this._screenWidth, this._screenHeight)
  {
    reset();
    Timer(Duration(milliseconds: _lifetimeMS), _clear);
  }

  void _clear()
  {
    _particles.clear();
  }

  void reset() {
    print("pop reset");
    for (int i = 0; i < 10; i++) {
      _particles.add(PopParticleNode(this._bubble, _screenWidth, _screenHeight));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _particles,
    );
  }
}

class PopParticleNode extends StatefulWidget {
  final Bubble _bubble;
  final double _screenWidth;
  final double _screenHeight;

  PopParticleNode(this._bubble, this._screenWidth, this._screenHeight);

  @override
  PopParticleNodeState createState() => PopParticleNodeState(_bubble, _screenWidth, _screenHeight);
}

class PopParticleNodeState extends State<PopParticleNode>
    with TickerProviderStateMixin {
  Bubble _bubble;
  double _screenWidth;
  double _screenHeight;

  PopParticleNodeState(this._bubble, this._screenWidth, this._screenHeight);

  AnimationController _controller;
  Animation _xAnimation;
  Animation _yAnimation;
  Animation _scaleAnimation;

  // Edit animation parameters here
  
  final int _durationMs = 600;

  // X extents multiplied by screen width
  final double _xExtents = .15;
  final double _minXMult = -1.0;
  final double _maxXMult = 1.0;

  // Y extents multiplied by screen height
  final double _yExtents = -.3;
  final double _minYMult = .7;
  final double _maxYMult = 1.3;

  // Base size multiplied by screen height * base bubble size
  final double _baseSizeMin = .2;
  final double _baseSizeMax = .45;
  final double _minShrinkTime = 0.3;
  final double _maxShrinkTime = 1.0;

  double _baseXPos;
  double _baseYPos;

  double _baseSize;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight  = MediaQuery.of(context).size.height;
    _controller.forward();

    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return Transform(
            alignment: Alignment.topLeft,
            transform: Matrix4.translationValues(
              _baseXPos + (_xAnimation.value * _xExtents)
                - (screenWidth / 2.0),
              _baseYPos + (_yAnimation.value * _yExtents)
                - (screenHeight / 2.0),
              0.0,
            ),
            child: Transform.scale(
              scale: math.max(_scaleAnimation.value, 0.0),
              child: new Center(
                child: Container(
                  width: _baseSize,
                  height: _baseSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _bubble.getColor().withAlpha((_bubble.getColor().alpha * .75).round()),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: _durationMs));

    var rand = new math.Random();
    var xMult = randomBetween(rand, _minXMult, _maxXMult)
      * _screenHeight;
    var yMult = randomBetween(rand, _minYMult, _maxYMult)
      * _screenHeight;
    var shrinkTime = randomBetween(rand, _minShrinkTime, _maxShrinkTime);
    
    var bSize = _bubble.getSize() * _screenHeight;

    _baseSize = randomBetween(rand, _baseSizeMin, _baseSizeMax)
       //* (_bubble.getSizeIndex() + 2.0)
       * bSize;
    _baseXPos = _bubble.getXPos()
      + randomBetween(rand, -bSize / 3.0, bSize  / 3.0);
    _baseYPos = _bubble.getYPos()
      + (bSize / 1.5)
      - (bSize / 2)
      + randomBetween(rand, -bSize / 3.0, bSize / 3.0);
      //+ (bHeight / (_bubble.getSizeIndex() + 3.0));

    _xAnimation = Tween(begin: 0.0, end: xMult).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _yAnimation = Tween(begin: 0.0, end: yMult).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInQuad,
    ));

    _scaleAnimation = Tween(begin: 1.0, end: 1.0 - (1.0 / shrinkTime))
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
  }

  double randomBetween(math.Random rand, double min, double max) {
    return min + (rand.nextDouble() * (max - min));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
