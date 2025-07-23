import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:dhoom/state/dice_roll_sound.dart';

class DiceNotifier extends ChangeNotifier {
  bool _isRolled = false;
  int _output = 1;

  get isRolled => _isRolled;
  get output => _output;

  rollDice() async {
    // await DiceRoll.initialize();
    // await DiceRoll.playDiceSound();
    // await DiceRoll.dispose();
    _isRolled = false;
    var rollCounter = 0;

    do {
      _generateOutputAndNotify();
      await Future.delayed(Duration(milliseconds: 100));
      rollCounter++;
    } while (rollCounter != 5);

    _isRolled = true;
    _generateOutputAndNotify();
  }

  _generateOutputAndNotify() {
    _output = 1 + Random().nextInt(6);
    notifyListeners();
  }
}
