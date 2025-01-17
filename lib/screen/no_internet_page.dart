import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {

  const NoInternetPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              "Pas de connexion Internet",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final connectivityResult = await Connectivity().checkConnectivity();
                bool isConnected = (connectivityResult != ConnectivityResult.none);

                if (isConnected) {
                  if (context.mounted) {
                    Navigator.popAndPushNamed(context, "/");
                  }
                }
              },
              child: const Text("Réessayer"),
            ),
          ],
        ),
      ),
    );
  }
}
