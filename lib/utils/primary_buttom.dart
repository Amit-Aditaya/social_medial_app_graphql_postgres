import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raftlabs_flutter/utils/appcolors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final Color? color;

  const PrimaryButton(
      {super.key, required this.text, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
            color: color ?? const Color(AppColors.primaryColor),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                letterSpacing: .25,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
