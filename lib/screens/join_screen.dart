import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timestory/screens/login_screen.dart';

class JoinScreen extends StatefulWidget{
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMsg = "";
  void _fireAuthSignUp() async{
    if(emailController.text.isEmpty){
      errorMsg = "사용하실 이메일을 입력해주세요.";
    }else if(passwordController.text.isEmpty){
      errorMsg = "사용하실 비밀번호를 입력해주세요.";
    }

    if(errorMsg.isNotEmpty){
      Fluttertoast.showToast(
        msg: errorMsg,
        backgroundColor: Colors.white,
        fontSize: 20,
        toastLength: Toast.LENGTH_SHORT,  //AOS
        timeInSecForIosWeb: 1,   //IOS
      );
    }else{
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
        print("Failed with error code: ${e.code}");
        Fluttertoast.showToast(msg: e.code);
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
                Container(
                  margin: const EdgeInsets.all(5),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("timestory@email.com", style: TextStyle(color: Colors.grey),),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("********", style: TextStyle(color: Colors.grey),),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 10, 0),
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