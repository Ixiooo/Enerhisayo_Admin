import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../utils/size_helpers.dart';
import '../../../models/LocalSharedPref.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key, }) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  // Variable Declarations
  final user = FirebaseAuth.instance.currentUser!;
  double _screenHeight = 0;
  double _screenWidth = 0;
  bool _isSmallReso = false;

  // Menu Item for Exercises, Warmup, and Scheduke
  Widget _createMenuItem(){
    return Column(
      children: [

        Row(
          children: [
            SizedBox(width: displayWidth(context)*0.05,),
            Container(
              height:  displayHeight(context)*0.15,
              width: displayWidth(context)*0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow:[ BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 3)
                )],
                borderRadius: BorderRadius.circular(25)
              ),
              child:  Material(
                color:  Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  splashColor: Colors.red[200],
                  onTap: () {
                    Navigator.pushNamed(context, '/admin_exercises');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image(
                        image: AssetImage('assets/workout.png'),
                            width: displayHeight(context)*0.14, height: displayHeight(context)*0.14,
                        fit: BoxFit.contain),
                        SizedBox(width: displayWidth(context)*0.01,),
                        Text(
                          'Exercises',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 34,
                              color: Color(0xff526791),
                            ),
                        ),
                    ]),
                ),
              ),
            )
          ]
        ),
        
        SizedBox(height: displayHeight(context)*0.02,),
        
        Row(
          children: [
            SizedBox(width: displayWidth(context)*0.05,),
            Container(
              height:  displayHeight(context)*0.15,
              width: displayWidth(context)*0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow:[ BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 3)
                )],
                borderRadius: BorderRadius.circular(25)
              ),
              child:  Material(
                color:  Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  splashColor: Colors.red[200],
                  onTap: () {
                    Navigator.pushNamed(context, '/admin_warmup_exercises');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image(
                        image: AssetImage('assets/warmup.png'),
                            width: displayHeight(context)*0.14, height: displayHeight(context)*0.14,
                        fit: BoxFit.contain),
                        SizedBox(width: displayWidth(context)*0.01,),
                        Text(
                          'Warmup \nExercises',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                              color: Color(0xff526791),
                            ),
                        ),
                    ]),
                ),
              ),
            )
          ]
        ),
        
        SizedBox(height: displayHeight(context)*0.02,),
        
        Row(
          children: [
            SizedBox(width: displayWidth(context)*0.05,),
            Container(
              height:  displayHeight(context)*0.15,
              width: displayWidth(context)*0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow:[ BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 3)
                )],
                borderRadius: BorderRadius.circular(25)
              ),
              child:  Material(
                color:  Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  splashColor: Colors.red[200],
                  onTap: () {
                    Navigator.pushNamed(context, '/admin_schedule');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image(
                        image: AssetImage('assets/schedule.png'),
                            width: displayHeight(context)*0.14, height: displayHeight(context)*0.14,
                        fit: BoxFit.contain),
                        SizedBox(width: displayWidth(context)*0.01,),
                        Text(
                          'Schedule',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 34,
                              color: Color(0xff526791),
                            ),
                        ),
                    ]),
                ),
              ),
            )
          ]
        ),
      
        SizedBox(height: displayHeight(context)*0.02,),
        
        Row(
          children: [
            SizedBox(width: displayWidth(context)*0.05,),
            Container(
              height:  displayHeight(context)*0.15,
              width: displayWidth(context)*0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow:[ BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 3)
                )],
                borderRadius: BorderRadius.circular(25)
              ),
              child:  Material(
                color:  Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  splashColor: Colors.red[200],
                  onTap: () {
                    Navigator.pushNamed(context, '/user_progress');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image(
                        image: AssetImage('assets/progress.png'),
                            width: displayHeight(context)*0.14, height: displayHeight(context)*0.14,
                        fit: BoxFit.contain),
                        SizedBox(width: displayWidth(context)*0.01,),
                        Text(
                          'User \nProgress',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                              color: Color(0xff526791),
                            ),
                        ),
                    ]),
                ),
              ),
            )
          ]
        ),
      
      ],
    );
  }

  //Identify Screen Size of Device of User
  void _getScreenSize(){
    _screenHeight = displayHeight(context);
    _screenWidth = displayWidth(context);
    if(_screenHeight <= 896 && _screenWidth <=414){
      setState(() {
        _isSmallReso = true;
      });
    }else{
      setState(() {
        _isSmallReso = false;
      });
    }
  }

  //Logout Current User
  void logout()async{
    try{
      await LocalSharedPreferences.deleteAll();
      await FirebaseAuth.instance.signOut();
    }catch(e)
    {
      print(e.toString());
    }
  }

  // Run the Functions after Startup but before the build method 
  @override
  void didChangeDependencies(){
    _getScreenSize();
  }

  // Run the Functions on Startup
  @override
    void initState() {
    super.initState();
  }

  // Build the User Interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [

            // Background Top
            Positioned(
              child: Container(
                height: displayHeight(context)*1,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:  AssetImage('assets/backgroundBlue.png'),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.red[400]
                ),
              ),
            ),
            
            // Greeting Text
            Positioned(
              top: displayHeight(context)*0.04,
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi Admin,',
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: !_isSmallReso
                        ?46
                        :42,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Let\'s Manage Exercises',
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: !_isSmallReso
                        ?28
                        :22,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Logout Icon
            Positioned(
              left: displayWidth(context)*0.8,
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        logout();
                      }, 
                      icon: Icon(Icons.logout_outlined),
                      color: Colors.white,
                      iconSize: 48,
                    )
                  ],
                ),
              ),
            ),

            // Bottom White Background
            Positioned(
              top: displayHeight(context)*0.65,
              child: Container(
                height: displayHeight(context)*0.55,
                width: displayWidth(context),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50) ),
                ),
              ),
            ),  
         
            // Menu Items
            Positioned(
              top: displayHeight(context)*0.3,
              child: _createMenuItem(),
            ),
            
          ]),

            
        ]
      ),
    );
  }
}
