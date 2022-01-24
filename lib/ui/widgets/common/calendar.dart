import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/helpers/date_time_finder.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'dart:math' as Math;

const List<String> listOfMonths = [
  "1월",
  "2월",
  "3월",
  "4월",
  "5월",
  "6월",
  "7월",
  "8월",
  "9월",
  "10월",
  "11월",
  "12월",
];

const List<String> listOfDays = ["월", "화", "수", "목", "금", "토", "일"];

enum CalendarDisplayMode { monthly, weekly }

class Calendar extends StatefulWidget {
  // final DateTime selectedDate;
  final Function(DateTime)? updateSelectedDate;
  final Function()? onMonthChanged;
  const Calendar({
    Key? key,
    // required this.selectedDate,
    this.updateSelectedDate,
    this.onMonthChanged,
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day); // TO tracking date
  DateTime displayDate = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day - DateTime.now().weekday + 1);
  PageController controller = PageController(initialPage: 1);
  CalendarDisplayMode mode = CalendarDisplayMode.monthly;
  ScrollController scrollController =
      ScrollController(); //To Track Scroll of ListView

  void _onPreviousPressed() {
    DateTime previousDate = displayDate;
    if (mode == CalendarDisplayMode.monthly) {
      controller.jumpToPage(controller.page!.toInt() + 1);
      controller.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        displayDate = DateTime(displayDate.year, displayDate.month - 1);
      });
    } else {
      controller.jumpToPage(controller.page!.toInt() + 1);
      controller.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        displayDate =
            DateTime(displayDate.year, displayDate.month, displayDate.day - 7);
      });
    }
    if (previousDate.month != displayDate.month) {
      widget.onMonthChanged!();
    }
  }

  void _onNextPressed() {
    DateTime previousDate = displayDate;
    if (mode == CalendarDisplayMode.monthly) {
      controller.jumpToPage(controller.page!.toInt() - 1);
      controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      if (displayDate.year == DateTime.now().year &&
          displayDate.month == DateTime.now().month - 1) {
        setState(() {
          displayDate = getFirstDateOfWeek(DateTime(
              displayDate.year, displayDate.month + 1, displayDate.day));
        });
      } else {
        setState(() {
          displayDate = DateTime(displayDate.year, displayDate.month + 1, 1);
        });
      }
    } else {
      controller.jumpToPage(controller.page!.toInt() - 1);
      controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        displayDate =
            DateTime(displayDate.year, displayDate.month, displayDate.day + 7);
      });
    }
    if (previousDate.month != displayDate.month) {
      widget.onMonthChanged!();
    }
  }

  void _onModeChangePressed() {
    setState(() {
      if (mode == CalendarDisplayMode.monthly) {
        if (selectedDate.year == displayDate.year &&
            selectedDate.month == displayDate.month) {
          setState(() {
            displayDate = selectedDate;
          });
        }
        mode = CalendarDisplayMode.weekly;
      } else {
        mode = CalendarDisplayMode.monthly;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    List<Widget> _monthlyDateListBuilder(int year, int month) {
      var firstWeekdayOfMonth = DateTime(year, month, 1).weekday;
      var lastDayOfMonth = DateTime(year, month + 1, 0).day;
      return List.generate(
        42,
        (index) {
          if (index < 7) {
            return SizedBox(
              width: 25,
              height: 25,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  listOfDays[index],
                  style: const TextStyle(
                    fontSize: 14,
                    color: deepGrayColor,
                  ),
                ),
              ),
            );
          } else {
            int diff = index - 7 - (firstWeekdayOfMonth - 1);
            DateTime indexDate = DateTime(year, month, 1 + diff);
            bool isSelected = selectedDate == indexDate;
            bool isOtherMonth = indexDate.month != month;

            return Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    color: isSelected ? brightPrimaryColor : null,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        selectedDate = indexDate;
                        displayDate = indexDate;
                      });
                      if (widget.updateSelectedDate != null) {
                        widget.updateSelectedDate!(selectedDate);
                      }
                    },
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                    icon: Text(
                      indexDate.day.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            indexDate == DateTime(now.year, now.month, now.day)
                                ? 18
                                : 14,
                        color: () {
                          if (isSelected) {
                            return Colors.white;
                          } else if (indexDate ==
                              DateTime(now.year, now.month, now.day)) {
                            return brightPrimaryColor;
                          } else if (isOtherMonth) {
                            return lightGrayColor;
                          } else {
                            return deepGrayColor;
                          }
                        }(),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      );
    }

    List<Widget> _weeklyDateListBuilder(DateTime dateTime) {
      DateTime firstDateOfWeek = getFirstDateOfWeek(dateTime);

      return List.generate(
        14,
        (index) {
          if (index < 7) {
            return SizedBox(
              width: 25,
              height: 25,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  listOfDays[index],
                  style: const TextStyle(
                    fontSize: 14,
                    color: deepGrayColor,
                  ),
                ),
              ),
            );
          } else {
            DateTime indexDate = firstDateOfWeek.add(Duration(days: index - 7));
            bool isSelected = selectedDate == indexDate;
            bool isOtherMonth = indexDate.month != dateTime.month;
            return Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? brightPrimaryColor : null,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        selectedDate = indexDate;
                        displayDate = indexDate;
                      });
                      if (widget.updateSelectedDate != null) {
                        widget.updateSelectedDate!(selectedDate);
                      }
                    },
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                    icon: Text(
                      indexDate.day.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            indexDate == DateTime(now.year, now.month, now.day)
                                ? 18
                                : 14,
                        color: () {
                          if (isSelected) {
                            return Colors.white;
                          } else if (indexDate ==
                              DateTime(now.year, now.month, now.day)) {
                            return brightPrimaryColor;
                          } else if (isOtherMonth) {
                            return lightGrayColor;
                          } else {
                            return deepGrayColor;
                          }
                        }(),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      height: mode == CalendarDisplayMode.monthly ? 350 : 150,
      width: context.width - 40,
      child: Material(
        type: MaterialType.transparency,
        child: NotificationListener(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: PageView.builder(
            controller: controller,
            itemCount: 3,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _onPreviousPressed,
                            splashRadius: 18,
                            padding: EdgeInsets.zero,
                            iconSize: 18,
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18,
                              color: deepGrayColor,
                            ),
                          ),
                          Text(
                            DateFormat('yyyy년 MM월').format(displayDate),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: deepGrayColor,
                              fontSize: 18,
                            ),
                          ),
                          Transform.rotate(
                            angle: -Math.pi,
                            child: IconButton(
                              onPressed: _onNextPressed,
                              padding: EdgeInsets.zero,
                              iconSize: 18,
                              splashRadius: 18,
                              icon: const Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 18,
                                color: deepGrayColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 40,
                        child: TextActionButton(
                          buttonText: mode == CalendarDisplayMode.monthly
                              ? '한 주'
                              : '한 달',
                          onPressed: _onModeChangePressed,
                          isUnderlined: false,
                          textColor: brightPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 7,
                      children: mode == CalendarDisplayMode.monthly
                          ? _monthlyDateListBuilder(
                              displayDate.year, displayDate.month)
                          : _weeklyDateListBuilder(displayDate),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
