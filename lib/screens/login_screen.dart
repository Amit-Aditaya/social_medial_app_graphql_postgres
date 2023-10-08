import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:raftlabs_flutter/screens/create_account_screen.dart';
import 'package:raftlabs_flutter/screens/verify_email_screen.dart';
import 'package:raftlabs_flutter/utils/appcolors.dart';
import 'package:raftlabs_flutter/utils/primary_buttom.dart';

import '../utils/snackbar.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _loginFormkey,
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    height: 150,
                    width: 150,
                    child: Center(
                        child: SvgPicture.asset('assets/logoipsum-221.svg')),
                  )),
                  SizedBox(
                    height: ScreenUtil().setHeight(50),
                  ),
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
                        // focusedBorder: const OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //       color: Color(AppColors.primaryColor), width: 2.0),
                        // ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(17),
                            horizontal: ScreenUtil().setWidth(10)),
                        border: OutlineInputBorder(
                            //  borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(5)),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        labelText: 'Email Address',
                        labelStyle: const TextStyle(
                            color: Color(AppColors.primaryColor),
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                  SizedBox(
                      //  height: 55,
                      width: double.infinity,
                      child: TextFormField(
                        style: const TextStyle(
                            color: Color(AppColors.primaryColor),
                            fontWeight: FontWeight.w500),
                        controller: passwordController,
                        validator: (value) {
                          if (value!.length < 8) {
                            return 'Please enter a 8 digit password';
                          } else {
                            return null;
                          }
                        },
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              child: _isObscure
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(17),
                              horizontal: ScreenUtil().setWidth(10)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  PrimaryButton(
                      text: 'Login',
                      onTap: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                                  child: CircularProgressIndicator(),
                                ));
                        _login(context);
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) {
                  //         return const SignUpScreen();
                  //       }),
                  //     );
                  //   },
                  //   child: RichText(
                  //     textAlign: TextAlign.center,
                  //     text: const TextSpan(
                  //       text: 'Don\'t have an account?',
                  //       style: TextStyle(
                  //           letterSpacing: 0.35,
                  //           fontWeight: FontWeight.w600,
                  //           color: Color(AppColors.primaryTextBlack),
                  //           fontSize: 16),
                  //       children: [
                  //         TextSpan(
                  //           text: ' Sign Up Here',
                  //           style: TextStyle(
                  //             color: Color(AppColors.primaryColor),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const CreateAccountScreen();
                        }),
                      );
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.5),
                          border: Border.all(
                              width: 2,
                              color: const Color(AppColors.primaryColor))),
                      child: Center(
                          child: Text(
                        'Create Account',
                        style: TextStyle(
                            color: const Color(AppColors.primaryColor),
                            fontSize: 24.sp,
                            letterSpacing: .25,
                            fontWeight: FontWeight.w500),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ForgotPasswordScreen();
                      }));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Forgot Password? ',
                          style: TextStyle(
                              color: const Color(AppColors.primaryColor),
                              fontSize: 15.75.sp,
                              // letterSpacing: 1,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Click Here',
                          style: TextStyle(
                              color: const Color(AppColors.primaryColor),
                              fontSize: 15.75.sp,
                              // letterSpacing: 1,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    final isValid = _loginFormkey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    // FirebaseAuth.instance
    //     .signInWithEmailAndPassword(
    //         email: emailController.text.trim(),
    //         password: passwordController.text.trim())
    //     .catchError((err) {
    //   if (err.toString().toLowerCase().contains('there is no user record')) {
    //     SnackbarHelper.showCommonSnackbar(context, 'Invalid Login Credentials');
    //   } else {
    //     SnackbarHelper.showCommonSnackbar(context, err.toString());
    //   }
    // });
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const VerifyEmailScreen();
        }));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Navigator.pop(context);
        SnackbarHelper.showCommonSnackbar(context, 'Invalid Login Credentials');
      } else if (e.code == 'wrong-password') {
        Navigator.pop(context);
        SnackbarHelper.showCommonSnackbar(context, 'Wrong Password');
      } else {
        SnackbarHelper.showCommonSnackbar(
            context, e.code.toString().toUpperCase());
      }
    }
  }
}
