import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/database_provider.dart';
import 'services/database_service.dart';
import 'presentation/screens/main_screen.dart';
import 'core/constants/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CPEApplication());
}

class CPEApplication extends StatelessWidget {
  const CPEApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CPE Database System',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.accent,
            primary: AppColors.primary,
            secondary: AppColors.accent,
          ),
          scaffoldBackgroundColor: AppColors.bgLight,
          fontFamily: 'Roboto',
        ),
        home: const MainScreen(),
      ),
    );
  }
}
