import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:money_app/constant.dart';
import 'package:money_app/main.dart';
import 'package:money_app/screens/new_transaction_screen.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

import '../models/money.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static List<Money> money = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: fabWidget(),
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width > 1050
                ? MediaQuery.of(context).size.width * .5
                : double.infinity,
            child: Column(
              children: [
                headerWidget(),
                const Divider(),
                HomeScreen.money.isEmpty
                    ? const Expanded(child: EmptyWidget())
                    : Expanded(
                        child: ListView.builder(
                            itemCount: HomeScreen.money.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: MyListTileWidget(
                                  index: index,
                                ),
                                //* Edit
                                onTap: () {
                                  NewTransactionScreen.date =
                                      HomeScreen.money[index].date;
                                  NewTransactionScreen.descriptionController
                                      .text = HomeScreen.money[index].title;
                                  NewTransactionScreen.priceController.text =
                                      HomeScreen.money[index].price;
                                  NewTransactionScreen.groupId =
                                      HomeScreen.money[index].isReceived ? 1 : 2;
                                  NewTransactionScreen.isEditing = true;
                                  NewTransactionScreen.id =
                                      HomeScreen.money[index].id;
                                  NewTransactionScreen.index = index;
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const NewTransactionScreen()))
                                      .then((value) {
                                    MyApp.getData();
                                    setState(() {});
                                  });
                                },
                                //! Delete
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            actionsAlignment:
                                                MainAxisAlignment.spaceAround,
                                            title: const Text(
                                              'آیا از حذف این المان مطمئن هستید؟',
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'خیر',
                                                    textDirection:
                                                        TextDirection.rtl,
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      hiveBox.deleteAt(index);
                                                      MyApp.getData();
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'بله',
                                                    textDirection:
                                                        TextDirection.rtl,
                                                  ))
                                            ],
                                          ));
                                },
                              );
                            }),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //! header widget
  Widget headerWidget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: SearchBarAnimation(
              hintText: '... جستجو',
              buttonElevation: 0,
              buttonBorderColour: Colors.black26,
              buttonShadowColour: Colors.black26,
              enableBoxBorder: true,
              enableButtonBorder: true,
              enableKeyboardFocus: true,
              enableButtonShadow: false,
              enableBoxShadow: false,
              textEditingController: searchController,
              isOriginalAnimation: false,
              buttonIcon: CupertinoIcons.search,
              secondaryButtonIcon: Icons.close_rounded,
              trailingIcon: CupertinoIcons.search,
              durationInMilliSeconds: 500,
              onCollapseComplete: () {
                setState(() {
                  searchController.text = '';
                  MyApp.getData();
                });
              },
              onFieldSubmitted: (String text) {
                List<Money> result = hiveBox.values
                    .where(
                      (element) =>
                          element.title.contains(text) ||
                          element.date.contains(text) ||
                          element.price.contains(text),
                    )
                    .toList();
                HomeScreen.money.clear();
                setState(() {
                  for (var element in result) {
                    HomeScreen.money.add(element);
                  }
                });
              },
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          const Text(
            'تراکنشات',
            style: kFontSize,
          ),
        ],
      ),
    );
  }

  //! fab widget
  Widget fabWidget() {
    return FloatingActionButton(
      onPressed: () {
        NewTransactionScreen.date = 'تاریخ';
        NewTransactionScreen.groupId = 0;
        NewTransactionScreen.priceController.text = '';
        NewTransactionScreen.descriptionController.text = '';
        NewTransactionScreen.isEditing = false;
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NewTransactionScreen()))
            .then((value) {
          MyApp.getData();
          setState(() {});
        });
      },
      elevation: 5,
      backgroundColor: kPurpleColor,
      child: const Icon(CupertinoIcons.add),
    );
  }

  @override
  void initState() {
    MyApp.getData();
    super.initState();
  }
}

//! my list tile widget
class MyListTileWidget extends StatelessWidget {
  const MyListTileWidget({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تومان',
                    style: TextStyle(
                      color: HomeScreen.money[index].isReceived
                          ? kGreenColor
                          : kRedColor,
                    ),
                  ),
                  Text(
                    HomeScreen.money[index].price,
                    style: TextStyle(
                        color: HomeScreen.money[index].isReceived
                            ? kGreenColor
                            : kRedColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                HomeScreen.money[index].date,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(HomeScreen.money[index].title),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  HomeScreen.money[index].isReceived ? kGreenColor : kRedColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
                child: Icon(
              HomeScreen.money[index].isReceived
                  ? CupertinoIcons.plus
                  : CupertinoIcons.minus,
              color: Colors.white,
            )),
          ),
        ],
      ),
    );
  }
}

//! empty widget
class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Flexible(
          child: SvgPicture.asset(
            'assets/images/notask.svg',
            height: MediaQuery.of(context).size.height * .3,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          'تراکنشی موجود نیست!',
          style: kFontSize,
          textDirection: TextDirection.rtl,
        ),
        const Spacer(),
      ],
    );
  }
}
