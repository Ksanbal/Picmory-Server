import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:picmory/common/buttons/rounded_button.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/caption_sm_style.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';
import 'package:picmory/common/families/text_styles/title_sm_style.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:table_calendar/table_calendar.dart';

class ChangeDateBottomsheet extends StatefulWidget {
  const ChangeDateBottomsheet({
    super.key,
    required this.focusedDay,
  });

  final DateTime focusedDay;

  @override
  State<ChangeDateBottomsheet> createState() => _ChangeDateBottomsheetState();
}

class _ChangeDateBottomsheetState extends State<ChangeDateBottomsheet> {
  late DateTime _selectedDay;

  @override
  void initState() {
    _selectedDay = widget.focusedDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 상단 안내바
          Container(
            width: 70,
            height: 4,
            decoration: BoxDecoration(
              color: ColorFamily.disabledGrey400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 캘린더
          TableCalendar(
            currentDay: _selectedDay,
            focusedDay: _selectedDay,
            firstDay: DateTime(2017, 1, 1),
            lastDay: DateTime.now(),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rowHeight: 46,
            daysOfWeekHeight: 30,
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextStyle: const TextSmStyle(),
              titleTextFormatter: (date, locale) => DateFormat('yyyy.MM').format(date),
              formatButtonVisible: false,
              leftChevronIcon: const Icon(
                SolarIconsOutline.roundAltArrowLeft,
                color: Colors.black,
              ),
              rightChevronIcon: const Icon(
                SolarIconsOutline.roundAltArrowRight,
                color: Colors.black,
              ),
              headerPadding: const EdgeInsets.symmetric(vertical: 20),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              dowTextFormatter: (date, locale) {
                return DateFormat.E().format(date).toUpperCase();
              },
              weekdayStyle: const CaptionSmStyle(
                color: ColorFamily.disabledGrey500,
              ),
              weekendStyle: const CaptionSmStyle(
                color: ColorFamily.disabledGrey500,
              ),
            ),
            calendarStyle: const CalendarStyle(
              cellMargin: EdgeInsets.zero,
              defaultTextStyle: TitleSmStyle(
                color: ColorFamily.textGrey900,
              ),
              weekendTextStyle: TitleSmStyle(
                color: ColorFamily.textGrey900,
              ),
              disabledTextStyle: TitleSmStyle(
                color: ColorFamily.disabledGrey300,
              ),
              outsideTextStyle: TitleSmStyle(
                color: ColorFamily.disabledGrey300,
              ),
              selectedTextStyle: TitleSmStyle(
                color: ColorFamily.primaryDark,
              ),
              selectedDecoration: BoxDecoration(
                color: ColorFamily.primaryLight,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return Container(
                  alignment: Alignment.center,
                  decoration: isSameDay(day, widget.focusedDay)
                      ? const BoxDecoration(
                          color: ColorFamily.backgroundGrey200,
                          // color: Colors.white,
                          shape: BoxShape.circle,
                        )
                      : null,
                  child: Text(
                    day.day.toString(),
                    style: const TitleSmStyle(),
                  ),
                );
              },
            ),
          ),
          // 완료 버튼
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: RoundedButton(
              onPressed: () => context.pop(_selectedDay),
              child: const Text(
                "완료",
                style: TextSmStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
