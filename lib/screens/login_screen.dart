import 'package:flutter/material.dart';


import '../components/round_button.dart';

import '../constants.dart';


import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

//firebase authentication
import 'package:firebase_auth/firebase_auth.dart';



//chat screen
import './chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  late String email;
  late String password;


  @override
  void initState() {
    super.initState();
    checkIfUserExists();
  }


  void checkIfUserExists(){
    _auth.authStateChanges().listen((User? user) async{
      if(user != null){

        Navigator.pushNamed(context,ChatScreen.id).then((value){
          checkIfUserExists();
        });
        
        

      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag:'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType:TextInputType.emailAddress,
                style: kTextFieldInputText,
                onChanged: (value) {
                  email = value;
                },
                decoration:kTextFieldDecoration.copyWith(hintText: 'your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                style: kTextFieldInputText,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'your password')
              ),
              SizedBox(
                height: 24.0,
              ),
      
              RoundButton(color: Colors.lightBlueAccent,buttonText: 'Log In',navigationFunction: ()async{
                
                 setState(() {
                  showSpinner = true;
                });
                try {
                  UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
                  
                  if(userCredential.user != null && context.mounted){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }

                  setState(() {
                   showSpinner = false;
                  });
      
                }on FirebaseAuthException catch(e){

                  setState(() {
                   showSpinner = false;
                  });
      
                  if(e.code == "invalid-email"){
                    print("that is not the correct email");
                  }else if(e.code == "user-not-found"){
                    print("this user doesn't exist");
                  }else if(e.code == "wrong-password"){
                    print('that is not the correct password!');
                  }
      
                }catch(e){
                  setState(() {
                   showSpinner = false;
                  });
                  print(e);
                }
              }),
              
            ],
          ),
        ),
      ),
    );
  }
}
