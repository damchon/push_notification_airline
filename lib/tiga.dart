import 'package:flutter/material.dart';
import 'package:pushy/home.dart';

class tiga extends StatelessWidget {
  const tiga({super.key});

  @override
  Widget build(BuildContext context) {
    print('herehereherehre');
    return Scaffold(
      appBar: AppBar(
        title: const Text('tiga page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is the tiga Page!',
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