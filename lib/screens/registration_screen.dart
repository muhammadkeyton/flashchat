import 'package:flutter/material.dart';

import '../components/round_button.dart';

import '../constants.dart';


import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

//firebase authentication
import 'package:firebase_auth/firebase_auth.dart';


//chat screen
import './chat_screen.dart';



class RegistrationScreen extends StatefulWidget {
  static const String id = 'registrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
                tag:"logo",
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                style: kTextFieldInputText,
                textAlign: TextAlign.center,
                keyboardType:TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                style: kTextFieldInputText,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundButton(color: Colors.blueAccent, navigationFunction: ()async {
                setState(() {
                  showSpinner = true;
                });
                //register user and if successfully authenticated navigate to chat screen
                try {
      
                   await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
                   _auth
                      .authStateChanges()
                      .listen((User? user) { 
                        if(user != null){
                        Navigator.pushNamed(context,ChatScreen.id);
                        }

                        setState(() {
                          showSpinner = false;
                        });
                      });
      
                  
      
                  
                } on FirebaseAuthException  catch (e) {
                  setState(() {
                   showSpinner = false;
                  });
                  if(e.code == "weak-password"){
                    print("password not strong enough");
                  } else if (e.code == "invalid-email"){
                    print("invalid email address");
                  } else if (e.code == "email-already-in-use"){
                    print("a user with that email already exists");
                  }
                  
                } catch(e){
                  setState(() {
                   showSpinner = false;
                  });
                  print(e);
                }
               
              }, buttonText:"Register")
            ],
          ),
        ),
      ),
    );
  }
}
