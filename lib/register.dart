import 'dart:convert';
import 'package:work_schedule/login.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:work_schedule/http.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _emailIsNotValidate = false;
  bool _passwordIsNotValidate = false;
  bool _confirmPasswordIsNotValidate = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert!'),
            content: Text('รหัสผ่านไม่ตรงกัน'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      try {
        var response = await http.post(
          Uri.parse(register),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status']) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          throw ("สมัครผิดพลาด");
        }
      } catch (error) {
        throw error;
      }
    } else if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      setState(() {
        _confirmPasswordIsNotValidate = true;
      });
    } else if (emailController.text.isNotEmpty) {
      setState(() {
        _passwordIsNotValidate = true;
        _confirmPasswordIsNotValidate = true;
      });
    } else {
      setState(() {
        _emailIsNotValidate = true;
        _passwordIsNotValidate = true;
        _confirmPasswordIsNotValidate = true;
      });
    }
  }

  void passwordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void confirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(243, 223, 192, 1),
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'สมัครสมาชิก',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(150, 255, 255, 255),
                      hintText: "อีเมล",
                      errorText: _emailIsNotValidate ? "โปรดกรอกอีเมล" : null,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(150, 255, 255, 255),
                      hintText: "รหัสผ่าน",
                      errorText:
                          _passwordIsNotValidate ? "โปรดกรอกรหัสผ่าน" : null,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: passwordVisibility,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(150, 255, 255, 255),
                      hintText: "ยืนยันรหัสผ่าน",
                      errorText: _confirmPasswordIsNotValidate
                          ? "โปรดกรอกรหัสผ่าน"
                          : null,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: confirmPasswordVisibility,
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        registerUser();
                      },
                      child: HStack([
                        VxBox(
                                child: "สมัครสมาชิก"
                                    .text
                                    .white
                                    .makeCentered()
                                    .px16()
                                    .py8())
                            .blue500
                            .roundedLg
                            .make()
                            .py16()
                      ])),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: HStack([
                      "เป็นสมาชิกอยู่แล้ว? ".text.make(),
                      "เข้าสู่ระบบ".text.bold.make(),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
