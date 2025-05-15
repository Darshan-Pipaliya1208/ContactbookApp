import 'package:flutter/material.dart';
import 'package:practicalexam/First_logo.dart';
import 'package:practicalexam/SignIn.dart';

import 'DatabaseHelper.dart';
import '_ContactBottomSheetState.dart';

class afterLoginPage extends StatefulWidget {
  static List statuslist = [];

  const afterLoginPage({super.key});

  @override
  State<afterLoginPage> createState() => _afterLoginPageState();
}

class _afterLoginPageState extends State<afterLoginPage> {

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  List<Map> list = [];
  List<Map> Searchlist = [];

  void _showAddContactBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Allows full screen height for the bottom sheet
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ContactBottomSheet(),
    );
  }

  bool issearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[100],
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _showAddContactBottomSheet(context);
          },
        ),
        appBar: issearch
            ? AppBar(
                title: TextField(
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: Colors.deepOrange, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              Searchlist = list;
                              issearch = false;
                            });
                          },
                          icon: Icon(Icons.close))),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      Searchlist = [];
                      for (int i = 0; i < list.length; i++) {
                        String name = list[i]['Name'];
                        if (name.toLowerCase().contains(value.toLowerCase())) {
                          Searchlist.add(list[i]);
                        }
                      }
                    } else {
                      Searchlist = list;
                    }
                    setState(() {});
                  },
                ),
              )
            : AppBar(backgroundColor: Colors.blueGrey[200],
                title: Text("Contact book",style: TextStyle(fontWeight: FontWeight.bold),),
                actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          issearch = true;
                        });
                      },
                      icon: Icon(size: 35,
                        Icons.search,
                        weight: 50,
                      ))
                ],
              ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/login_first_img.jpg"),
                ),
                accountName: Text(
                  FirstLogo.prefs!.getString("NAME") ?? "Default",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  FirstLogo.prefs!.getString("EMAIL") ?? "default@example.com",
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: Icon(Icons.home, color: Colors.blue),
                      title: Text("Home"),
                      onTap: () {
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.blue),
                      title: Text("Settings"),
                      onTap: () {
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outline, color: Colors.blue),
                      title: Text("About"),
                      onTap: () {

                      },
                    ),
                  ],
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  "LOG OUT",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  FirstLogo.prefs!.setBool("loginstatus", false).then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  });
                },
              ),
            ],
          ),
        ),

      body: list.isNotEmpty
            ? ListView.builder(
                itemCount: issearch ? Searchlist.length : list.length,
                itemBuilder: (context, index) {
                  Map contact = issearch ? Searchlist[index] : list[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      trailing: PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: Text("Update"),
                              onTap: () {
                                showUpdateDialog(contact);
                              },
                            ),
                            PopupMenuItem(
                              child: Text("Delete"),
                              onTap: () {
                                DELETECONTDATA(contact['ContactId']);
                              },
                            )
                          ];
                        },
                      ),
                      contentPadding: EdgeInsets.all(10),
                      title: Text(
                        contact['Name'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Phone: ${contact['Contact']}",
                              style: TextStyle(fontSize: 18)),
                          Text("Email: ${contact['Email']}",
                              style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(child: Text("Data Not Found")));
  }

  Future<void> fetchData() async {
    int uid = FirstLogo.prefs!.getInt("ID") ?? 0;
    DatabaseHelper().ShowContact(uid).then(
      (value) {
        print('===================================${value}');
        setState(() {
          list = value;
          Searchlist = value;
        });
      },
    );
  }

  showUpdateDialog(Map contact) {
    TextEditingController nameController =
        TextEditingController(text: contact['Name']);
    TextEditingController phoneController =
        TextEditingController(text: contact['Contact']);
    TextEditingController emailController =
        TextEditingController(text: contact['Email']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(" Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                String phone = phoneController.text;
                String email = emailController.text;
                DatabaseHelper()
                    .UpdateContactData(contact['ContactId'], name, phone, email)
                    .then(
                  (value) {
                    Navigator.pop(context);
                    fetchData();
                  },
                );
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Future<void> DELETECONTDATA(map) async {
      DatabaseHelper().deleteContactData(map).then(
      (value) {
        fetchData();
      },
    );
    setState(() {});
  }
}
