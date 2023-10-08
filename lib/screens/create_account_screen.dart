import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raftlabs_flutter/screens/verify_email_screen.dart';
import 'package:raftlabs_flutter/utils/snackbar.dart';

import '../utils/appcolors.dart';
import '../utils/primary_buttom.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  String dateText = '';
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(AppColors.primaryColor),
      ),
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    SizedBox(
                      //   height: 55,
                      width: double.infinity,
                      child: TextFormField(
                        controller: firstNameController,
                        style: const TextStyle(
                            color: Color(AppColors.primaryColor),
                            fontWeight: FontWeight.w500),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first Name';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(17),
                              horizontal: ScreenUtil().setWidth(10)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          labelText: 'First Name',
                          labelStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    SizedBox(
                      //   height: 55,
                      width: double.infinity,
                      child: TextFormField(
                        controller: lastNameController,
                        style: const TextStyle(
                            color: Color(AppColors.primaryColor),
                            fontWeight: FontWeight.w500),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last Name';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(17),
                              horizontal: ScreenUtil().setWidth(10)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          labelText: 'Last Name',
                          labelStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    SizedBox(
                      //    height: 55,
                      width: double.infinity,
                      child: TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (!value!.contains('@') || !value.contains('.')) {
                            return 'Please enter a valid email address';
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(
                            color: Color(AppColors.primaryColor),
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(17),
                              horizontal: ScreenUtil().setWidth(10)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          labelText: 'Email Address',
                          labelStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    SizedBox(
                        //  height: 55,
                        width: double.infinity,
                        child: TextFormField(
                          style: const TextStyle(
                              color: Color(AppColors.primaryColor),
                              fontWeight: FontWeight.w500),
                          controller: passwordController,
                          validator: (value) {
                            bool validateStructure(String value) {
                              String pattern =
                                  r'^(?=.*?[A-Z])(?=.*?[0-9]).{8,}$';
                              RegExp regExp = RegExp(pattern);
                              return regExp.hasMatch(value);
                            }

                            if (value!.length < 8) {
                              return 'Please enter a 8 digit password';
                            } else if (!validateStructure(value)) {
                              return 'Must contain atleast 1 uppercase letter & 1 number';
                            } else {
                              return null;
                            }
                          },
                          obscureText: _isPasswordObscure,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPasswordObscure = !_isPasswordObscure;
                                  });
                                },
                                child: _isPasswordObscure
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(17),
                                horizontal: ScreenUtil().setWidth(10)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        )),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    SizedBox(
                        //    height: 55,
                        width: double.infinity,
                        child: TextFormField(
                          style: const TextStyle(
                              color: Color(AppColors.primaryColor),
                              fontWeight: FontWeight.w500),
                          controller: rePasswordController,
                          validator: (val) {
                            if (rePasswordController.text !=
                                passwordController.text) {
                              return 'Passwords do not match';
                            } else {
                              return null;
                            }
                          },
                          obscureText: _isConfirmPasswordObscure,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isConfirmPasswordObscure =
                                        !_isConfirmPasswordObscure;
                                  });
                                },
                                child: _isConfirmPasswordObscure
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(17),
                                horizontal: ScreenUtil().setWidth(10)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            labelText: 'Confirm Password',
                            labelStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        )),
                    SizedBox(height: ScreenUtil().setHeight(70)),
                    PrimaryButton(
                        text: 'Continue',
                        onTap: () async {
                          _signup(context);
                        }),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'By pressing continue, you are agreeing to Doctor Cupid App\'s \n',
                        style: TextStyle(
                            color: const Color(AppColors.primaryColor),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                            text: 'EULA & Privacy Policy',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void _signup(BuildContext context) async {
    final isValid = _formkey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      //create user with email and password
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: rePasswordController.text.trim())
          .then((value) {
        if (context.mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const VerifyEmailScreen()));
        }
      });
    } on FirebaseException catch (e) {
      if (e.code == 'email-already-in-use') {
        Navigator.pop(context);
        SnackbarHelper.showCommonSnackbar(
            context, 'An account with this email already exists');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.code.toString()),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
