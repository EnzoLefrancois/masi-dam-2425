import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
            Text(
              AppLocalizations.of(context)!.noInternetPageText,
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
              child: Text(AppLocalizations.of(context)!.noInternetPageButton),
            ),
          ],
        ),
      ),
    );
  }
}
