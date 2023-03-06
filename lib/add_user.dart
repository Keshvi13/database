import 'package:database/model/city_model.dart';
import 'package:database/my_database.dart';
import 'package:database/user_list_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Add_User extends StatefulWidget {
  Add_User(this.map);
  Map<String, Object?>? map;

  @override
  State<Add_User> createState() => _Add_UserState();
}

class _Add_UserState extends State<Add_User> {
  var formkey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var cityControiller = TextEditingController();
  var stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.map == null ? '' : widget.map!['UserName'].toString();
    //cityControiller.text = widget.map == null ? '' : widget.map!['City'].toString();
    stateController.text = widget.map == null ? '' : widget.map!['State'].toString();
  }

  CityModel? _ddSelectedValue;
  bool isCityListGet = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Form(
        key: formkey,
        child: Column(
          children: [
            FutureBuilder<List<CityModel>>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (isCityListGet) {
                    _ddSelectedValue = snapshot.data![0];
                    isCityListGet = false;
                  }

                  return DropdownButton(
                    value: _ddSelectedValue,
                    items: snapshot.data!.map((e) {
                      return DropdownMenuItem(
                        value: e,
                          child: Text(e.City.toString()));
                    }).toList(),
                    onChanged: (value) {
                      setState((){ _ddSelectedValue=value;});

                    },
                  );
                  // value: _ddSelectedValue,
                  // items: snapshot.data!.map((CityModel e) {
                  //   return DropdownMenuItem(
                  //     value: e,
                  //     child: Text(
                  //       e.City.toString(),
                  //     ),
                  //   );
                  // }).toList(),
                  // onChanged: (value) {
                  //   setState(() {});
                  //   _ddSelectedValue=value;
                  // },

                } else {
                  return Container();
                }
              },
              future: isCityListGet ? MyDatabase().getCityList() : null,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Enter UserName'),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Enter Valid UserName";
                }
              },
              controller: nameController,
            ),
            // TextFormField(
            //   decoration: InputDecoration(hintText: 'Enter City'),
            //   validator: (value) {
            //     if (value != null && value.isEmpty) {
            //       return "Enter Valid City";
            //     }
            //   },
            //   controller: cityControiller,
            // ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Enter State'),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Enter Valid State";
                }
              },
              controller: stateController,
            ),
            TextButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    if(widget.map == null){
                      insertUserDB()
                        .then((value)=> Navigator.of(context).pop(true));
                      print('abc');
                    }
                    else{
                      updateUserDB(widget.map!['UserId']).then((value) => Navigator.of(context).pop(true));
                    }

                  }
                },
                child: Text('Submit'))
          ],
        ),
      ),
    ));
  }
  Future<int> insertUserDB() async {
    Map<String,dynamic> map={};
    map['UserName'] = nameController.text;
    map['State'] = stateController.text;
    map['UserId'] = _ddSelectedValue!.UserId;
    map['City']=cityControiller.text;
    int userId = await MyDatabase().insertUserDetails(map);
    return userId;
  }

  Future<int> updateUserDB(id) async {
    Map<String,dynamic> map={};
    map['UserName'] = nameController.text;
    map['State'] = stateController.text;
    map['UserId'] = _ddSelectedValue!.UserId;

    int userId = await MyDatabase().updateUserDetails(map, id);
    return userId;
  }
}
