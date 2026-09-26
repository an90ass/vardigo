import 'package:flutter/material.dart';

/// Screen 1: Eşleşen Personeller (Employer View)
// TODO[ANAS]: UI design
class EmployerCandidatesPage extends StatelessWidget {
  const EmployerCandidatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Eşleşen Personeller (İşveren)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
