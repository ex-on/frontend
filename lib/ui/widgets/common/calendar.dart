import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/helpers/utils.dart';
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
enum CalendarSelectMode { monthly, weekly, daily }

class Calendar extends StatefulWidget {
  final Function(DateTime)? updateSelectedDate;
  final Function(DateTime)? onMonthChanged;
  final Map<DateTime, dynamic> exerciseDates;
  // final CalendarDisplayMode displayMode;
  final CalendarSelectMode selectMode;
  const Calendar({
    Key? key,
    this.updateSelectedDate,
    this.onMonthChanged,
    required this.exerciseDates,
    // required this.displayMode,
    required this.selectMode,
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
        if (widget.selectMode == CalendarSelectMode.monthly) {
          if (widget.updateSelectedDate != null) {
            widget.updateSelectedDate!(displayDate);
          }
        }
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
      widget.onMonthChanged!(displayDate);
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
          displayDate =
              DateTime(displayDate.year, displayDate.month + 1, displayDate.day)
                  .firstDateOfWeek;
          if (widget.selectMode == CalendarSelectMode.monthly) {
            if (widget.updateSelectedDate != null) {
              widget.updateSelectedDate!(displayDate);
            }
          }
        });
      } else {
        setState(() {
          displayDate = DateTime(displayDate.year, displayDate.month + 1, 1);
          if (widget.selectMode == CalendarSelectMode.monthly) {
            if (widget.updateSelectedDate != null) {
              widget.updateSelectedDate!(displayDate);
            }
          }
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
      widget.onMonthChanged!(displayDate);
    }
  }

  void _onModeChangePressed() {
    setState(() {
      if (mode == CalendarDisplayMode.monthly) {
        if (widget.selectMode == CalendarSelectMode.daily) {
          if (selectedDate.year == displayDate.year &&
              selectedDate.month == displayDate.month) {
            setState(() {
              displayDate = selectedDate;
            });
          }
        } else if (widget.selectMode == CalendarSelectMode.weekly) {
          if (selectedDate.year == displayDate.year &&
              selectedDate.month == displayDate.month) {
            setState(() {
              displayDate = selectedDate;
            });
          }
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

    Widget _dailySelectCalendarBuilder(DateTime dateTime) {
      int year = dateTime.year;
      int month = dateTime.month;
      var firstWeekdayOfMonth = DateTime(year, month, 1).weekday;
      DateTime firstDateOfWeek = dateTime.firstDateOfWeek;
      int numWeeks = DateTime(year, month + 1, 0).weekOfMonth;
      List<Widget> _children = [];

      if (mode == CalendarDisplayMode.monthly) {
        _children = List.generate(
          7 * (numWeeks + 1),
          (index) {
            if (index < 7) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: SizedBox(
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
                ),
              );
            } else {
              int diff = index - 7 - (firstWeekdayOfMonth - 1);
              DateTime indexDate = DateTime(year, month, 1 + diff);
              bool isSelected = selectedDate == indexDate;
              bool isOtherMonth = indexDate.month != month;

              return SizedBox(
                width: 40,
                height: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isSelected ? brightPrimaryColor : Colors.transparent,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
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
                          splashRadius: 22,
                          splashColor: brightPrimaryColor.withOpacity(0.2),
                          highlightColor: brightPrimaryColor.withOpacity(0.2),
                          icon: Text(
                            indexDate.day.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: indexDate ==
                                      DateTime(now.year, now.month, now.day)
                                  ? 18
                                  : 14,
                              color: () {
                                // if (isSelected) {
                                //   return Colors.white;
                                // } else
                                if (indexDate ==
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
                      Positioned(
                        bottom: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: () {
                            List<Widget> children = [];
                            if (children.length < 2) {
                              if (widget.exerciseDates[indexDate] != null) {
                                for (int targetMuscle
                                    in widget.exerciseDates[indexDate]) {
                                  children.add(
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(
                                          top: 0, left: 2, right: 2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: targetMuscle == 0
                                            ? cardioColor
                                            : targetMuscleIntToColor[
                                                targetMuscle],
                                      ),
                                    ),
                                  );
                                }
                              }
                            }

                            return children;
                          }(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      } else {
        _children = List.generate(
          14,
          (index) {
            if (index < 7) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: SizedBox(
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
                ),
              );
            } else {
              DateTime indexDate =
                  firstDateOfWeek.add(Duration(days: index - 7));
              bool isSelected = selectedDate == indexDate;
              bool isOtherMonth = indexDate.month != dateTime.month;
              return SizedBox(
                width: 40,
                height: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // color:
                    //     isSelected ? brightPrimaryColor.withOpacity(0.5) : null,
                    border: Border.all(
                      color:
                          isSelected ? brightPrimaryColor : Colors.transparent,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
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
                        splashRadius: 22,
                        splashColor: brightPrimaryColor.withOpacity(0.2),
                        highlightColor: brightPrimaryColor.withOpacity(0.2),
                        icon: Text(
                          indexDate.day.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: indexDate ==
                                    DateTime(now.year, now.month, now.day)
                                ? 18
                                : 14,
                            color: () {
                              // if (isSelected) {
                              //   return Colors.white;
                              // } else
                              if (indexDate ==
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
                      Positioned(
                        bottom: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: () {
                            List<Widget> children = [];
                            if (children.length < 2) {
                              if (widget.exerciseDates[indexDate] != null) {
                                for (int targetMuscle
                                    in widget.exerciseDates[indexDate]) {
                                  children.add(
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(
                                          bottom: 2, left: 2, right: 2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: targetMuscle == 0
                                            ? cardioColor
                                            : targetMuscleIntToColor[
                                                targetMuscle],
                                      ),
                                    ),
                                  );
                                }
                              }
                            }

                            return children;
                          }(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      }
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 7,
        childAspectRatio: (context.width - 70) / 7 / 50,
        children: _children,
      );
    }

    Widget _weeklySelectCalendarBuilder(DateTime dateTime) {
      int year = dateTime.year;
      int month = dateTime.month;
      var firstWeekdayOfMonth = DateTime(year, month, 1).weekday;
      int numWeeks = DateTime(year, month + 1, 0).weekOfMonth;

      List<Widget> _children = [
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          children: List.generate(
            7,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SizedBox(
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
              ),
            ),
          ),
        ),
      ];

      if (mode == CalendarDisplayMode.monthly) {
        for (int i = 0; i < numWeeks; i++) {
          bool isSelected =
              selectedDate.month == month && selectedDate.weekOfMonth == i + 1;
          _children.add(
            SizedBox(
              height: 45.5,
              width: context.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (i == 0) {
                            selectedDate = DateTime(year, month, 1);
                          } else if (i == numWeeks - 1) {
                            selectedDate = DateTime(year, month + 1, 0);
                          } else {
                            selectedDate = DateTime(year, month, 1 + i * 7);
                          }
                          if (widget.updateSelectedDate != null) {
                            widget.updateSelectedDate!(selectedDate);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? brightPrimaryColor.withOpacity(0.5)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: GridView.count(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          crossAxisCount: 7,
                          childAspectRatio: (context.width - 40) / (7 * 30),
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(
                            7,
                            (index) {
                              DateTime indexDate = DateTime(year, month,
                                  i * 7 + index - firstWeekdayOfMonth + 2);
                              bool isOtherMonth = indexDate.month != month;

                              return SizedBox(
                                width: 40,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    indexDate.day.toString(),
                                    // textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: indexDate ==
                                              DateTime(
                                                  now.year, now.month, now.day)
                                          ? 18
                                          : 14,
                                      color: () {
                                        if (isSelected) {
                                          return Colors.white;
                                        } else if (indexDate ==
                                            DateTime(
                                                now.year, now.month, now.day)) {
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
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.5,
                    child: GridView.count(
                      padding: EdgeInsets.zero,
                      childAspectRatio: (context.width - 40) / (7 * 15.5),
                      shrinkWrap: true,
                      crossAxisCount: 7,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        7,
                        (index) {
                          DateTime indexDate = DateTime(year, month,
                              i * 7 + index - firstWeekdayOfMonth + 2);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: () {
                              List<Widget> children = [];
                              if (children.length < 2) {
                                if (widget.exerciseDates[indexDate] != null) {
                                  for (int targetMuscle
                                      in widget.exerciseDates[indexDate]) {
                                    children.add(
                                      Container(
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.only(
                                            top: 0, left: 2, right: 2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: targetMuscleIntToColor[
                                              targetMuscle],
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }

                              return children;
                            }(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      } else {
        DateTime firstDateOfWeek = dateTime.firstDateOfWeek;
        int weekNum = displayDate.weekOfMonth;
        bool isSelected =
            selectedDate.month == month && selectedDate.weekOfMonth == weekNum;
        _children.add(
          SizedBox(
            height: 45.5,
            width: context.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (weekNum == 1) {
                          selectedDate = DateTime(year, month, 1);
                        } else if (weekNum == numWeeks) {
                          selectedDate = DateTime(year, month + 1, 0);
                        } else {
                          selectedDate =
                              DateTime(year, month, 1 + (weekNum - 1) * 7);
                        }
                        if (widget.updateSelectedDate != null) {
                          widget.updateSelectedDate!(selectedDate);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? brightPrimaryColor.withOpacity(0.5)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 7,
                        childAspectRatio: (context.width - 40) / (7 * 30) * 1.1,
                        children: List.generate(
                          7,
                          (index) {
                            DateTime indexDate =
                                firstDateOfWeek.add(Duration(days: index));
                            bool isOtherMonth = indexDate.month != month;

                            return SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(
                                child: Text(
                                  indexDate.day.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: indexDate ==
                                            DateTime(
                                                now.year, now.month, now.day)
                                        ? 18
                                        : 14,
                                    color: () {
                                      if (isSelected) {
                                        return Colors.white;
                                      } else if (indexDate ==
                                          DateTime(
                                              now.year, now.month, now.day)) {
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
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.5,
                  child: GridView.count(
                    padding: EdgeInsets.zero,
                    childAspectRatio: (context.width - 40) / (7 * 15.5),
                    shrinkWrap: true,
                    crossAxisCount: 7,
                    children: List.generate(
                      7,
                      (index) {
                        DateTime indexDate =
                            firstDateOfWeek.add(Duration(days: index));
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: () {
                            List<Widget> children = [];
                            if (children.length < 2) {
                              if (widget.exerciseDates[indexDate] != null) {
                                for (int targetMuscle
                                    in widget.exerciseDates[indexDate]) {
                                  children.add(
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(
                                          top: 0, left: 2, right: 2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: targetMuscleIntToColor[
                                            targetMuscle],
                                      ),
                                    ),
                                  );
                                }
                              }
                            }

                            return children;
                          }(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: _children,
      );
    }

    Widget _monthlySelectCalendarBuilder(DateTime dateTime) {
      int year = dateTime.year;
      int month = dateTime.month;
      var firstWeekdayOfMonth = DateTime(year, month, 1).weekday;
      DateTime firstDateOfWeek = dateTime.firstDateOfWeek;
      int numWeeks = DateTime(year, month + 1, 0).weekOfMonth;
      List<Widget> _children = [];

      _children = List.generate(
        7 * (numWeeks + 1),
        (index) {
          if (index < 7) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SizedBox(
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
              ),
            );
          } else {
            int diff = index - 7 - (firstWeekdayOfMonth - 1);
            DateTime indexDate = DateTime(year, month, 1 + diff);
            bool isOtherMonth = indexDate.month != month;

            return Column(
              children: [
                SizedBox(
                  width: 40,
                  height: 30,
                  child: Center(
                    child: Text(
                      indexDate.day.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            indexDate == DateTime(now.year, now.month, now.day)
                                ? 18
                                : 14,
                        color: () {
                          if (indexDate ==
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: () {
                    List<Widget> children = [];
                    if (children.length < 2) {
                      if (widget.exerciseDates[indexDate] != null) {
                        for (int targetMuscle
                            in widget.exerciseDates[indexDate]) {
                          children.add(
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(
                                  top: 0, left: 2, right: 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: targetMuscleIntToColor[targetMuscle],
                              ),
                            ),
                          );
                        }
                      }
                    }

                    return children;
                  }(),
                ),
              ],
            );
          }
        },
      );

      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 7,
        children: _children,
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: mainBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      height: mode == CalendarDisplayMode.monthly
          ? (displayDate.numWeeksInMonth * 50 + 110)
          : (50 + 110),
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
                        width: 50,
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
                        width: 50,
                        child: widget.selectMode == CalendarSelectMode.monthly
                            ? null
                            : TextActionButton(
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
                    child: () {
                      switch (widget.selectMode) {
                        case CalendarSelectMode.daily:
                          return _dailySelectCalendarBuilder(displayDate);
                        case CalendarSelectMode.weekly:
                          return _weeklySelectCalendarBuilder(displayDate);
                        case CalendarSelectMode.monthly:
                          return _monthlySelectCalendarBuilder(displayDate);
                      }
                    }(),
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
