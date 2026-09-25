import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/constants/app_dimensions.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VardigoApp());
}

class VardigoApp extends StatelessWidget {
  const VardigoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppDimensions.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Vardigo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const AppEntryScaffold(),
        );
      },
    );
  }
}


class AppEntryScaffold extends StatelessWidget {
  const AppEntryScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    const screenContent = Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Vardigo Mobile App',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );


   

    return screenContent;
  }
}
