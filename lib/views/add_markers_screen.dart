import 'package:DODA/blocs/auth/auth_bloc.dart';
import 'package:DODA/providers/api_provider.dart';
import 'package:DODA/widgets/custom_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMarkersScreen extends StatefulWidget {
  final Map drawing;
  final String docId;

  AddMarkersScreen({this.drawing, this.docId});

  @override
  _AddMarkersScreenState createState() => _AddMarkersScreenState();
}

class _AddMarkersScreenState extends State<AddMarkersScreen> {
  List<Widget> stackWidgets = List();

  Future<void> _bottomSheet(ApiProvider apiProvider, String heading) async {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return Container(
            height: 350.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    heading,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StreamBuilder(
                      stream: apiProvider.getMarkers(widget.docId),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Error while fetching data",
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.active) {
                          return ListView(
                            shrinkWrap: true,
                            children: snapshot.data.docs
                                .map((doc) => ListTile(
                                      title: Text(doc.data()["name"],
                                          style: TextStyle(fontSize: 16)),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(doc.data()["details"],
                                              style: TextStyle(fontSize: 16)),
                                          Text("About " +
                                              Jiffy(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          int.parse(doc.id)))
                                                  .fromNow())
                                        ],
                                      ),
                                    ))
                                .toList(),
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(""),
                            onTap: () async {
                              Navigator.pop(context);
                            },
                          );
                        },
                        itemCount: 0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    stackWidgets.add(Container(
      child: CachedNetworkImage(
        imageUrl: widget.drawing["drawing"],
        imageBuilder: (BuildContext context, imageProvider) =>
            Stack(alignment: AlignmentDirectional.center, children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ]),
        progressIndicatorBuilder: (BuildContext context, String url, progress) {
          return Center(
              child: CircularProgressIndicator(
            value: progress.progress,
          ));
        },
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    ));
  }

  dynamic _onDoubleTap(TapPosition position) {
    showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CustomDialog(
                  title: "Add Marker",
                  type: "marker",
                  saveData: (name, details) async {});
            })
        .then((value) => Provider.of<ApiProvider>(context, listen: false)
            .addMarker(value[0], value[1], position, widget.docId,
                context.bloc<AuthBloc>().state.user));
  }

  List<Widget> getMarkers(List<QueryDocumentSnapshot> docs) {
    return docs
        .map((doc) => Positioned(
              left: doc["position"]["dx"],
              top: doc["position"]["dy"],
              child: IconButton(
                iconSize: 32.0,
                icon: Icon(Icons.pin_drop),
                onPressed: () {
                  _bottomSheet(Provider.of<ApiProvider>(context, listen: false),
                      "Marker Details");
                },
                color: Colors.blue,
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder:
            (BuildContext constext, ApiProvider apiProvider, Widget child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Add Markers"),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.list_outlined,
                      size: 32.0,
                    ),
                    onPressed: () {
                      _bottomSheet(apiProvider, "All Markings");
                    },
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                  stream: apiProvider.getMarkers(widget.docId),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error while fetching data"),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.active) {
                      stackWidgets.addAll(getMarkers(snapshot.data.docs));
                      // getMarkers(snapshot.data.docs);
                      return PositionedTapDetector(
                        onDoubleTap: _onDoubleTap,
                        child: Stack(
                          children: stackWidgets,
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),
          );
        },
      ),
    );
  }
}
