import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khososei/verification_screen.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn(String input) {
    Get.to(Verification(input), transition: Transition.leftToRight);
  }

  var phone = "";
  var countryCode = "+966";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Image.asset(
                'images/absence.png',
                height: 160,
                fit: BoxFit.cover,
                width: 160,
              ),

              const SizedBox(height: 50),

              const Text('أدخل رقم الهاتف لتسجيل الدخول',
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Cairo",
                      fontWeight: FontWeight.bold)),

              const SizedBox(height: 25),

              // username textfield
              TextFieldWidget(
                '05XXXXXXXX',
                false,
              ),

              const SizedBox(height: 45),

              // sign in button
              Container(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 8,
                        fixedSize: const Size(150, 50),
                        backgroundColor: Colors.lightGreen[400],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: () {
                      if (phone.length != 10) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Container(
                            height: 40,
                            decoration: const BoxDecoration(color: Colors.red),
                            alignment: Alignment.center,
                            child: const Text(
                              "الرقم المدخل غير صحيح",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Cairo",
                              ),
                            ),
                          ),
                          behavior: SnackBarBehavior.floating,
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                        ));
                      } else {
                        signUserIn(countryCode + phone);
                      }
                    },
                    child: const Text(
                      "تسجيل الدخول",
                      style:
                          TextStyle(fontFamily: "Cairo", color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFieldWidget(String hintText, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        onChanged: (value) {
          phone = value;
        },
        obscureText: obscureText,
        keyboardType: TextInputType.phone,
        style: const TextStyle(fontFamily: "Cairo"),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500], fontFamily: "Cairo")),
      ),
    );
  }
}
