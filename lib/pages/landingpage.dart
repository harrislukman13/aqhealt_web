import 'package:flutter/material.dart';
import 'package:aqhealth_web/constants/color.dart';
import 'package:sizer/sizer.dart';
import 'package:aqhealth_web/widgets/widgets.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: navBar(context),
      body: ListView(
        shrinkWrap: true,
        children: [
          Stack(
            children: <Widget>[
              Container(
                height: 100.h,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                        image: const AssetImage('assets/images/hpupm.jpg'),
                        fit: BoxFit.cover)),
              ),
              Positioned(
                top: 20.h,
                left: 120.h,
                child: SizedBox(
                  height: 28.h,
                  width: 25.w,
                  child: Form(
                    key: _formKey,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.sp)),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 1.w,
                          vertical: 1.h,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Sign In",
                              style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 4.sp),
                            ),
                            SizedBox(height: 2.h),
                            customTextFormField(
                                controller: _emailController,
                                focusNode: _emailFocus,
                                hintText: 'E-mail',
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  size: 3.sp,
                                ),
                                validator: (value) {
                                  if (!RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(value!)) {
                                    return 'Email is not valid';
                                  } else {
                                    return null;
                                  }
                                }),
                            SizedBox(height: 2.h),
                            customTextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                isObscured: true,
                                hintText: 'Password',
                                prefixIcon: Icon(
                                  Icons.password_outlined,
                                  size: 3.sp,
                                ),
                                validator: (value) {
                                  if (value!.length < 6) {
                                    return 'Password should at least 6 characters';
                                  } else {
                                    return null;
                                  }
                                }),
                            SizedBox(height: 3.h),
                            TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.sp),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 2.5.h,
                                ),
                                backgroundColor: primary,
                              ),
                              onPressed: () {},
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 3.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body(),
        ],
      ),
    );
  }

  AppBar navBar(BuildContext context) {
    return AppBar(
      title: Text(
        'AQhealth',
        style: TextStyle(
            color: primary, fontSize: 5.sp, fontWeight: FontWeight.bold),
      ),
      elevation: 5,
      backgroundColor: Colors.white,
      leading: IconButton(
          icon: Image.asset('assets/hospital.png'),
          onPressed: () {
            setState(() {
              const LandingPage();
            });
          }),
    );
  }
}

Container body() {
  return Container(
    height: 40.h,
  );
}
