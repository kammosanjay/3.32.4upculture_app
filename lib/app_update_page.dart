import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppUpdateInfo? _updateInfo;

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    try {
      _updateInfo = await InAppUpdate.checkForUpdate();

      if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
        // You can choose: Immediate or Flexible
        // InAppUpdate.performImmediateUpdate(); // Forcing immediate update
        // Or for flexible:
        InAppUpdate.startFlexibleUpdate().then(
          (_) => InAppUpdate.completeFlexibleUpdate(),
        );
      }
    } catch (e) {
      debugPrint('Update check failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home Page')),
    );
  }
}
