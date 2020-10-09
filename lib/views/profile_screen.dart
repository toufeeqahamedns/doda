import 'package:DODA/blocs/auth/auth_bloc.dart';
import 'package:DODA/models/user.dart';
import 'package:DODA/providers/api_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = context.bloc<AuthBloc>().state.user;
    return Consumer(
        builder: (BuildContext context, ApiProvider apiProvider, Widget child) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: user.photo,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    user.name,
                    style: TextStyle(fontSize: 24.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Drawings",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("0")
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Drawings",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(snapshot.data.docs.length.toString())
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }
                            return Center(child: CircularProgressIndicator());
                          }),
                      StreamBuilder(
                          stream: apiProvider.getMarkersForUser(user),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text("Error while fetching data"),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.data.size == 0) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Markers",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("0")
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Markers",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(snapshot.data.docs.length.toString())
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }
                            return Center(child: CircularProgressIndicator());
                          })
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
