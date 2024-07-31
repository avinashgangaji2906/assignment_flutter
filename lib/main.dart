import 'package:assignment_flutter/core/theme/app_theme.dart';
import 'package:assignment_flutter/presentation/pages/user_form_page.dart';
import 'package:assignment_flutter/provider/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// get directory path
  final dir = await getApplicationDocumentsDirectory();
// initialize
  Hive.init(dir.path);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: MaterialApp(
        title: 'Flutter App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkThemeMode,
        home: const UserFormScreen(),
      ),
    );
  }
}
