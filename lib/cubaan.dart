import 'package:flutter/material.dart';
import 'package:pushy/home.dart';

class Cubapage extends StatelessWidget {
  const Cubapage({super.key});

  @override
  Widget build(BuildContext context) {
    print('herehereherehre');
    return Scaffold(
      appBar: AppBar(
        title: const Text('cuba page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is the Cuba Page!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("ke main page");
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: ''),
                  ),
                );
              },
              child: const Text('Go to Home Page'),
            )
          ],
        ),
      ),
    );
  }
}