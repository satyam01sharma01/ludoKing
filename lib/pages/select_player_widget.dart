import 'package:flutter/material.dart';
import 'package:dhoom/pages/game.dart';

class SelectPlayersWidget extends StatelessWidget {
  const SelectPlayersWidget({Key? key}) : super(key: key);

  static String routeName = 'selectplayers';
  static String routePath = '/selectplayers';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(0, -0.62),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/background.jpg',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: const Alignment(-0.04, -0.24),
                                      child: Text(
                                        'Dhoom',
                                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).colorScheme.onBackground,
                                            ) ?? const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: const Alignment(0.06, -0.15),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              onTap: () {},
                                              child: Text(
                                                'Step into the Arena. Outsmart Rivals. Defy the Dice. Rule the Board.\nThis isn’t just Ludo — this is your throne. Be the King of Ludo!',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      color: Theme.of(context).colorScheme.secondary,
                                                      fontSize: 12,
                                                    ) ?? const TextStyle(fontSize: 12),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 250,
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Open two player game (red and yellow)
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DhoomGame(playerIndices: [0, 2]),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context).colorScheme.onBackground,
                                            foregroundColor: Theme.of(context).colorScheme.background,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(22),
                                              side: BorderSide(color: Theme.of(context).colorScheme.onBackground),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: const Text('Two Players game'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 250,
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // TODO: Implement four players game logic
                                            Navigator.pushNamed(
                                              context,
                                              '/game',
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context).colorScheme.onBackground,
                                            foregroundColor: Theme.of(context).colorScheme.background,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(22),
                                              side: BorderSide(color: Theme.of(context).colorScheme.onBackground),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: const Text('Four Players game'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
