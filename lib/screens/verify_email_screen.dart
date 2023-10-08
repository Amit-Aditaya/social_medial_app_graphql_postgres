import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raftlabs_flutter/screens/home_screen.dart';
import 'package:raftlabs_flutter/utils/appcolors.dart';
import 'package:raftlabs_flutter/utils/primary_buttom.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({
    super.key,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  Timer? _resendEmailTimer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    print('verify email init');
    super.initState();

    FirebaseAuth.instance.currentUser?.reload();
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    startResendEmailCountDown();
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(const Duration(seconds: 3), (_) {
        return checkEmailVerified();
      });
    }

    // if (isEmailVerified) {
    //   DailyBonusDialog.getLastDailyBonusTIme(context, widget.docId);
    // }
  }

  @override
  void dispose() {
    timer?.cancel();
    _resendEmailTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('verify email');
    return isEmailVerified
        ? const HomeScreen()
        : Scaffold(
            body: SafeArea(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Verify Email',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: const Color(AppColors.primaryColor),
                            fontSize: 24.sp,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(30),
                        ),
                        Text(
                          ' A verification email has been sent to your email address',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: const Color(AppColors.primaryColor),
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(30),
                        ),
                        PrimaryButton(
                            color: !canResendEmail
                                ? const Color(AppColors.primaryColor)
                                : null,
                            text: 'Resend Email',
                            onTap: () {
                              if (canResendEmail) {
                                sendVerificationEmail();
                                startResendEmailCountDown();
                              }
                            }),
                        GestureDetector(
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                              height: 55,
                              child: Center(
                                  child: Text(
                                'Cancel',
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    color: const Color(AppColors.primaryColor)),
                              ))),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(10),
                        ),
                        Text(
                          _secondsRemaining > 0
                              ? 'Resend in $_secondsRemaining seconds'
                              : 'Resend',
                          style: TextStyle(
                              color: const Color(AppColors.primaryColor),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600),
                        )
                      ]),
                ),
              ),
            ),
          );
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 90), () {
        setState(() {
          canResendEmail = true;
        });
      });
    } catch (e) {
      //show snacbar
      //msg : e.toSrting();
    }
  }

  void checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  void startResendEmailCountDown() {
    const duration = Duration(seconds: 1);
    _secondsRemaining = 90;
    _resendEmailTimer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        if (_secondsRemaining < 1) {
          timer.cancel();
        } else {
          _secondsRemaining = _secondsRemaining - 1;
        }
      });
    });
  }
}
