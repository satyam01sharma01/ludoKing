import 'dart:math';

import 'package:dhoom/board/board.dart';
import 'package:dhoom/players/collision_details.dart';
import 'package:dhoom/dice/dice_notifier.dart';
import 'package:dhoom/board/overlay_surface.dart';
import 'package:dhoom/util/colors.dart';
import 'package:dhoom/players/players.dart';
import 'package:dhoom/result/result.dart';
import 'package:dhoom/result/result_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dhoom/players/players_notifier.dart';

import '../dice/dice.dart';
import '../dice/dice_base.dart';
// import '../state/step_sound.dart';
import 'package:audioplayers/audioplayers.dart';

class DhoomGame extends StatefulWidget {
  final List<int> playerIndices;
  const DhoomGame({Key? key, this.playerIndices = const [0, 1, 2, 3]})
    : super(key: key);
  @override
  _DhoomGameState createState() => _DhoomGameState();
}

class _DhoomGameState extends State<DhoomGame> with TickerProviderStateMixin {
  late final List<int> activePlayerIndices;
  late Animation<Color?> _playerHighlightAnim;
  late Animation<double> _diceHighlightAnim;
  late AnimationController _playerHighlightAnimCont, _diceHighlightAnimCont;
  List<List<AnimationController>> _playerAnimContList = [];
  List<List<Animation<Offset>>> _playerAnimList = [];
  List<List<int>> _winnerPawnList = [];
  bool _provideFreeTurn = false;
  CollisionDetails _collisionDetails = CollisionDetails();

  late int _stepCounter = 0,
      _diceOutput = 0,
      _currentTurn = 0,
      _selectedPawnIndex,
      _maxTrackIndex = 57,
      _straightSixesCounter = 0,
      _forwardStepAnimTimeInMillis = 700,
      _reverseStepAnimTimeInMillis = 60;
  late List<List<List<Rect>>> _playerTracks;
  late List<Rect> _safeSpots;
  List<List<MapEntry<int, Rect>>> _pawnCurrentStepInfo = []; //step index, rect

  late PlayersNotifier _playerPaintNotifier;
  late ResultNotifier _resultNotifier;
  late DiceNotifier _diceNotifier;

  late AudioPlayer _soundPlayer;

  @override
  void initState() {
    super.initState();
    // DiceRoll.initialize();
    // StepSound.initialize();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    ); //full screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); //force portrait mode

    _playerPaintNotifier = PlayersNotifier();
    _resultNotifier = ResultNotifier();
    _diceNotifier = DiceNotifier();
    _playerTracks = [];
    _safeSpots = [];
    _pawnCurrentStepInfo = [];
    _winnerPawnList = [];
    _playerAnimContList = [];
    _playerAnimList = [];
    _playerHighlightAnim = AlwaysStoppedAnimation<Color?>(null);
    _diceHighlightAnim = AlwaysStoppedAnimation<double>(0.0);

    _playerHighlightAnimCont = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _diceHighlightAnimCont = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );

    _playerHighlightAnim = ColorTween(
      begin: Colors.black12,
      end: Colors.black45,
    ).animate(_playerHighlightAnimCont);
    _diceHighlightAnim = Tween(
      begin: 0.0,
      end: 2 * pi,
    ).animate(_diceHighlightAnimCont);

    activePlayerIndices = widget.playerIndices;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();

      // _playerPaintNotifier.rebuildPaint();

      _highlightCurrentPlayer();
      _highlightDice();
    });

    _soundPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _playerAnimContList.forEach((controllerList) {
      controllerList.forEach((controller) {
        controller.dispose();
      });
    });
    _playerHighlightAnimCont.dispose();
    _diceHighlightAnimCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<PlayersNotifier>(
            create: (_) => _playerPaintNotifier,
          ),
          ChangeNotifierProvider<ResultNotifier>(
            create: (_) => _resultNotifier,
          ),
          ChangeNotifierProvider<DiceNotifier>(create: (_) => _diceNotifier),
        ],
        child: Stack(
          children: <Widget>[
            SizedBox.expand(child: Container(color: const Color(0xff1f0d67))),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    margin: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        children: <Widget>[
                          SizedBox.expand(
                            child: CustomPaint(
                              painter: BoardPainter(
                                trackCalculationListener: (playerTracks) {
                                  if (_playerTracks.isEmpty &&
                                      playerTracks.isNotEmpty) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          if (mounted) {
                                            setState(() {
                                              _playerTracks = playerTracks;
                                              _initData();
                                              _playerPaintNotifier
                                                  .rebuildPaint();
                                              _highlightCurrentPlayer();
                                              _highlightDice();
                                            });
                                          }
                                        });
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox.expand(
                            child: AnimatedBuilder(
                              animation: _playerHighlightAnim,
                              builder: (_, __) => CustomPaint(
                                painter: OverlaySurface(
                                  highlightColor: _playerHighlightAnim.value!,
                                  selectedHomeIndex:
                                      activePlayerIndices[_currentTurn],
                                  clickOffset: (clickOffset) {
                                    _handleClick(clickOffset);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Consumer<PlayersNotifier>(
                            builder: (_, notifier, __) {
                              if (notifier.shoulPaintPlayers)
                                return SizedBox.expand(
                                  child: Stack(children: _buildPawnWidgets()),
                                );
                              else
                                return Container();
                            },
                          ),
                          Consumer<ResultNotifier>(
                            builder: (_, notifier, __) {
                              return SizedBox.expand(
                                child: CustomPaint(
                                  painter: ResultPainter(notifier.ranks),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      if (_diceHighlightAnimCont.isAnimating) {
                        // DiceRoll.playDiceSound();
                        _playerHighlightAnimCont.reset();
                        _diceHighlightAnimCont.reset();
                        _diceNotifier.rollDice();
                        _soundPlayer.play(AssetSource('audio/dice.mp3'));
                      }
                    },
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Stack(
                        children: [
                          SizedBox.expand(
                            child: AnimatedBuilder(
                              animation: _diceHighlightAnim,
                              builder: (_, __) => CustomPaint(
                                painter: DiceBasePainter(
                                  _diceHighlightAnim.value,
                                ),
                              ),
                            ),
                          ),
                          Consumer<DiceNotifier>(
                            builder: (_, notifier, __) {
                              if (notifier.isRolled) {
                                _highlightCurrentPlayer();
                                _diceOutput = notifier.output;
                                if (_diceOutput == 6) _straightSixesCounter++;
                                _checkDiceResultValidity();
                              }
                              return SizedBox.expand(
                                child: CustomPaint(
                                  painter: DicePaint(notifier.output),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPawnWidgets() {
    List<Widget> playerPawns = [];
    // Map from rounded position to list of (playerIdx, pawnIdx, color)
    Map<String, List<Map<String, dynamic>>> pawnsBySpot = {};
    // Helper to round Offset to string key
    String posKey(Offset o) =>
        '${o.dx.toStringAsFixed(2)},${o.dy.toStringAsFixed(2)}';

    for (int i = 0; i < activePlayerIndices.length; i++) {
      int playerIndex = activePlayerIndices[i];
      Color playerColor;
      switch (playerIndex) {
        case 0:
          playerColor = AppColors.player1;
          break;
        case 1:
          playerColor = AppColors.player2;
          break;
        case 2:
          playerColor = AppColors.player3;
          break;
        default:
          playerColor = AppColors.player4;
      }
      for (int pawnIndex = 0; pawnIndex < 4; pawnIndex++) {
        final pos = _playerAnimList[i][pawnIndex].value;
        final key = posKey(pos);
        pawnsBySpot.putIfAbsent(key, () => []);
        pawnsBySpot[key]!.add({
          'playerIdx': i,
          'pawnIdx': pawnIndex,
          'color': playerColor,
          'pos': pos,
        });
      }
    }

    // Now, for each pawn, calculate its offset if it shares a spot
    pawnsBySpot.forEach((key, pawns) {
      final n = pawns.length;
      final double radius = 12.0; // distance from center for offset
      for (int idx = 0; idx < pawns.length; idx++) {
        final pawn = pawns[idx];
        final Offset base = pawn['pos'];
        Offset drawPos = base;
        if (n > 1) {
          // Arrange in a circle
          final angle = 2 * pi * idx / n;
          drawPos = base + Offset(radius * cos(angle), radius * sin(angle));
        }
        playerPawns.add(
          SizedBox.expand(
            child: AnimatedBuilder(
              builder: (_, child) => CustomPaint(
                painter: PlayersPainter(
                  playerCurrentSpot: drawPos,
                  playerColor: pawn['color'],
                ),
              ),
              animation: _playerAnimList[pawn['playerIdx']][pawn['pawnIdx']],
            ),
          ),
        );
      }
    });
    return playerPawns;
  }

  _initData() {
    // Clear lists to avoid accumulation on hot reload
    _playerAnimContList.clear();
    _playerAnimList.clear();
    _pawnCurrentStepInfo.clear();
    _winnerPawnList.clear();
    for (int i = 0; i < activePlayerIndices.length; i++) {
      int playerIndex = activePlayerIndices[i];
      List<Animation<Offset>> currentPlayerAnimList = [];
      List<AnimationController> currentPlayerAnimContList = [];
      List<MapEntry<int, Rect>> currentStepInfoList = [];
      for (
        int pawnIndex = 0;
        pawnIndex < _playerTracks[playerIndex].length;
        pawnIndex++
      ) {
        AnimationController currentAnimCont =
            AnimationController(
              duration: Duration(milliseconds: _forwardStepAnimTimeInMillis),
              vsync: this,
            )..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                // StepSound.playDiceSound();
                if (!_collisionDetails.isReverse) _stepCounter++;
                _movePawn();
                _playerPaintNotifier
                    .rebuildPaint(); // <-- Trigger repaint after move
              }
            });
        currentPlayerAnimContList.add(currentAnimCont);
        currentPlayerAnimList.add(
          Tween(
            begin: _playerTracks[playerIndex][pawnIndex][0].center,
            end: _playerTracks[playerIndex][pawnIndex][1].center,
          ).animate(currentAnimCont),
        );
        currentStepInfoList.add(
          MapEntry(0, _playerTracks[playerIndex][pawnIndex][0]),
        );
      }
      _playerAnimContList.add(currentPlayerAnimContList);
      _playerAnimList.add(currentPlayerAnimList);
      _pawnCurrentStepInfo.add(currentStepInfoList);
      _winnerPawnList.add([]);
    }

    /**
     * Fetch all safe spot rects
     */
    var playerTrack = _playerTracks[0][0];

    _safeSpots = [
      playerTrack[1],
      playerTrack[9],
      playerTrack[14],
      playerTrack[22],
      playerTrack[27],
      playerTrack[35],
      playerTrack[40],
      playerTrack[48],
    ];
  }

  _handleClick(Offset clickOffset) {
    if (!_diceHighlightAnimCont.isAnimating)
      if (_stepCounter == 0) {
        for (
          int pawnIndex = 0;
          pawnIndex < _pawnCurrentStepInfo[_currentTurn].length;
          pawnIndex++
        )
          if (_pawnCurrentStepInfo[_currentTurn][pawnIndex].value.contains(
            clickOffset,
          )) {
            var clickedPawnIndex =
                _pawnCurrentStepInfo[_currentTurn][pawnIndex].key;

            if (clickedPawnIndex == 0) {
              if (_diceOutput == 6)
                _diceOutput =
                    1; //to move pawn out of the house when 6 is rolled
              else
                break; //disallow pawn selection because 6 is not rolled and the pawn is in house
            } else if (clickedPawnIndex + _diceOutput > _maxTrackIndex)
              break; //disallow pawn selection because dice number is more than step left

            _playerHighlightAnimCont.reset();
            _selectedPawnIndex = pawnIndex;

            _movePawn(considerCurrentStep: true);

            break;
          }
      }
  }

  _checkDiceResultValidity() {
    var isValid = false;
    int movablePawnIndex = -1;
    int movableCount = 0;

    for (int i = 0; i < _pawnCurrentStepInfo[_currentTurn].length; i++) {
      var stepInfo = _pawnCurrentStepInfo[_currentTurn][i];
      if (_diceOutput == 6) {
        if (_straightSixesCounter == 3)
          break;
        else if (stepInfo.key + _diceOutput > _maxTrackIndex)
          continue;
        isValid = true;
        movablePawnIndex = i;
        movableCount++;
      } else if (stepInfo.key != 0) {
        if (stepInfo.key + _diceOutput <= _maxTrackIndex) {
          isValid = true;
          movablePawnIndex = i;
          movableCount++;
        }
      }
    }

    if (!isValid) {
      _changeTurn();
      return;
    }

    // If only one pawn can move, move it automatically
    if (movableCount == 1) {
      _selectedPawnIndex = movablePawnIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _movePawn(considerCurrentStep: true);
      });
    }
  }

  _movePawn({bool considerCurrentStep = false}) {
    int logicalPlayerIndex, playerIndex, pawnIndex, currentStepIndex;
    if (_collisionDetails.isReverse) {
      logicalPlayerIndex = _collisionDetails.targetPlayerIndex;
      playerIndex = activePlayerIndices[logicalPlayerIndex];
      pawnIndex = _collisionDetails.pawnIndex;
      currentStepIndex = max(
        _pawnCurrentStepInfo[logicalPlayerIndex][pawnIndex].key -
            (considerCurrentStep ? 0 : 1),
        0,
      );
    } else {
      logicalPlayerIndex = _currentTurn;
      playerIndex = activePlayerIndices[logicalPlayerIndex];
      pawnIndex = _selectedPawnIndex;
      currentStepIndex = min(
        _pawnCurrentStepInfo[logicalPlayerIndex][pawnIndex].key +
            (considerCurrentStep
                ? 0
                : 1), //condition to avoid incrementing key for initial step
        _maxTrackIndex,
      );
    }

    //update current step info in the [_pawnCurrentStepInfo] list
    var currentStepInfo = MapEntry(
      currentStepIndex,
      _playerTracks[playerIndex][pawnIndex][currentStepIndex],
    );
    _pawnCurrentStepInfo[logicalPlayerIndex][pawnIndex] = currentStepInfo;

    var animCont = _playerAnimContList[logicalPlayerIndex][pawnIndex];

    if (_collisionDetails.isReverse) {
      if (currentStepIndex > 0) {
        //animate one step reverse
        _playerAnimList[_collisionDetails.targetPlayerIndex][_collisionDetails
            .pawnIndex] = Tween(
          begin: currentStepInfo.value.center,
          end:
              _playerTracks[_collisionDetails
                      .targetPlayerIndex][_collisionDetails
                      .pawnIndex][currentStepIndex - 1]
                  .center,
        ).animate(animCont);
        animCont.forward(from: 0.0);
      } else {
        _playerAnimContList[logicalPlayerIndex][pawnIndex].duration = Duration(
          milliseconds: _forwardStepAnimTimeInMillis,
        );
        _collisionDetails.isReverse = false;
        _provideFreeTurn = true; //free turn for collision
        _changeTurn();
      }
    } else if (_stepCounter != _diceOutput) {
      // Define the animation
      _playerAnimList[logicalPlayerIndex][pawnIndex] =
          Tween(
            begin: currentStepInfo.value.center,
            end:
                _playerTracks[playerIndex][pawnIndex][min(
                      currentStepIndex + 1,
                      _maxTrackIndex,
                    )]
                    .center,
          ).animate(
            CurvedAnimation(
              parent: animCont,
              curve: Interval(0.0, 0.5, curve: Curves.easeOutCubic),
            ),
          );
      animCont.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _soundPlayer.play(AssetSource('audio/move.mp3'));
          animCont.removeStatusListener((_) {});
        }
      });

      // Start the animation
      animCont.forward(from: 0.0);
    } else {
      if (_checkCollision(currentStepInfo))
        _movePawn(considerCurrentStep: true);
      else {
        if (currentStepIndex == _maxTrackIndex) {
          _winnerPawnList[logicalPlayerIndex].add(
            _selectedPawnIndex,
          ); //add pawn to [_winnerPawnList]

          if (_winnerPawnList[logicalPlayerIndex].length < 4)
            _provideFreeTurn =
                true; //if player has remaining pawns, provide free turn for reaching destination
          else {
            _resultNotifier.rebuildPaint(logicalPlayerIndex);
            _provideFreeTurn =
                false; //to discard free turn if he completes the game
          }
        }

        _changeTurn();
      }
    }
  }

  bool _checkCollision(MapEntry<int, Rect> currentStepInfo) {
    var currentStepCenter = currentStepInfo.value.center;

    if (currentStepInfo.key <
        52) //no need to check if the pawn has entered destination lane
      if (!_safeSpots.any((safeSpot) {
        //avoid checking if it has landed on a safe spot
        return safeSpot.contains(currentStepCenter);
      })) {
        List<CollisionDetails> collisions = [];
        for (
          int logicalPlayerIndex = 0;
          logicalPlayerIndex < activePlayerIndices.length;
          logicalPlayerIndex++
        ) {
          int playerIndex = activePlayerIndices[logicalPlayerIndex];
          for (
            int pawnIndex = 0;
            pawnIndex < _pawnCurrentStepInfo[logicalPlayerIndex].length;
            pawnIndex++
          ) {
            if (logicalPlayerIndex != _currentTurn ||
                pawnIndex != _selectedPawnIndex)
              if (_pawnCurrentStepInfo[logicalPlayerIndex][pawnIndex].value
                  .contains(currentStepCenter)) {
                collisions.add(
                  CollisionDetails()
                    ..pawnIndex = pawnIndex
                    ..targetPlayerIndex = logicalPlayerIndex,
                );
              }
          }
        }

        /**
       * Check if collision is valid
       */
        if (collisions.isEmpty ||
            collisions.any((collision) {
              return collision.targetPlayerIndex == _currentTurn;
            }) ||
            collisions.length >
                1) //conditions to no collision and group collisions
          _collisionDetails.isReverse = false;
        else {
          _collisionDetails = collisions.first;
          _playerAnimContList[_collisionDetails
                  .targetPlayerIndex][_collisionDetails.pawnIndex]
              .duration = Duration(
            milliseconds: _reverseStepAnimTimeInMillis,
          );

          _collisionDetails.isReverse = true;
        }
      }
    return _collisionDetails.isReverse;
  }

  _changeTurn() {
    if (_winnerPawnList.where((playerPawns) {
          return playerPawns.length == 4;
        }).length !=
        activePlayerIndices.length - 1) //if any 3 players have completed
    {
      _highlightDice();

      _stepCounter = 0; //reset step counter for next turn
      if (!_provideFreeTurn) {
        do {
          //to ignore winners
          _currentTurn =
              (_currentTurn + 1) %
              activePlayerIndices
                  .length; //change turn after animation completes
          if (_winnerPawnList[_currentTurn].length != 4)
            break; //select player if he is not yet a winner
        } while (true);
        _straightSixesCounter = 0;
      } else if (_diceOutput != 6)
        _straightSixesCounter =
            0; //reset 6s counter if free turn is provided by other means

      if (!_playerHighlightAnimCont.isAnimating) _highlightCurrentPlayer();

      _provideFreeTurn = false;
    }
  }

  _highlightCurrentPlayer() {
    _playerHighlightAnimCont.repeat(reverse: true);
  }

  _highlightDice() {
    _diceHighlightAnimCont.repeat();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<AnimationController>(
        '_diceHighlightAnimCont',
        _diceHighlightAnimCont,
      ),
    );
  }
} // more then on pawn on a single box handling
