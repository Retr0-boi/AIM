import 'package:flutter/material.dart';
void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text("TEST"),
            backgroundColor: const Color.fromARGB(255, 0, 225, 255),
          ),
          body: SafeArea(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: Colors.lime[600],
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(20.0),
                    child: const Text("BIG ENDI!"),
                  ),
                  Container(
                    color: Colors.red[600],
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(20.0),
                    child: const Text("MEDIUM ENDI!"),
                  ),
                  Container(
                    color: Colors.green[600],
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(20.0),
                    child: const Text("SMALL ENDI!"),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
