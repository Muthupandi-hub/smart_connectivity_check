import 'package:flutter/material.dart';
import 'package:smart_connectivity_check/smart_connectivity_check.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SmartConnectivity.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConnectivityTestScreen(),
    );
  }
}

class ConnectivityTestScreen extends StatefulWidget {
  const ConnectivityTestScreen({super.key});

  @override
  State<ConnectivityTestScreen> createState() =>
      _ConnectivityTestScreenState();
}

class _ConnectivityTestScreenState extends State<ConnectivityTestScreen> {
  bool isOnline = true;

  @override
  void initState() {
    super.initState();

    SmartConnectivity.onStatusChange.listen((status) {
      setState(() {
        isOnline = status;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Connectivity Test'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOnline ? Icons.wifi : Icons.wifi_off,
              size: 80,
              color: isOnline ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              isOnline ? 'Internet Connected' : 'No Internet Connection',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                bool result = await SmartConnectivity.checkNow();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      result
                          ? '✅ Internet is Working'
                          : '❌ Internet Not Available',
                    ),
                  ),
                );
              },
              child: const Text('Check Internet Now'),
            ),
          ],
        ),
      ),
    );
  }
}
