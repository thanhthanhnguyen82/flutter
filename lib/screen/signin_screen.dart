import 'package:NCKH/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:NCKH/screen/signUpOption.dart';
import 'package:NCKH/screen/reusableTextField.dart';
import 'package:NCKH/screen/uiButton.dart';
import 'package:NCKH/screen/reset_screen.dart';
import 'package:NCKH/screen/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  bool _rememberMe = false;
  @override
  void initState() {
    super.initState();
    _loadRememberMeStatus();
  }

  _loadRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        // Nếu đang ghi nhớ, thì cũng đọc tên đăng nhập và mật khẩu đã lưu
        _emailTextController.text = prefs.getString('user_email') ?? '';
        _passwordTextController.text = prefs.getString('user_password') ?? '';
      }
    });
  }

  static Color hexStringToColor(String hexColor) {
    final buffer = StringBuffer();
    if (hexColor.length == 6 || hexColor.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexColor.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  void onLoginSuccess() {
    // Chuyển hướng về màn hình chính (MainScreen) sau đăng nhập thành công.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  Widget _rememberMeCheckbox() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: _rememberMe,
            onChanged: (bool? value) {
              setState(() {
                _rememberMe = value!;
              });
            },
            activeColor: const Color.fromARGB(255, 0, 0, 0),
          ),
          const Text(
            'Ghi nhớ đăng nhập',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.2,
              20,
              0,
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                ReusableTextField(
                  "Nhập Email",
                  Icons.email,
                  false,
                  _emailTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                ReusableTextField(
                  "Nhập Mật khẩu",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                ),
                _rememberMeCheckbox(),
                const SizedBox(
                  height: 5,
                ),
                UIButton(context, "Đăng nhập", () async {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text,
                  )
                      .then((value) {
                    if (_rememberMe) {
                      // Save user credentials for future logins
                      saveCredentials(_emailTextController.text,
                          _passwordTextController.text, _rememberMe);
                    }
                    onLoginSuccess();
                  }).catchError((error) {
                    print("Lỗi ${error.toString()}");
                  });
                }),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SignUpOption("Đăng kí  | ", SignUpScreen()),
                    SignUpOption("Quên mật khẩu", ResetPassword()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Save user credentials using shared_preferences
  Future<void> saveCredentials(
      String email, String password, bool rememberMe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_email', email);
    prefs.setString('user_password', password);
    prefs.setBool('rememberMe', rememberMe);
  }
}
