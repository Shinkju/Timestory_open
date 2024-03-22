import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timestory/screens/calendar_screen.dart';
import 'package:timestory/screens/join_screen.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final storage = const FlutterSecureStorage();

  //이메일기억 저장소관리
  late SharedPreferences prefs;
  bool isChecked = false;
  bool isLoading = false;
  String? errorMsg;

  @override //초기화
  void initState(){
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async{
    prefs = await SharedPreferences.getInstance();
    final checkEmail = prefs.getString('checkEmail');
    if(checkEmail != null){
      //이전 저장된 메일 존재
      setState(() {
        emailController.text = checkEmail;
        isChecked = true;
      });
    }
  }

  Future<void> onCheckTap() async{
    setState(() {
      isChecked = !isChecked;
    });

    if(isChecked){
      await prefs.setString('checkEmail', emailController.text);
    }else{
      //체크박스를 해제한 경우에는 기존 데이터도 삭제
      final checkEmail = prefs.getString('checkEmail');
      if(checkEmail != null){
        await prefs.remove('checkEmail');
      }
    }
  }

  void _fireAuthSignIn(){
    if(emailController.text.isEmpty){
      errorMsg = "이메일을 입력하세요.";
    } 
    if(passwordController.text.isEmpty){
      errorMsg = "비밀번호를 입력하세요.";
    }

    if(errorMsg != null){
      Fluttertoast.showToast(
        msg: errorMsg.toString(),
        gravity: ToastGravity.TOP, //위치
        backgroundColor: Colors.white,
        fontSize: 20,
        toastLength: Toast.LENGTH_SHORT,  //AOS
        timeInSecForIosWeb: 1,  //IOS
      );
    }else{
      _fireAuthLogin(emailController.text.trim(), passwordController.text.trim());
    }
  }

  void _fireAuthLogin(String email, String password) async{
    if(_formKey.currentState!.validate()){ //키보드 숨기기
      FocusScope.of(context).requestFocus(FocusNode());

      setState(() {
        isLoading = true;
      });

      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, 
          password: password
        );

        //보안 스토리지 저장
        await storage.write(key: 'email', value: email);
        await storage.write(key: 'password', value: password);

        setState(() {
            isLoading = false;
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const CalendarScreen()),
            );
        });
      } on FirebaseAuthException catch(e){
        if(e.code == 'user-not-found'){
          errorMsg = '사용자가 존재하지 않습니다.';
        }else if(e.code == 'wrong-password'){
          errorMsg = '비밀번호가 일치하지 않습니다.';
        }else if(e.code == 'invalid-email'){
          errorMsg = '이메일이 일치하지 않습니다.';
        }

        if(errorMsg != null){
          Fluttertoast.showToast(
          msg: errorMsg.toString(),
          gravity: ToastGravity.TOP, //위치
          backgroundColor: Colors.white,
          fontSize: 20,
          toastLength: Toast.LENGTH_SHORT,  //AOS
          timeInSecForIosWeb: 1,  //IOS
        );
        }
      }finally{
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView( //오버플로우
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
                  child: const Text(
                    "TimeStory",
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Lato',
                      color: Color(0xFFFF4081),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: const Text(
                    "LOGIN",
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
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(), 
                      label: emailController.text.isEmpty ? const Text("timestory@email.com", style: TextStyle(color: Colors.grey)) : null,
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
                  margin: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: onCheckTap, 
                        icon: isChecked
                          ? const Icon(Icons.check_box_rounded)
                          : const Icon(Icons.check_box_outline_blank_rounded),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "이메일 정보 저장하기",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Lato",
                        ),
                      )
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isLoading ? null : _fireAuthSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4081),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("로그인")
                    ),
                    if(isLoading)
                      const Positioned(
                        child: Center(
                          child: CircularProgressIndicator(),
                        )
                      ),
                  ],
                ),
                const SizedBox(height: 50.0,),
                GestureDetector(
                  child: const Text(
                    "회원가입",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Lato",
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const JoinScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}