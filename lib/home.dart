import 'package:flutter/material.dart';
import 'package:fyp_app/details.dart';
import 'package:fyp_app/model.dart';
import 'package:fyp_app/services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseServices firebaseServices = FirebaseServices();
  List<Model> modelList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Model>>(
        stream: firebaseServices.getDataList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error! ${snapshot.error.toString()}'),
            );
          }
          if (snapshot.hasData) {
            //sortDates(snapshot.data);
            snapshot.data.sort((a, b) => a.date.compareTo(b.date));
            modelList = snapshot.data.reversed.toList();

            return Container(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: modelList.length,
                itemBuilder: (context, index) {
                  // mood = '${moodList.elementAt(index).moodState}';
                  // date = moodList.elementAt(index).date;
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailsPage(modelList[index],index)),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          trailing: InkWell(
                            onTap: () async {
                              await firebaseServices
                                  .deleteData(modelList[index].docId);
                              setState(() {});
                            },
                            child: Icon(Icons.delete),
                          ),
                          title: Text(
                            'Violation ${index + 1}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          isThreeLine: true,
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Violation Type: ${modelList[index].type}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.date_range_outlined),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${modelList[index].date.day}/${modelList[index].date.month}/${modelList[index].date.year}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.watch_later_outlined),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${modelList[index].time}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
