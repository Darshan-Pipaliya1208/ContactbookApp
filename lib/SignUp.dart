import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:practicalexam/DatabaseHelper.dart';
import 'package:practicalexam/SignIn.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _emailid = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();

  String? error_name;
  String? error_phone;
  String? error_password;
  String? error_emailid;
  String? error_confirmpassword;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.05;
    final fieldSpacing = size.height * 0.02;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: size.width * 0.2,
        leading: GFButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignIn()));
          },
          text: "Back",
          color: Colors.transparent,
          icon: Icon(Icons.arrow_back),
          shape: GFButtonShape.pills,
        ),
      ),
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.deepPurple[700],
                    fontSize: size.width * 0.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: fieldSpacing * 2),

                // Name Field
                myTextField(
                  controller: _name,
                  label: "Enter your name",
                  icon: Icons.account_circle,
                  errorText: error_name,
                ),
                SizedBox(height: fieldSpacing),

                myTextField(
                  controller: _phone,
                  label: "Mobile no",
                  icon: Icons.phone,
                  keyboardType: TextInputType.number,
                  errorText: error_phone,
                ),
                SizedBox(height: fieldSpacing),

                myTextField(
                  controller: _emailid,
                  label: "Enter your Email id",
                  icon: Icons.mail,
                  errorText: error_emailid,
                ),
                SizedBox(height: fieldSpacing),

                myTextField(
                  controller: _password,
                  label: "Password",
                  icon: Icons.password,
                  obscureText: true,
                  errorText: error_password,
                ),
                SizedBox(height: fieldSpacing),

                myTextField(
                  controller: _confirmpassword,
                  label: "Confirm Password",
                  icon: Icons.confirmation_number_outlined,
                  obscureText: true,
                  errorText: error_confirmpassword,
                ),

                SizedBox(height: fieldSpacing * 2.5),

                ScaleTransition(
                  scale: fadeAnimation,
                  child: GFButton(
                    size: size.height * 0.08,
                    color: Colors.deepPurple,
                    onPressed: saveData,
                    text: "Sign Up",
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.05,
                    ),
                    highlightElevation: 10,
                    shape: GFButtonShape.pills,
                    fullWidthButton: true,
                    highlightColor: Colors.blueGrey,
                  ),
                ),

                SizedBox(height: fieldSpacing * 3),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn()));
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.deepOrange, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        prefixIcon: Icon(icon, color: Colors.teal),
        labelText: label,
        errorText: errorText,
      ),
    );
  }

  Future<void> saveData() async {
    String name = _name.text;
    String phone = _phone.text;
    String email = _emailid.text;
    String password = _password.text;
    String confirmpassword = _confirmpassword.text;

    if (name.isEmpty) {
      error_name = 'Please enter your name';
      setState(() {});
      return;
    } else {
      error_name = '';
    }
    if (phone.isEmpty || phone.length != 10) {
      error_phone = 'Please enter a valid mobile number';
      setState(() {});
      return;
    } else {
      error_phone = null;
    }
    if (email.isEmpty || !isValidEmail(email)) {
      error_emailid = 'Please enter a valid email ID';
      setState(() {});
      return;
    } else {
      error_emailid = null;
    }
    if (password.isEmpty) {
      error_password = 'Please enter password';
      setState(() {});
      return;
    } else {
      error_password = null;
    }
    if (confirmpassword.isEmpty || confirmpassword != password) {
      error_confirmpassword = 'Passwords do not match';
      setState(() {});
      return;
    } else {
      error_confirmpassword = null;
    }

    DatabaseHelper db = DatabaseHelper();
    var isExists = await db.ifExists(email, password);
    if (isExists) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User already exists')));
      return;
    }
    await db.insert(name, phone, email, password);

    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return SignIn();
      },
    ));
  }

  bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }
}
