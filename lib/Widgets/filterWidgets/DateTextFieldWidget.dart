import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:table_calendar/table_calendar.dart';

class DateTextFieldWidget extends StatefulWidget{
  final TextEditingController controller;
  final String labelText;
  const DateTextFieldWidget({super.key, required this.controller, required this.labelText});

  @override
  State<DateTextFieldWidget> createState() => _DateTextFieldWidgetState();
}

class _DateTextFieldWidgetState extends State<DateTextFieldWidget> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
      return SizedBox(
        width: MediaQuery.of(context).size.width*0.23,
        child: TextField(
          controller: widget.controller,
          style: TextStyle(
              color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
          textAlign: TextAlign.center,
          showCursor: false,
          mouseCursor: SystemMouseCursors.click,
          onTap: () {
            if(widget.controller.text != ''){
              _selectedDay = DateFormat.yMMMMd('en_US')
                  .parse(widget.controller.text);
            }

            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      content: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.588,
                          decoration: const BoxDecoration(
                              color: white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))),
                          padding: const EdgeInsets.all(10),
                          child: TableCalendar(
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              if (!isSameDay(_selectedDay, selectedDay)) {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;

                                if (_selectedDay != null &&
                                    _selectedDay.toString().isNotEmpty) {
                                  widget.controller.text = DateFormat.yMMMMd('en_US').format(_selectedDay!);
                                }
                                Navigator.of(context).pop();
                              }
                            },
                            eventLoader: (day) {
                              return (isSameDay(DateTime.now(), day))
                                  ? [DateTime.now()]
                                  : [];
                            },
                            calendarFormat: _calendarFormat,
                            focusedDay: _focusedDay,
                            firstDay: DateTime.utc(DateTime.now().year - 5,
                                1, 1),
                            lastDay: DateTime.now(),
                            headerStyle: HeaderStyle(
                              headerPadding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              leftChevronIcon: Image.asset(
                                  'assets/images/calendar_previous.png'),
                              rightChevronIcon: Image.asset(
                                  'assets/images/calendar_next.png'),
                              formatButtonVisible: false,
                              titleTextStyle: const TextStyle(
                                  color: black,
                                  fontFamily: 'Montserrat',
                                  fontSize: 20),
                              titleCentered: true,
                            ),
                            calendarStyle: CalendarStyle(
                                markersAutoAligned: false,
                                markersAlignment: Alignment.topRight,
                                markerMargin: const EdgeInsets.all(10),
                                markersMaxCount: 1,
                                canMarkersOverflow: false,
                                outsideDecoration: const BoxDecoration(
                                  color: white,
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                                ),
                                weekendDecoration: const BoxDecoration(
                                  color: white,
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                                ),
                                disabledDecoration: const BoxDecoration(
                                  color: white,
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                                ),
                                defaultDecoration: const BoxDecoration(
                                  color: white,
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: truckGreen,
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(2)),
                                ),
                                selectedTextStyle: const TextStyle(
                                    fontFamily: 'Montserrat', color: white),
                                defaultTextStyle:
                                const TextStyle(fontFamily: 'Montserrat'),
                                weekendTextStyle:
                                const TextStyle(fontFamily: 'Montserrat'),
                                withinRangeTextStyle: TextStyle(color: black),
                                disabledTextStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Montserrat'),
                                outsideTextStyle: const TextStyle(
                                    color: unselectedGrey,
                                    fontFamily: 'Montserrat'),
                                isTodayHighlighted: false,
                                markerSize: 4,
                                markerDecoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (isSameDay(
                                        _selectedDay, DateTime.now()))
                                        ? white
                                        : truckGreen)),
                          )),
                    );
                  },
                );
              },
            );
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: borderLightColor, width: 1.5)),
              hintText: 'Choose Date',
              hintStyle: TextStyle(
                  color: borderLightColor,
                  fontFamily: 'Montserrat',
                  fontSize: size_8),
              label: Text(widget.labelText,
                  style: TextStyle(
                      color: kLiveasyColor,
                      fontFamily: 'Montserrat',
                      fontSize: size_10,
                      fontWeight: FontWeight.w600),
                  selectionColor: kLiveasyColor),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(
                Icons.calendar_month,
                color: borderLightColor,
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: truckGreen, width: 1.5))),
        ),
      );
  }
}