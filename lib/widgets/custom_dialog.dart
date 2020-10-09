import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, type;
  Function saveData;

  String name = "";
  String details = "";

  CustomDialog({
    @required this.title,
    @required this.type,
    @required this.saveData,
  });

  dialogContext(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 8.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(8.0),
        //margin: EdgeInsets.only(top: Consts.avatarRadius),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // To make the card compact
            children: <Widget>[
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey)),
                  hintText: "$type Name",
                ),
                onChanged: (val) {
                  name = val;
                },
              ),
              SizedBox(
                height: 5.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey)),
                  hintText: "$type Details",
                ),
                onChanged: (val) {
                  details = val;
                },
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                  shape: StadiumBorder(),
                  child: Text("Save",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  onPressed: () {
                    // Navigator.of(context).pop(); // To close the dialog
                    Navigator.pop(context, [name, details]);
                    // saveData(name, details);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
