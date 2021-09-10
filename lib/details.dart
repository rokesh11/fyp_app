import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/model.dart';
import 'package:video_player/video_player.dart';

class DetailsPage extends StatefulWidget {
  final Model modelData;
  final int indexNo;

  DetailsPage(this.modelData, this.indexNo);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final FirebaseStorage storage = FirebaseStorage(
      app: Firestore.instance.app,
      storageBucket: 'gs://fypapp-b7d25.appspot.com');

  Future<String> _getImage(BuildContext context, String image) async {
    final String ref = await storage.refFromURL(image).getDownloadURL();
    print('Ref link ===' + ref.toString());
    return ref;
  }

  VideoPlayerController _controller;
  //Future<void> _initializeVideoPlayerFuture;

  Future<VideoPlayerController> initVideoState(String url) async{
    _controller = VideoPlayerController.network(
      url,
      //'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    // Initialize the controller and store the Future for later use.
    //_initializeVideoPlayerFuture = _controller.initialize();
    _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    return _controller;
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    if(widget.modelData.type=='crash') {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FYP APP'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: FutureBuilder<String>(
              future: _getImage(context, widget.modelData.photopath),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error ' + snapshot.data);
                }
                if (snapshot.hasData) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Violation ${widget.indexNo + 1}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Violation Type: ${widget.modelData.type}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.date_range_outlined),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${widget.modelData.date.day}/${widget.modelData.date.month}/${widget.modelData.date.year}',
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
                                    '${widget.modelData.time}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'GPS Coordinates',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Lat:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${widget.modelData.lat}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Long:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${widget.modelData.long}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            'Snapshot Captured:',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          widget.modelData.type != 'crash'
                              ? Image.network(
                                  snapshot.data.toString(),
                                  fit: BoxFit.cover,
                                )
                              : FutureBuilder<VideoPlayerController>(
                                  future: initVideoState(snapshot.data),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return AspectRatio(
                                        aspectRatio:
                                            snapshot.data.value.aspectRatio,
                                        // Use the VideoPlayer widget to display the video.
                                        child: VideoPlayer(snapshot.data),
                                      );
                                    } else {
                                      // If the VideoPlayerController is still initializing, show a
                                      // loading spinner.
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                )
                          // Image.network(
                          //   'https://storage.googleapis.com/fypapp-b7d25.appspot.com/withoutHelmet/BikesHelmets133_out.jpg',
                          //   //modelData.photopath,
                          // ),
                        ],
                      ),
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}
