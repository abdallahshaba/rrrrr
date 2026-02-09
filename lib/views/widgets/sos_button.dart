import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SOSButton extends StatelessWidget {
  const SOSButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Get.toNamed(RoutesConfig.sos),
      backgroundColor: Colors.red,
      icon: const Icon(Icons.warning, color: Colors.white),
      label: const Text(
        'SOS',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}