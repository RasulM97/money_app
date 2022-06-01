import 'package:flutter/material.dart';
import 'package:money_app/constant.dart';
import 'package:money_app/utils/calculate.dart';

import '../widget/chart_widget.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 1050
              ? MediaQuery.of(context).size.width * .5
              : double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Flexible(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  child: Text(
                    'مدیریت تراکنش ها به تومان',
                    style: kFontSize,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
              MoneyInfoWidget(
                firstText: 'دریافتی امروز :',
                firstPrice: Calculate.dToday().toString(),
                secondText: 'پرداختی امروز :',
                secondPrice: Calculate.pToday().toString(),
              ),
              MoneyInfoWidget(
                firstText: 'دریافتی این ماه :',
                firstPrice: Calculate.dMonth().toString(),
                secondText: 'پرداختی این ماه :',
                secondPrice: Calculate.pMonth().toString(),
              ),
              MoneyInfoWidget(
                firstText: 'دریافتی این سال :',
                firstPrice: Calculate.dYear().toString(),
                secondText: 'پرداختی این سال :',
                secondPrice: Calculate.pYear().toString(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Calculate.pYear() == 0 || Calculate.dYear() == 0
                  ? Container()
                  : const Expanded(
                      child: BarChartWidget(),
                    ),
            ],
          ),
        ),
      ),
    ));
  }
}

//! money info widget
class MoneyInfoWidget extends StatelessWidget {
  const MoneyInfoWidget(
      {Key? key,
      required this.firstText,
      required this.firstPrice,
      required this.secondText,
      required this.secondPrice})
      : super(key: key);

  final String firstText;
  final String secondText;
  final String firstPrice;
  final String secondPrice;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child: Text(
                  firstPrice,
                  style: kFontSize,
                )),
                Expanded(
                    child: Text(
                  firstText,
                  style: kFontSize,
                  textDirection: TextDirection.rtl,
                )),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child: Text(
                  secondPrice,
                  style: kFontSize,
                )),
                Expanded(
                    child: Text(
                  secondText,
                  style: kFontSize,
                  textDirection: TextDirection.rtl,
                )),
              ],
            ),
          ),
          const Expanded(
            child: Divider(
              height: 1.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
