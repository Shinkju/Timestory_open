import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timestory/screens/login_screen.dart';
import 'package:timestory/styles/colors.dart';

class JoinScreen extends StatefulWidget{
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  bool isPasswordMatched = true;
  String? errorMsg;

  //password 일치여부
  void _checkPasswordMatch1(value) {
    if(passwordController.text.isNotEmpty){
      if(passwordController.text == value.toString()){
        isPasswordMatched = true;
      }else{
        isPasswordMatched = false;
      }
    }else{
      isPasswordMatched = false;
    }
  }
  void _checkPasswordMatch2(value) {
    if(passwordCheckController.text.isNotEmpty){
      if(passwordCheckController.text == value.toString()){
        isPasswordMatched = true;
      }else{
        isPasswordMatched = false;
      }
    }
  }

  //회원가입 
  void _fireAuthSignUp() async{
    if(emailController.text.isEmpty){
      errorMsg = "사용하실 이메일을 입력해주세요.";
    }else if(passwordController.text.isEmpty){
      errorMsg = "사용하실 비밀번호를 입력해주세요.";
    }else if(passwordCheckController.text.isEmpty){
      errorMsg = "비밀번호를 한번 더 입력해주세요.";
    }

    if(errorMsg != null){
      Fluttertoast.showToast(
        msg: errorMsg.toString(),
        backgroundColor: Colors.white,
        fontSize: 20,
        toastLength: Toast.LENGTH_SHORT,  //AOS
        timeInSecForIosWeb: 1,   //IOS
      );
    }else{
      if(passwordController.text == passwordCheckController.text){
          try{
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailController.text.trim(), 
              password: passwordController.text.trim(),
            );

            Fluttertoast.showToast(msg: "회원가입이 완료되었습니다.\n로그인을 진행해주세요.");

            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          } on FirebaseAuthException catch (e){
            if(e.code == 'weak-password'){
              errorMsg = "비밀번호가 안전하지 않거나, 6자리 이하입니다.";
            }else if(e.code == 'email-already-in-use'){
              errorMsg = "이미 사용중인 이메일 주소입니다.";
            }

            if(errorMsg != null){
              Fluttertoast.showToast(msg: errorMsg.toString());
            }
          }
      }else{
        Fluttertoast.showToast(msg: "비밀번호가 일치하지 않습니다.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                  child: const Text(
                    "회원가입",
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: "Lato",
                      color: Color(0xFFFF4081),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: const Text(
                    "Sign-In",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Lato'
                    ),
                  ),
                ),
                const Text(
                  "아이디",
                  style: TextStyle(
                    color: DEFAULT_COLOR,
                    fontFamily: "Lato",
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 3, 5, 0),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("timestory@email.com", style: TextStyle(color: Colors.grey),),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                const Text(
                  "비밀번호",
                  style: TextStyle(
                    color: DEFAULT_COLOR,
                    fontFamily: "Lato",
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 3, 5, 0),
                  child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text("******", style: TextStyle(color: Colors.grey),),
                      ),
                      onChanged: (String value) {
                        _checkPasswordMatch2(value);
                      },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 3),
                  child: TextField(
                      controller: passwordCheckController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text("비밀번호 재확인", style: TextStyle(color: Colors.grey),),
                      ),
                      onChanged: (String value) {
                        _checkPasswordMatch1(value);
                      },
                    ),
                ),
                if(passwordCheckController.text.isNotEmpty)
                  Text(
                    isPasswordMatched ? "비밀번호가 일치합니다." : "비밀번호가 일치하지 않습니다.",
                    style: TextStyle(
                      color: isPasswordMatched ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () => _fireAuthSignUp(),
                    child: const Text("회원가입"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4081),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}