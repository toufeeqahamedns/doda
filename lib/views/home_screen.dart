import 'package:DODA/blocs/auth/auth_bloc.dart';
import 'package:DODA/providers/api_provider.dart';
import 'package:DODA/views/drawings_screeen.dart';
import 'package:DODA/views/profile_screen.dart';
import 'package:DODA/widgets/custom_dialog.dart';
import 'package:DODA/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool loading = false;
  String name = "";
  String details = "";

  final List<Widget> _children = [DrawingsScreen(), ProfileScreen()];

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  setLoader(val) {
    setState(() {
      loading = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(children: [
        _children[_currentIndex],
        showLoader(context: context, isLoadingVar: loading)
      ]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CustomDialog(
                    title: "Details",
                    type: "Drawing",
                    saveData: (name, details) async {
                      setState(() {
                        name = name;
                        details = details;
                      });
                      Navigator.pop(context);
                    });
              }).then((data) async {
            setLoader(true);
            try {
              final pickedFile =
                  await ImagePicker().getImage(source: ImageSource.camera);
              if (pickedFile != null) {
                await Provider.of<ApiProvider>(context, listen: false)
                    .addDrawing(data[0], data[1], pickedFile,
                        context.bloc<AuthBloc>().state.user);
              }
            } catch (e) {
              setLoader(false);
            }
            setLoader(false);
          });
          // Provider.of<ApiProvider>(context, listen: false).addDrawing(context.bloc<AuthBloc>().state.user);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    ));
  }
}
