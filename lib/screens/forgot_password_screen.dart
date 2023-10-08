import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raftlabs_flutter/utils/appcolors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  TextEditingController forgotPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const PrimaryAppBar(title: 'Forgot Password'),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(height: 110),
          const Text(
            'Enter the email address associated to your account and we will send you a link to reset password',
            textAlign: TextAlign.justify,
            style:
                TextStyle(fontSize: 16, color: Color(AppColors.primaryColor)),
          ),
          const SizedBox(height: 50),
          SizedBox(
            //    height: 55,
            width: double.infinity,
            child: TextFormField(
              controller: forgotPasswordController,
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
                    //  borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(5)),
                floatingLabelAlignment: FloatingLabelAlignment.start,
                labelText: 'Email Address',
                labelStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
          const SizedBox(height: 25),
          // PrimaryButton(
          //     text: 'Reset Password',
          //     onTap: () async {
          //       if (forgotPasswordController.text.isEmpty) {
          //         SnackbarHelper.showCommonSnackbar(
          //             context, 'Please enter your email address');
          //       } else if (!forgotPasswordController.text.contains('@') ||
          //           !forgotPasswordController.text.contains('.')) {
          //         SnackbarHelper.showCommonSnackbar(
          //             context, 'Please enter a valid email address');
          //       } else {
          //         showDialog(
          //             context: context,
          //             builder: (context) =>
          //                 const Center(child: CircularProgressIndicator()));
          //         try {
          //           await FirebaseAuth.instance
          //               .sendPasswordResetEmail(
          //                   email: forgotPasswordController.text.trim())
          //               .then((value) {
          //             Navigator.pop(context);
          //             Navigator.pop(context);
          //           }).then((value) {
          //             SnackbarHelper.showCommonSnackbar(context, 'Email Sent');
          //           });
          //         } on FirebaseException catch (e) {
          //           Navigator.pop(context);
          //           SnackbarHelper.showCommonSnackbar(
          //               context, e.message ?? 'An Error Occured');
          //         }
          //       }
          //     })
        ]),
      ),
    );
  }
}
