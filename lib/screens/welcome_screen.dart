import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

//routes to navigate to
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import './chat_screen.dart';


//firebase authentication
import 'package:firebase_auth/firebase_auth.dart';


import '../components/round_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation backgroundAnimation;
  late Animation curve;




  @override
  void initState() {
    super.initState();



    checkIfUserExists();


    controller = AnimationController(duration: const Duration(seconds:4), vsync: this);

    backgroundAnimation = ColorTween(begin:Colors.grey,end:Colors.white).animate(controller);


    curve = CurvedAnimation(parent: controller, curve: Curves.bounceOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();

   




  }


  void checkIfUserExists(){
    FirebaseAuth.instance.authStateChanges().listen((User? user) async{
      if(user != null){

        Navigator.pushNamed(context,ChatScreen.id).then((value){
          checkIfUserExists();
        });
        
        

      }
    });
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:backgroundAnimation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Hero(
                    tag: "logo",
                    child: Container(
                      height: curve.value * 100,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextLiquidFill(
                    loadDuration: const Duration(seconds: 4),
                    text: 'Flash Chat',
                    waveColor: Color.fromARGB(255, 154, 154, 4),
                    boxBackgroundColor:backgroundAnimation!.value,
                    textStyle: TextStyle(
                      fontSize: 42.0,
                      fontWeight: FontWeight.bold,
                    ),
                    boxWidth: 400,
                    boxHeight: 300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundButton(color: Colors.lightBlueAccent,buttonText: 'Log In',navigationFunction: (){Navigator.pushNamed(context,LoginScreen.id);}),
            
            RoundButton(color: Colors.blueAccent, navigationFunction: (){Navigator.pushNamed(context,RegistrationScreen.id);}, buttonText:"Register"),
            
          ],
        ),
      ),
    );
  }
}

