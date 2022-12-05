import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/app_local.dart';
import 'package:flutter_localization/cach_helper.dart';
import 'package:flutter_localization/cubit/local_cubit.dart';
import 'package:flutter_localization/cubit/local_state.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => LocalCubit()..getSavedLanguage(),
        child: BlocBuilder<LocalCubit, LocalState>(
          builder: (context, state) {
            if (state is ChangeLocalState) {
              return MaterialApp(
                locale: state.locale,
                title: 'Localization in flutter example ',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                supportedLocales: [
                  Locale('en', ""),
                  Locale("ar", ""),
                ],
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (currentLocal, supportedLocales) {
                  for (var locale in supportedLocales) {
                    if (currentLocal != null &&
                        currentLocal.languageCode == locale.languageCode) {
                      return currentLocal;
                    }
                  }
                  return supportedLocales.first;
                },
                home: HomeScreen(),
              );
            }
            return SizedBox();
          },
        ));
  }
}
