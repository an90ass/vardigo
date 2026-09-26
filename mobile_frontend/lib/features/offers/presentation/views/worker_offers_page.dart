import 'package:flutter/material.dart';

/// Screen 2: Görüşme Talepleri (Worker View)
class WorkerOffersPage extends StatelessWidget {
  const WorkerOffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Görüşme Talepleri (İş Arayan)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
