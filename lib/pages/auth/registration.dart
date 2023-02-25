import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_prescription/components/detail_row.dart';
import 'package:doctor_prescription/components/doctorPatientCard.dart';
import 'package:doctor_prescription/constants.dart';
import 'package:doctor_prescription/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;
  bool _hasOpenedPage = false;
  int _currentStep = 0;
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // REGISTRATION FORM
  final _registrationFormKey = GlobalKey<FormState>();
  String? _userEmail, _userPassword, _userConfirmPassword, _userType;
  bool _passwordVisible = false, _confirmPasswordVisible = false;
  bool _hasNotSelectedUserType = false;

  final FocusNode _userEmailFocus = FocusNode();
  final FocusNode _userPasswordFocus = FocusNode();
  final FocusNode _userConfirmPasswordFocus = FocusNode();

  // DETAILS FORM
  final _detailsFormKey = GlobalKey<FormState>();
  String? _userName, _userGender, _userDOBText;
  DateTime _userDOB = DateTime.now();
  double? _userHeight, _userWeight;
  final TextEditingController _userDOBController = TextEditingController();

  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _userDOBFocus = FocusNode();
  final FocusNode _userGenderFocus = FocusNode();
  final FocusNode _userHeightFocus = FocusNode();
  final FocusNode _userWeightFocus = FocusNode();

  pageOpened() {
    Future.delayed(const Duration(milliseconds: 20), () {
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

  _onStepContinue() async {
    if (_currentStep < registrationSteps().length) {
      switch (_currentStep) {
        case 0:
          {
            if (_registrationFormKey.currentState!.validate() && _userType != null) {
              setState(() {
                _currentStep = _currentStep + 1;
              });
            }
            if (_userType == null) {
              _hasNotSelectedUserType = true;
            }
            break;
          }
        case 1:
          {
            print(_detailsFormKey.currentState!.validate());
            if (_detailsFormKey.currentState!.validate()) {
              setState(() {
                _currentStep = _currentStep + 1;
              });
            }
            break;
          }
        case 2:
          {
            setState(() {
              _isLoading = true;
            });
            signUp(_userType, _userEmail, _userConfirmPassword, _userName, _userGender, _userDOBText, _userHeight, _userWeight);
          }
      }
    } else {
      print(_currentStep);
      print('done');
      //DONE NAVIGATING THE LOGIC
    }
  }

  _onStepCancel() {
    switch (_currentStep) {
      case 0:
        {
          setState(() {
            _userEmail = null;
            _userPassword = null;
            _userConfirmPassword = null;
            _hasNotSelectedUserType = false;
            _userType = null;
          });
          _resetRegistrationForm();
          break;
        }
      case 1:
        {
          setState(() {
            _userName = null;
            _detailsFormKey.currentState!.reset();
            _userDOB = DateTime.now();
            _userGender = null;
            _userHeight = null;
            _userWeight = null;
            _userDOBController.value = const TextEditingValue(text: '');
            _currentStep = _currentStep - 1;
          });
          break;
        }
      case 2:
        {
          setState(() {
            _currentStep = _currentStep - 1;
          });
          break;
        }
    }
  }

  _resetRegistrationForm() {
    if (kDebugMode) {
      print("Reset");
    }
    setState(() {
      _registrationFormKey.currentState!.reset();
      _registrationFormKey.currentState!.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            color: _hasOpenedPage ? Colors.blueAccent : Colors.blueAccent.withOpacity(0.0),
            width: _hasOpenedPage ? MediaQuery.of(context).size.width : 200.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                  child: Text(
                    'Register.',
                    style: GoogleFonts.poppins(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Stepper(
                    steps: registrationSteps(),
                    type: StepperType.horizontal,
                    currentStep: _currentStep,
                    onStepContinue: _onStepContinue,
                    onStepCancel: _onStepCancel,
                    controlsBuilder: (context, details) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _onStepContinue,
                                // color: Colors.blueAccent,
                                // textColor: Colors.white,
                                child: Text(
                                  _currentStep == 2 ? 'CONFIRM' : 'NEXT',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: const TextButton(
                                onPressed: null,
                                // textColor: Colors.black87,
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Step> registrationSteps() {
    List<Step> steps = [
      Step(
        title: const Text('Account'),
        isActive: _currentStep >= 0,
        content: Form(
          key: _registrationFormKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _userType = USER_TYPE_DOCTOR;
                      });
                    },
                    child: DoctorPatientCard(
                      imagePath: 'assets/icons/doctor.png',
                      title: 'Doctor',
                      elevation: _userType == USER_TYPE_DOCTOR ? 5.0 : 2.0,
                      backgroundColor: _userType == USER_TYPE_DOCTOR ? Colors.blueAccent : Colors.white,
                      textColor: _userType == USER_TYPE_DOCTOR ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _userType = USER_TYPE_PATIENT;
                      });
                    },
                    child: DoctorPatientCard(
                      imagePath: 'assets/icons/patient.png',
                      title: 'Patient',
                      elevation: _userType == USER_TYPE_PATIENT ? 5.0 : 2.0,
                      backgroundColor: _userType == USER_TYPE_PATIENT ? Colors.blueAccent : Colors.white,
                      textColor: _userType == USER_TYPE_PATIENT ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              _hasNotSelectedUserType
                  ? Text(
                      'Please select your account type',
                      style: TextStyle(
                        color: Theme.of(context).errorColor,
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 5.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                initialValue: _userEmail,
                focusNode: _userEmailFocus,
                onChanged: (val) {
                  setState(() {
                    _userEmail = val;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email address.';
                  } else if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(_userEmail!)) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  _userEmailFocus.unfocus();
                  FocusScope.of(context).requestFocus(_userPasswordFocus);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                initialValue: _userPassword,
                focusNode: _userPasswordFocus,
                obscureText: !_passwordVisible,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onChanged: (val) {
                  setState(() {
                    _userPassword = val;
                  });
                },
                validator: (value) {
                  if (value!.length < 8) {
                    return 'Your password must be at least 8 characters long.';
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  _userPasswordFocus.unfocus();
                  FocusScope.of(context).requestFocus(_userConfirmPasswordFocus);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                ),
                initialValue: _userConfirmPassword,
                focusNode: _userConfirmPasswordFocus,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: !_confirmPasswordVisible,
                onChanged: (val) {
                  setState(() {
                    _userConfirmPassword = val;
                  });
                },
                validator: (value) {
                  if (value != _userPassword) {
                    return 'Your passwords don\'t match';
                  } else if (value!.length < 8) {
                    return 'Your password must be at least 8 characters long.';
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  _userConfirmPasswordFocus.unfocus();
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Details'),
        isActive: _currentStep >= 1,
        content: Form(
          key: _detailsFormKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                initialValue: _userName,
                focusNode: _userNameFocus,
                onChanged: (val) {
                  setState(() {
                    _userName = val;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name.';
                  } else if (value.length < 3) {
                    return 'Please enter your full name.';
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  _userNameFocus.unfocus();
                  FocusScope.of(context).requestFocus(_userGenderFocus);
                },
              ),
              DropdownButtonFormField(
                items: const [
                  DropdownMenuItem(
                    child: Text('Male'),
                    value: 'Male',
                  ),
                  DropdownMenuItem(
                    child: Text('Female'),
                    value: 'Female',
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _userGender = value;
                  });
                  _userGenderFocus.unfocus();
                },
                isExpanded: true,
                focusNode: _userGenderFocus,
                value: _userGender,
                validator: (value) {
                  print(value);
                  if (_userGender == null) {
                    return 'Please select a gender';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                controller: _userDOBController,
                focusNode: _userDOBFocus,
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  await _showDateOfBirthPicker(context);
                  _userDOBFocus.unfocus();
                  FocusScope.of(context).requestFocus(_userHeightFocus);
                },
                enableInteractiveSelection: false,
                validator: (value) {
                  if (_userDOB.compareTo(DateTime.now()) > 0) {
                    return 'Date of Birth cannot be in the future.';
                  } else if (_userDOB.compareTo(DateTime.now()) == 0) {
                    return 'Please enter a valid date of birth';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Height',
                  labelStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  suffix: Container(
                    color: Colors.blueAccent,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                      child: Text(
                        'cm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                initialValue: _userHeight.toString() == "null" ? "" : _userHeight.toString(),
                focusNode: _userHeightFocus,
                onChanged: (val) {
                  setState(() {
                    _userHeight = double.parse(val);
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your height.';
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  _userHeightFocus.unfocus();
                  FocusScope.of(context).requestFocus(_userWeightFocus);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Weight',
                  labelStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  suffix: Container(
                    color: Colors.blueAccent,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                      child: Text(
                        'Kg',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                initialValue: _userWeight.toString() == "null" ? "" : _userWeight.toString(),
                focusNode: _userWeightFocus,
                onChanged: (val) {
                  setState(() {
                    _userWeight = double.parse(val);
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your weight.';
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  _userWeightFocus.unfocus();
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Finish'),
        isActive: _currentStep >= 2,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Please Confirm Your Details',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: DoctorPatientCard(
                    imagePath: _userType == USER_TYPE_DOCTOR ? 'assets/icons/doctor.png' : 'assets/icons/patient.png',
                    title: _userType == USER_TYPE_DOCTOR ? 'Doctor' : 'Patient',
                    elevation: 2.0,
                    backgroundColor: Colors.blueAccent,
                    textColor: Colors.white,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      DetailRow(
                        title: 'Name',
                        data: _userName,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      DetailRow(
                        title: 'Email',
                        data: _userEmail,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: DetailRow(
                      data: _userDOBText,
                      title: 'Date of Birth',
                    ),
                  ),
                  Expanded(
                    child: DetailRow(
                      data: _userGender,
                      title: 'Gender',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: DetailRow(
                      data: '${_userWeight.toString()}Kg',
                      title: 'Weight',
                    ),
                  ),
                  Expanded(
                    child: DetailRow(
                      data: '${_userHeight.toString()}cm',
                      title: 'Height',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
    return steps;
  }

  Future<void> _showDateOfBirthPicker(BuildContext context) async {
    final pickedDOB = await showDatePicker(
      context: context,
      initialDate: _userDOB,
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDOB != null && pickedDOB != _userDOB) {
      setState(() {
        _userDOB = pickedDOB;
        _userDOBText = DateFormat('dd-MM-yyyy').format(pickedDOB);
        _userDOBController.value = TextEditingValue(text: _userDOBText!);
      });
      // ignore: avoid_returning_null_for_void
      return null;
    }
    // ignore: avoid_returning_null_for_void
    return null;
  }

  Future<void> createNewUser(userType, email, password, name, gender, dob, height, weight) async {
    final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
    return await userCollection.doc(userType).set({
      "email": email,
      "password": password,
      "name": name,
      "gender": gender,
      "dob": dob,
      "height": height,
      "weight": weight
    }).then((value) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed(LOGIN);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Acccount Created Successfully'),
      ));
    });
  }

  void signUp(userType, email, password, name, gender, dob, height, weight) async {
    // if (_formKey.currentState!.validate()) {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                createNewUser(userType, email, password, name, gender, dob, height, weight),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
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
    // }
  }
}
