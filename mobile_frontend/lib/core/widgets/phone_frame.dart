import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class PhoneFrame extends StatelessWidget {
  final Widget child;
  final bool enableFrame;

  static const bool envForceFrame = bool.fromEnvironment('REFERENCE_FRAME', defaultValue: false) ||
      bool.fromEnvironment('FRAME', defaultValue: false);

  const PhoneFrame({
    super.key,
    required this.child,
    this.enableFrame = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enableFrame) return child;

    final screenSize = MediaQuery.of(context).size;
    final isWiderScreen = screenSize.width > 450 || screenSize.height > 920;
    final isDesktopOrWeb = kIsWeb || (!Platform.isAndroid && !Platform.isIOS);
    final shouldShowFrame = envForceFrame || (isDesktopOrWeb && isWiderScreen);

    if (!shouldShowFrame) {
      return child;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E24),
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            width: 390 + 24,
            height: 844 + 24,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D11),
              borderRadius: BorderRadius.circular(54),
              border: Border.all(color: const Color(0xFF2E2E38), width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 36,
                  spreadRadius: 8,
                  offset: Offset(0, 16),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(42),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        size: const Size(390, 844),
                        padding: const EdgeInsets.only(top: 44, bottom: 34),
                        viewPadding: const EdgeInsets.only(top: 44, bottom: 34),
                      ),
                      child: ScaffoldMessenger(
                        child: child,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 44,
                    child: _buildStatusBar(),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 134,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          _buildDynamicIsland(),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.signal_cellular_4_bar_rounded, size: 14, color: Colors.black),
              SizedBox(width: 4),
              Icon(Icons.wifi_rounded, size: 14, color: Colors.black),
              SizedBox(width: 4),
              Icon(Icons.battery_full_rounded, size: 18, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicIsland() {
    return Container(
      width: 120,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 11,
            height: 11,
            margin: const EdgeInsets.only(right: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
