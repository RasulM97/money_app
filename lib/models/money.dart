import 'package:hive/hive.dart';

part 'money.g.dart';

@HiveType(typeId: 0)
class Money {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String price;
  @HiveField(3)
  String date;
  @HiveField(4)
  bool isReceived;

  Money({
    required this.id,
    required this.title,
    required this.price,
    required this.date,
    required this.isReceived,
  });
}
