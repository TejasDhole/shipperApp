import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/providerClass/providerData.dart';
import 'package:table_calendar/table_calendar.dart';

class LoadingDateWebWidget extends StatefulWidget{
  @override
  LoadingDateWebWidgetState createState() {
    return LoadingDateWebWidgetState();
  }

}
class LoadingDateWebWidgetState extends State<LoadingDateWebWidget>{

  CalendarFormat _calendarFormat = CalendarFormat.month;
  final TextEditingController _textEditingController = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  @override
  Widget build(BuildContext context) {
  ProviderData providerData = Provider.of<ProviderData>(context);
  if(providerData.scheduleLoadingDate != ''){
    _textEditingController.text = providerData.scheduleLoadingDate;
    _selectedDay = DateFormat.yMMMMd('en_US').parse(providerData.scheduleLoadingDate);
  }

    return Expanded(
      child: Container(
        child: TextField(
          controller: _textEditingController,
          style: TextStyle(color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
          textAlign: TextAlign.center,
          showCursor: false,
          mouseCursor: SystemMouseCursors.click,
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          onTap: (){
            setState(() {
              showDialog(context: context,builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      content: Container(
                          width: MediaQuery.of(context).size.width*0.2,
                          height: MediaQuery.of(context).size.height*0.588,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          padding: EdgeInsets.all(10),

                          child: TableCalendar(
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },


                            onDaySelected: (selectedDay, focusedDay) {
                              if (!isSameDay(_selectedDay, selectedDay)) {
                                setState(() {
                                  providerData.updateResetActive(false);
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                  _textEditingController.text = DateFormat.yMMMMd('en_US').format(_selectedDay!).toString();
                                  providerData.updateScheduleLoadingDate(_textEditingController.text);
                                  print(providerData.scheduleLoadingDate);
                                });
                              }
                            },

                            eventLoader: (day){
                              return (isSameDay(DateTime.now(),day))? [DateTime.now()]: [];
                            },



                            calendarFormat: _calendarFormat,
                            focusedDay: _focusedDay,
                            firstDay: DateTime.now(),
                            lastDay: DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day+5),

                            headerStyle:  HeaderStyle(
                              headerPadding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                              leftChevronIcon: Image.asset('assets/images/calendar_previous.png'),

                              rightChevronIcon: Image.asset('assets/images/calendar_next.png'),
                              formatButtonVisible: false,
                              titleTextStyle: TextStyle(color: Colors.black, fontFamily: 'Montserrat', fontSize: 20),
                              titleCentered: true,
                            ),

                            calendarStyle:  CalendarStyle(
                                markersAutoAligned: false,
                                markersAlignment: Alignment.topRight,
                                markerMargin: EdgeInsets.all(10),
                                markersMaxCount: 1,
                                canMarkersOverflow: false,
                                outsideDecoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(2)),
                                ),
                                weekendDecoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(2)),
                                ),
                                disabledDecoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(2)),
                                ),
                                defaultDecoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(2)),
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: truckGreen,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(2)),
                                ),
                                selectedTextStyle: TextStyle(fontFamily: 'Montserrat',color: Colors.white),
                                defaultTextStyle: TextStyle(fontFamily: 'Montserrat'),
                                weekendTextStyle: TextStyle(fontFamily: 'Montserrat'),
                                withinRangeTextStyle: TextStyle(color: Colors.black),
                                disabledTextStyle: TextStyle(color: Colors.grey,fontFamily: 'Montserrat'),
                                outsideTextStyle: TextStyle(color: Colors.grey,fontFamily: 'Montserrat'),
                                isTodayHighlighted: false,
                                markerSize: 4,
                                markerDecoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (isSameDay(_selectedDay, DateTime.now()))?Colors.white:truckGreen
                                )
                            ),


                          )

                      ),
                    );
                  },
                );
              },);
            });
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: borderLightColor,width: 1.5)
              ),
              hintText: 'Choose Date',
              hintStyle: TextStyle(color: borderLightColor,fontFamily: 'Montserrat', fontSize: size_8),
              label: Text('Schedule Loading Date',style: TextStyle(color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_10, fontWeight: FontWeight.w600),selectionColor: kLiveasyColor),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.calendar_month, color: borderLightColor,),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: truckGreen,width: 1.5)
              )
          ),
        ),
      ),
    );
  }

}