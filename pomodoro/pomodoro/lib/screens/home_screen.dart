import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 10;
  static const totalLives = 3;
  int totalSeconds = twentyFiveMinutes;
  late Timer timer;
  bool isRunning = false;
  bool isAlive = true;
  int totalPomodoros = 0;
  int totalLivesofDay = totalLives;
  int streaks = 1;
  bool isSuccess = false;
  String today = "";

  @override
  void initState() {
    super.initState();
    today = getCurrentDate();
  }

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros = totalPomodoros + 1;
        totalSeconds = twentyFiveMinutes;
        isRunning = false;
        isSuccess = true;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  String getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void onStartPressed() {
    //checking if it a new day
    String currentDate = getCurrentDate();
    if (today != currentDate) {
      setState(() {
        totalLivesofDay = totalLives;
        today = currentDate;
      });
    }
    // running the timer again
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
      isSuccess = false;
    });
  }

  void onPausePressed() async {
    timer.cancel();
    bool? stopTimer = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Asking You Once Again"),
          backgroundColor: const Color.fromARGB(255, 239, 225, 153),
          content: const Text("Do you really want to pause the timer?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                totalLivesofDay = totalLivesofDay - 1;
                if (totalLivesofDay == 0) {
                  isAlive = false;
                }
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );

    if (stopTimer != null && stopTimer) {
      setState(() {
        isRunning = false;
      });
    } else if (stopTimer != null && !stopTimer) {
      onStartPressed();
    }
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split('.')[0].substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    double progress = (twentyFiveMinutes - totalSeconds) / twentyFiveMinutes;
    Color startColor = const Color(0xFFF8C4C4);
    Color endColor = const Color(0xFFF08080);
    Color currentColor = Color.lerp(startColor, endColor, progress)!;
    return Scaffold(
      backgroundColor: currentColor,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                today,
                style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: isSuccess
                  ? const Text(
                      'Success!',
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 238, 119, 119),
                      ),
                    )
                  : Text(
                      format(totalSeconds),
                      style: TextStyle(
                          color: Theme.of(context).cardColor,
                          fontSize: 89,
                          fontWeight: FontWeight.w600),
                    ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: IconButton(
                iconSize: 120,
                color: Theme.of(context).cardColor,
                onPressed: isRunning ? onPausePressed : onStartPressed,
                icon: Icon(isRunning
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .color),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                              fontSize: 58,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .color),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Lives Left',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .color),
                            ),
                            Text(
                              '$totalLivesofDay',
                              style: TextStyle(
                                  fontSize: 58,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .color),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Streaks',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .color),
                            ),
                            Text(
                              '$streaks',
                              style: TextStyle(
                                  fontSize: 58,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .color),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
