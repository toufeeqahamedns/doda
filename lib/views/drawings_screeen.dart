import 'package:DODA/views/add_markers_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DODA/blocs/auth/auth_bloc.dart';
import 'package:DODA/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DrawingsScreen extends StatelessWidget {
  // Widget showSheet(snapshot)  {
  //   return showModalBottomSheet(context: context, builder: (_) {
  //     if (snapshot.hasError) {
  //                   return Center(
  //                     child: Text("Error while fetching data"),
  //                   );
  //                 } else if (snapshot.connectionState ==
  //                     ConnectionState.active) {
  //                   if (snapshot.data.size == 0) {
  //                     return Center(
  //                       child: Text("No Drawings found. Add some!!!"),
  //                     );
  //                   } else {
  //                     return _buildCarousel(context, snapshot.data.docs);
  //                   }
  //                 }
  //                 return Center(child: CircularProgressIndicator());
  //               }
  //   })
  // }

  Widget _buildCarousel(
      BuildContext context, List<QueryDocumentSnapshot> docSnapshots) {
    return Expanded(
        child: CarouselSlider(
      options: CarouselOptions(
        height: double.infinity,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(milliseconds: 1000),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      items: docSnapshots.map((QueryDocumentSnapshot documentSnapshot) {
        return GestureDetector(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: CachedNetworkImage(
              imageUrl: documentSnapshot.data()["drawing"],
              imageBuilder: (BuildContext context, imageProvider) => Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0)),
                        child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(100, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    documentSnapshot.data()["name"],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.pin_drop_outlined,
                                    color: Colors.white,
                                    size: 36.0,
                                  ),
                                  Text(
                                      documentSnapshot
                                          .data()["markers"]
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ))
                                ],
                              ),
                            )),
                      ))
                ],
              ),
              progressIndicatorBuilder:
                  (BuildContext context, String url, progress) {
                return Center(
                    child: CircularProgressIndicator(
                  value: progress.progress,
                ));
              },
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddMarkersScreen(
                        drawing: documentSnapshot.data(),
                        docId: documentSnapshot.id)));
          },
        );
      }).toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.bloc<AuthBloc>().state.user;
    return Consumer(builder:
        (BuildContext constext, ApiProvider apiProvider, Widget child) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Drawings",
                  style: TextStyle(fontSize: 32.0),
                ),
                Image.asset(
                  "assets/app_icon.png",
                  height: 32.0,
                  width: 32.0,
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            StreamBuilder(
                stream: apiProvider.getDrawings(user),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error while fetching data"),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.data.size == 0) {
                      return Expanded(
                        child: Center(
                          child: Text("No Drawings found. Add some!!!"),
                        ),
                      );
                    } else {
                      return _buildCarousel(context, snapshot.data.docs);
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                }),
            SizedBox(
              height: 16.0,
            )
          ],
        ),
      );
    });
  }
}
