import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_app/models/money.dart';
import 'package:money_app/screens/home_screen.dart';
import 'package:money_app/screens/main_screen.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(MoneyAdapter());
  await Hive.openBox<Money>('moneyBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static void getData(){
    HomeScreen.money.clear();
    Box<Money> hiveBox = Hive.box<Money>('moneyBox');
    for (var element in hiveBox.values) {
      HomeScreen.money.add(element);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, fontFamily: 'is',),
      debugShowCheckedModeBanner: false,
      title: 'اپلیکیشن مدیرت مالی',
      home: const MainScreen(),
    );
  }
}
