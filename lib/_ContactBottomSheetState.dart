import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:practicalexam/DatabaseHelper.dart';
import 'package:practicalexam/First_logo.dart';
import 'package:practicalexam/afterLoginPage.dart';

class ContactBottomSheet extends StatefulWidget {
  @override
  _ContactBottomSheetState createState() => _ContactBottomSheetState();
}

class _ContactBottomSheetState extends State<ContactBottomSheet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _saveContact() {
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Name and Phone are required!")),
      );
      return;
    }

    int uid = FirstLogo.prefs!.getInt("ID") ?? 0;

    DatabaseHelper().InsertContact(uid, name, phone, email).then(
      (value) {
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return afterLoginPage();
          },
        ));
      },
    );
    // You can now process this data (store it in DB, API call, etc.)
    print("Saved Contact: Name: $name, Phone: $phone, Email: $email");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 30,
          top: 10),
      child: Wrap(
        children: [
          SizedBox(height: 60),
          Text("Add Contact",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 70),
          TextField(
            controller: nameController,
            keyboardType: TextInputType.text,
            // obscureText: true,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.deepOrange, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue, width: 2)),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.teal,
              ),
              labelText: 'Enter your name',
            ),
          ),
          SizedBox(height: 70),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            // obscureText: true,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.deepOrange, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue, width: 2)),
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.green,
              ),
              labelText: 'Mobile no.',
            ),
          ),
          SizedBox(height: 70),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.text,
            // obscureText: true,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.deepOrange, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue, width: 2)),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.teal,
              ),
              labelText: 'Enter your Email',
            ),
          ),
          SizedBox(height: 70),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: _saveContact,
              child: Text(
                "Save",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
