import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:practicalexam/DatabaseHelper.dart';
import 'package:practicalexam/First_logo.dart';
import 'package:practicalexam/SignUp.dart';
import 'package:practicalexam/afterLoginPage.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController Username = TextEditingController();
  TextEditingController Password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/logo-no-background 1.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.only(start: 20, top: 20),
                child: Text(
                  "Sign in",
                  style: TextStyle(
                      color: Colors.deepPurple[700],
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: Username,
                      keyboardType: TextInputType.text,
                      // obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.deepOrange, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2)),
                        prefixIcon: const Icon(
                          Icons.account_circle,
                          color: Colors.teal,
                        ),
                        labelText: 'Email or User Name',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: Password,

                      keyboardType: TextInputType.text,
                      // obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.deepOrange, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2)),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.teal,
                        ),
                        labelText: 'Password',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width *
                      0.6, // Adjusted based on screen width
                  top: 30,
                  bottom: 30,
                ),
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: GFButton(
                  size: 50,
                  color: Colors.deepPurple,
                  onPressed: () {
                    DatabaseHelper()
                        .LoginUser(Username.text, Password.text)
                        .then(
                      (value) {
                        if (value.length > 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('SuccessFully Login')));
                          print(
                              "----------------------------------------------------------------------------");
                          FirstLogo.prefs!.setBool("loginstatus", true);
                          FirstLogo.prefs!.setInt("ID", value[0]['id']);
                          FirstLogo.prefs!.setString("NAME", value[0]['name']);
                          FirstLogo.prefs!
                              .setString("EMAIL", value[0]['email']);

                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => afterLoginPage(),));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('User Not exists')));
                        }
                      },
                    );
                  },
                  text: "Sign in",
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  highlightElevation: 10,
                  shape: GFButtonShape.pills,
                  fullWidthButton: true,
                  highlightColor: Colors.blueGrey,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 30),
                child: Center(
                    child: Text(
                  style: TextStyle(
                      color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  "Or sign in With",
                )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Brand(
                      Brands.google,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {}, child: Brand(Brands.facebook)),
                  ElevatedButton(
                      onPressed: () {}, child: Brand(Brands.twitterx)),
                  ElevatedButton(
                      onPressed: () {}, child: Brand(Brands.linkedin_circled)),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 60,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w500),
                        "Don't have account ? ",
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return SignUp();
                            },
                          ));
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
