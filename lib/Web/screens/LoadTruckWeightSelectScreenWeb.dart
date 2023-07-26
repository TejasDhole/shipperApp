import 'package:flutter/material.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';

import '../../Widgets/loadDetailsWebWidgets/loadDetailsHeader.dart';

class LoadTruckWeightSelectScreenWeb extends StatefulWidget {
  final minWeight, maxWeight;
  const LoadTruckWeightSelectScreenWeb(
      {super.key, required this.minWeight, required this.maxWeight});

  @override
  State<LoadTruckWeightSelectScreenWeb> createState() =>
      _LoadTruckWeightSelectScreenWebState();
}

class _LoadTruckWeightSelectScreenWebState
    extends State<LoadTruckWeightSelectScreenWeb> {
  List<List<double>> weightSlots = [
    [0, 0]
  ];

  var controller = PageController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.maxWeight > widget.minWeight && widget.minWeight != 0.0) {
      createSlotFromWeightRange();
    }
  }

  //this createSlotFromWeightRange function will create slots between minWeight and maxWeight
  //example --> 7.5 - 25.5 -- > [[7.5 - 10], [11 - 15], [16 - 20], [21 - 25.5]]
  //example --> 7 - 27.5 -- > [[7 - 10], [11 - 15], [16 - 20], [21 - 25.5], [26 - 27.5]]
  //example --> 5 - 26.5 -- > [[5 - 5], [6 - 10], [11 - 15], [16 - 20], [21 - 25.5], [26 - 26.5]]
  //example --> 9.5 - 24.5 -- > [[9.5 - 10], [11 - 15], [16 - 20], [21 - 24.5]]

  void createSlotFromWeightRange() {
    bool slotFirstWeight = false;
    List<double> slot = [widget.minWeight];
    int slotIndex = 0;

    for (double j = (widget.minWeight).ceil();
        j <= (widget.maxWeight).ceil();
        j++) {
      if (j % 5 != 0 || j > widget.maxWeight) {
        if (j == widget.maxWeight) {
          slot.add(j);
          weightSlots.add(slot);
        } else {
          if (slotFirstWeight && j < widget.maxWeight) {
            slot.add(j);
            slotFirstWeight = false;
          } else {
            if (j > widget.maxWeight) {
              if (slot.isEmpty) {
                weightSlots[slotIndex - 1][1] = widget.maxWeight;
              } else {
                slot.add(widget.maxWeight);
                weightSlots.add(slot);
              }
            }
          }
        }
      } else {
        slot.add(j);
        if (slotIndex == 0) {
          weightSlots[0] = slot;
        } else {
          weightSlots.add(slot);
        }
        slot = [];
        ++slotIndex;
        slotFirstWeight = true;
      }
    }

    print(weightSlots);
  }

  getLoadWeight(){
    return weightSlots.map<Widget>((e) {
        return Container(
        padding: EdgeInsets.only(top: 10,bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(key: GlobalObjectKey(e),'${e[0]} - ${e[1]} tons',style: TextStyle(
                fontFamily: 'Montserrat',
                color: truckGreen,
                fontSize: size_9),
            ),
            SizedBox(height: 5,),
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, iterator) {
                  return Container(
                    padding: EdgeInsets.only(top: 5,bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${e[0]+iterator} tons',style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: kLiveasyColor,
                            fontSize: size_9),),
                        Expanded(child: Container()),
                        Image.asset('assets/images/load_weight_boxes.png')
                      ],
                    ),
                  );
                }, separatorBuilder: (context, index) {
              return Divider(thickness: 1, height: 0,);
            }, itemCount: ((e[1] - e[0])+1).toInt())
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadDetailsHeader(
              title: 'Choose a Truck Type',
              subTitle: 'What type of truck you require?'),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: lineDividerColor,
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if(index < weightSlots.length){
                              WidgetsBinding.instance.addPostFrameCallback((_) => Scrollable.ensureVisible(GlobalObjectKey(weightSlots[index]).currentContext!,curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 250)));
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 10, right: 10),
                            child: Center(
                                child: Text(
                                  (index < weightSlots.length)?
                              '${weightSlots[index][0]} - ${weightSlots[index][1]} tons'
                              :'Other',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: truckGreen,
                                  fontSize: size_9),
                            )),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          thickness: 1,
                          height: 0,
                        );
                      },
                      itemCount: weightSlots.length+1,
                    ),
                  ),
                ),
                Expanded(flex:3,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.6,
                        child: SingleChildScrollView(
                          child: Column(
                            children: getLoadWeight(),
                          ),
                        )
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
