import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_app/constant.dart';
import 'package:money_app/main.dart';
import 'package:money_app/models/money.dart';
import 'package:money_app/screens/home_screen.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class NewTransactionScreen extends StatefulWidget {
  const NewTransactionScreen({Key? key}) : super(key: key);
  static int groupId = 0;
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static bool isEditing = false;
  static int id = 0;
  static String date = 'تاریخ';
  static int index = 0;

  @override
  State<NewTransactionScreen> createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');

  @override
  void initState() {
    Jalali j = Jalali.now();
    var y = j.year.toString();
    var m = j.month.toString().length == 1 ? '0${j.month}' : j.month.toString();
    var d = j.day.toString().length == 1 ? '0${j.day}' : j.day.toString();
    if (NewTransactionScreen.isEditing) {
      NewTransactionScreen.date =
          HomeScreen.money[NewTransactionScreen.index].date;
    } else {
      NewTransactionScreen.date = '$y/$m/$d';
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width > 1050
                ? MediaQuery.of(context).size.width * .5
                : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(CupertinoIcons.back)),
                    Text(
                      NewTransactionScreen.isEditing
                          ? 'ویرایش تراکنش'
                          : 'تراکنش جدید',
                      style: kFontSize,
                    ),
                  ],
                ),
                const MyCustomHeight(),
                MyTextField(
                  hintText: 'توضیحات',
                  controller: NewTransactionScreen.descriptionController,
                ),
                const MyCustomHeight(),
                MyTextField(
                  hintText: 'مبلغ',
                  type: TextInputType.number,
                  controller: NewTransactionScreen.priceController,
                ),
                const MyCustomHeight(),
                const TypeAndDateWidget(),
                const MyCustomHeight(),
                MyButton(
                  text: NewTransactionScreen.isEditing
                      ? 'ویرایش کردن'
                      : 'اضافه کردن',
                  onPressed: () {
                    Money item = Money(
                        id: Random().nextInt(999999999),
                        title: NewTransactionScreen.descriptionController.text,
                        price: NewTransactionScreen.priceController.text,
                        date: NewTransactionScreen.date,
                        isReceived: NewTransactionScreen.groupId == 1 ||
                                NewTransactionScreen.groupId == null
                            ? true
                            : false);
                    if (NewTransactionScreen.isEditing) {
                      int index = 0;
                      MyApp.getData();
                      for (int i = 0; i < hiveBox.values.length; i++) {
                        if (hiveBox.values.elementAt(i).id ==
                            NewTransactionScreen.id) {
                          index = i;
                        }
                      }
                      hiveBox.putAt(index, item);
                    } else {
                      hiveBox.add(item);
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//! my button
class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor: kPurpleColor,
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

//! my custom height
class MyCustomHeight extends StatelessWidget {
  const MyCustomHeight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .02,
    );
  }
}

//! type and date widget
class TypeAndDateWidget extends StatefulWidget {
  const TypeAndDateWidget({Key? key}) : super(key: key);

  @override
  State<TypeAndDateWidget> createState() => _TypeAndDateWidgetState();
}

class _TypeAndDateWidgetState extends State<TypeAndDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MyRadioButton(
              title: 'پرداختی',
              value: 2,
              groupValue: NewTransactionScreen.groupId,
              onChanged: (value) {
                setState(() {
                  NewTransactionScreen.groupId = value!;
                });
              },
            ),
          ),
          Expanded(
            child: MyRadioButton(
              title: 'دریافتی',
              value: 1,
              groupValue: NewTransactionScreen.groupId,
              onChanged: (value) {
                setState(() {
                  NewTransactionScreen.groupId = value!;
                });
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                var pickedDate = await showPersianDatePicker(
                  context: context,
                  initialDate: Jalali.now(),
                  firstDate: Jalali(1400),
                  lastDate: Jalali(1500),
                );
                setState(() {
                  String year = pickedDate!.year.toString();
                  String month = pickedDate.month.toString().length == 1
                      ? '0${pickedDate.month.toString()}'
                      : pickedDate.month.toString();
                  String day = pickedDate.day.toString().length == 1
                      ? '0${pickedDate.day.toString()}'
                      : pickedDate.day.toString();
                  NewTransactionScreen.date = '$year/$month/$day';
                });
              },
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  side: MaterialStateProperty.all(
                    const BorderSide(color: kPurpleColor),
                  )),
              child: Text(
                NewTransactionScreen.date,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//! my radio button
class MyRadioButton extends StatelessWidget {
  const MyRadioButton({
    Key? key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final int value;
  final int groupValue;
  final void Function(int?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          title,
        ),
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: kPurpleColor,
        ),
      ],
    );
  }
}

//! my text field
class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.hintText,
    this.type = TextInputType.text,
    required this.controller,
  }) : super(key: key);
  final String hintText;
  final TextInputType type;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      cursorColor: Colors.black38,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        hintText: hintText,
      ),
    );
  }
}
