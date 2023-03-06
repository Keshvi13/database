import 'package:database/add_user.dart';
import 'package:flutter/material.dart';
import 'my_database.dart';
import 'package:http/http.dart' as http;

class user_list_page extends StatefulWidget {
  @override
  State<user_list_page> createState() => _user_list_pageState();
}

class _user_list_pageState extends State<user_list_page> {
  @override
  // void initState() {
  //   super.initState();
  //   MyDatabase().copyPasteAssetFileToRoot().then(
  //         (value) {
  //       // // print("ok");
  //       // My_database().getDataFromUserTable();
  //       // userListFuture = My_database().getDataFromUserTable();
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "User_list_page",
          ),
          actions: [
            InkWell(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 24,
                  )),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return Add_User(null);
                  },
                )).then((value) {
                  if (value == true) {
                    setState(() {});
                  }
                });
              },
              // child: Container(
              //   padding: EdgeInsets.only(right: 10),
              //   child: Icon(Icons.add),
              // ),
            )
          ],
        ),
        body: FutureBuilder<bool>(
          builder: (context, snapshot1) {
            if (snapshot1.hasData) {
              return FutureBuilder<List<Map<String, Object?>>>(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // localList.addAll(snapshot.data!.toString());

                    // if (isgetData) {
                    //   localList.addAll(snapshot.data!);
                    //   searchList.addAll(localList);
                    // }
                    // isgetData = false;

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return Add_User(snapshot.data![index]);
                              },
                            )).then((value) {
                              if(value==true){
                              setState(() {

                              });
                            }
                            });
                          },
                          child: Card(
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                        children: [
                                        Text(
                                          (snapshot.data![index]['UserName'])
                                              .toString(),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          (snapshot.data![index]['City'])
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        Text(
                                          (snapshot.data![index]['State'])
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        
                                      ],
                                    )),
                                    Expanded(child: Container(
                                      child: Padding(
                                          padding:
                                          EdgeInsets.only(
                                              left: 100),
                                          child: InkWell(
                                            child: Icon(
                                                Icons.delete),
                                            onTap: () {
                                              // print(
                                              //     'DELETE::::::');
                                              var id = (snapshot
                                                  .data![index]['UserId']);
                                              showDelete(id);
                                            },

                                          )
                                        // CircleAvatar(
                                        //     radius: 20,
                                        //     backgroundColor: Colors.black,
                                        //     backgroundImage: NetworkImage(
                                        //         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSicrAYKphrXpxkmLILXBvDisQvj3P4QPSgS-cKsQKmUkUKr7cCmrb6_s_L-PFFhJm1u8c&usqp=CAU'))
                                      ),
                                    ),)
                                  ],
                                )),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                future: MyDatabase().getUserListFromUserTable(),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
          future: MyDatabase().copyPasteAssetFileToRoot(),
        ));
  }

  void showDelete(id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
          Text("Alert!!!", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Are You Sure Want To Delete This Record?',
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
                onPressed: () async {
                  http.Response res = await deleteUser(id);
                  // if(isLoading){
                  if (res.statusCode == 200) {
                    setState(() {});
                  }
                  // }
                  // else {
                  //   return CircularProgressIndicator();
                  // }

                  // else {
                  //   // If the server did not return a "200 OK response",
                  //   // then throw an exception.
                  //   throw Exception(CircularProgressIndicator());
                  // }

                  Navigator.of(context).pop();
                },
                child:
                Text('Yes', style: TextStyle(fontWeight: FontWeight.bold))),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:
                Text('No', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        );
      },
    );
  }

  deleteUser(id) {

  }
}
