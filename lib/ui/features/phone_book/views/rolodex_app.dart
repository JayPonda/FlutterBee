import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:basics/ui/core/theme/app_theme.dart';
import 'package:basics/ui/core/theme/theme_provider.dart';
import 'package:basics/ui/features/phone_book/view_models/contact_view_model.dart';
import 'package:basics/data/database/app_database.dart';
import 'package:basics/data/repositories/drift_contact_repository.dart';
import 'package:basics/domain/repositories/i_contact_repository.dart';
import 'app_loader.dart';
import 'app_routes.dart';

class RolodexApp extends StatefulWidget {
  const RolodexApp({super.key});

  @override
  State<RolodexApp> createState() => _RolodexAppState();
}

class _RolodexAppState extends State<RolodexApp> {
  late ThemeProvider _themeProvider;
  late AppDatabase _database;
  late IContactRepository _repository;

  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider();
    _database = AppDatabase();
    _repository = DriftContactRepository(_database);
    
    _initialize();
  }

  Future<void> _initialize() async {
    await _themeProvider.init();
  }

  @override
  void dispose() {
    _themeProvider.dispose();
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeProvider),
        Provider<AppDatabase>.value(value: _database),
        Provider<IContactRepository>.value(value: _repository),
        ChangeNotifierProvider(
          create: (_) => ContactViewModel(_repository),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          final brightness = MediaQuery.platformBrightnessOf(context);
          final isDarkMode = themeProvider.isDarkMode(brightness);

          return CupertinoApp(
            title: 'Rolodex',
            theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
            onGenerateRoute: generateRoute,
            home: const AppLoader(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
