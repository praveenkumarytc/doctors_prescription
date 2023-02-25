import 'package:doctor_prescription/components/doctorPatientCard.dart';
import 'package:doctor_prescription/constants.dart';
import 'package:doctor_prescription/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formKey = GlobalKey<FormState>();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  String status = USER_TYPE_DOCTOR;
  String? email;
  String? password;
  bool _loading = false;
  bool _hasOpenedPage = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode _userEmailFocus = FocusNode();
  final FocusNode _userPasswordFocus = FocusNode();

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password).then((uid) => {
              Fluttertoast.showToast(msg: "Login Successful"),
              if (status == USER_TYPE_PATIENT)
                {
                  Navigator.of(context).pushReplacementNamed(PATIENT_DASHBOARD)
                }
              else
                {
                  Navigator.of(context).pushReplacementNamed(DOCTOR_DASHBOARD)
                }
            });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  pageOpened() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _hasOpenedPage = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    pageOpened();
  }

  @override
  Widget build(BuildContext context) {
    // final AuthBloc authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                color: _hasOpenedPage ? Colors.green : Colors.green.withOpacity(0.0),
                width: _hasOpenedPage ? MediaQuery.of(context).size.width : 200.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(15.0, 50.0, 0.0, 0.0),
                      child: Hero(
                        tag: 'prescription',
                        child: Image.asset(
                          'assets/icons/note.png',
                          height: 128.0,
                          width: 128.0,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 0.0, 0.0),
                      child: Text(
                        'Sign In.',
                        style: GoogleFonts.poppins(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        status = USER_TYPE_DOCTOR;
                        print(status);
                      });
                    },
                    child: DoctorPatientCard(
                      imagePath: 'assets/icons/doctor.png',
                      title: 'Doctor',
                      elevation: status == USER_TYPE_DOCTOR ? 5.0 : 2.0,
                      backgroundColor: status == USER_TYPE_DOCTOR ? Colors.green : Colors.white,
                      textColor: status == USER_TYPE_DOCTOR ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        status = USER_TYPE_PATIENT;
                        print(status);
                      });
                    },
                    child: DoctorPatientCard(
                      imagePath: 'assets/icons/patient.png',
                      title: 'Patient',
                      elevation: status == USER_TYPE_PATIENT ? 5.0 : 2.0,
                      backgroundColor: status == USER_TYPE_PATIENT ? Colors.green : Colors.white,
                      textColor: status == USER_TYPE_PATIENT ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        onChanged: (String val) {
                          setState(() {
                            email = val;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        focusNode: _userEmailFocus,
                        onFieldSubmitted: (term) {
                          _userEmailFocus.unfocus();
                          FocusScope.of(context).requestFocus(_userPasswordFocus);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        // ignore: missing_return
                        validator: (String? value) {
                          var pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                          RegExp regex = RegExp(pattern);
                          print(value);
                          if (value!.isEmpty) {
                            print('Please enter password');
                          } else {
                            if (!regex.hasMatch(value))
                              print('Enter valid password');
                            else
                              return null;
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        obscureText: true,
                        onChanged: (val) => password = val,
                        textInputAction: TextInputAction.done,
                        focusNode: _userPasswordFocus,
                        onFieldSubmitted: (term) {
                          _userPasswordFocus.unfocus();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35.0),
              _loading
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      child: Container(
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                            height: 40.0,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                signIn(email!, password!);
                              },
                              child: const Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                            height: 40.0,
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(REGISTER);
                              },
                              // color: Colors.transparent,
                              child: const Text(
                                'No account yet? Create one',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Login Page Validation

  String validateEmail(String value) {
    var pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Emaill';
    else
      return 'hurreh';
  }
}
