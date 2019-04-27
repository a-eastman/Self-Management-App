///Module for creating single-use particle effects
///@author Brian Intile
///
///
///LAST EDIT : April 19, 2019
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'bubbles.dart';
import 'dart:async';

///Main particle widget, will create a single burst of particles that disposes of itself after finishing
class PopParticles extends StatefulWidget {

  static int _globalIndex = 1;

  final Bubble _bubble;
  final double _screenWidth;
  final double _screenHeight;
  final DateTime _timeCreated = DateTime.now();
  final Key key = Key((_globalIndex++).toString());

  ///Constructor needs bubble and screen size parameters
  PopParticles(this._bubble, this._screenWidth, this._screenHeight);

  bool expired()
  {
    return _timeCreated.difference(DateTime.now()).inSeconds.abs() > 3;
  }

  @override
  State<StatefulWidget> createState() => PopParticlesState(this._bubble, _screenWidth, _screenHeight, "kee");
}

class PopParticlesState extends State<PopParticles> {
  List<PopParticleNode> _particles = [];
  Bubble _bubble;
  double _screenWidth;
  double _screenHeight;
  final int _lifetimeMS = 1000;
  final String _key;

  PopParticlesState(this._bubble, this._screenWidth, this._screenHeight, this._key)
  {
    reset();
    Timer(Duration(milliseconds: _lifetimeMS), _clear);
  }

  void _clear()
  {
    _particles.clear();
  }

  //Resets our particle node list, used to originally populate nodes
  void reset() {
    for (int i = 0; i < 10; i++) {
      _particles.add(PopParticleNode(this._bubble, _screenWidth, _screenHeight, _key + "." + i.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: Key(_key),
      children: _particles,
    );
  }
}

///Single node class for PopParticles, each individual particle is an instance of this
class PopParticleNode extends StatefulWidget {
  final Bubble _bubble;
  final double _screenWidth;
  final double _screenHeight;
  final String _key;

  PopParticleNode(this._bubble, this._screenWidth, this._screenHeight, this._key);

  @override
  PopParticleNodeState createState() => PopParticleNodeState(_bubble, _screenWidth, _screenHeight, _key);
}

class PopParticleNodeState extends State<PopParticleNode>
    with TickerProviderStateMixin {
  Bubble _bubble;
  double _screenWidth;
  double _screenHeight;
  final String _key;

  PopParticleNodeState(this._bubble, this._screenWidth, this._screenHeight, this._key);

  ///Each particle ahs its own animation controller and handles its own animations
  AnimationController _controller;
  Animation _xAnimation;
  Animation _yAnimation;
  Animation _scaleAnimation;

  ///Edit animation parameters here
  
  final int _durationMs = 600;

  ///X extents multiplied by screen width
  final double _xExtents = .15;
  final double _minXMult = -1.0;
  final double _maxXMult = 1.0;

  ///Y extents multiplied by screen height
  final double _yExtents = -.3;
  final double _minYMult = .7;
  final double _maxYMult = 1.3;

  ///Base size multiplied by screen height * base bubble size
  final double _baseSizeMin = .2;
  final double _baseSizeMax = .45;
  final double _minShrinkTime = 0.3;
  final double _maxShrinkTime = 1.0;

  double _baseXPos;
  double _baseYPos;

  double _baseSize;

  ///Updatse the animation controller and builds the state of the particle node widget using data from the animations
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight  = MediaQuery.of(context).size.height;
    _controller.forward();

    return AnimatedBuilder(
        key: Key(_key),
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

  ///initState constructs each animation and multiplies the strength of its size/scale/etc by randomized values (tweakable above)
  ///This makes each particle move differently but follow the same pattern of floating up
  ///Randomized animations apply to x position, y position, and scale of node
  @override
  void initState() {
    super.initState();

    ///Create our AnimationController with specified duration
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: _durationMs));

    ///Create random number generator and determine random range of each animation
    
    var rand = new math.Random();
    var xMult = randomBetween(rand, _minXMult, _maxXMult)
      * _screenHeight;
    var yMult = randomBetween(rand, _minYMult, _maxYMult)
      * _screenHeight;
    var shrinkTime = randomBetween(rand, _minShrinkTime, _maxShrinkTime);
    
    var bSize = _bubble.getSize() * _screenHeight;

    _baseSize = randomBetween(rand, _baseSizeMin, _baseSizeMax)
       * bSize;
    _baseXPos = (_bubble.getXPos() * _screenWidth)
      + randomBetween(rand, -bSize / 3.0, bSize  / 3.0);
    _baseYPos = (_bubble.getYPos() * _screenHeight)
      + (bSize / 4)
      + randomBetween(rand, -bSize / 3.0, bSize / 3.0);

    //Create animations themselves to determine general movement

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

  ///Helper class for retrieving random numbers for animation values
  double randomBetween(math.Random rand, double min, double max) {
    return min + (rand.nextDouble() * (max - min));
  }

  ///Dispose of the AnimationController on widget disposal
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}