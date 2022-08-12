import 'package:enerhisayo_admin/models/DailyRequirements.dart';
import 'package:enerhisayo_admin/models/DailyExercises.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../utils/size_helpers.dart';



class DailySchedule extends StatefulWidget {

  static const routeName = '/daily_schedule';


  const DailySchedule({Key? key,}) : super(key: key);

  @override
  State<DailySchedule> createState() => _DailyScheduleState();
}

class _DailyScheduleState extends State<DailySchedule> {

  // Variable Declarations
  bool isDayComplete = false;
  int selectedDay=0;
  int selectedWeek=0;

  String _currentCategory ='';
  int _currentWeek = 0;
  int _currentDay = 0;

  int _requiredMins = 0;
  int _minExercises = 0;

  double _screenHeight = 0;
  double _screenWidth = 0;
  bool _isSmallReso = false;
  
  bool hasDailyRequirements = false;
  
  Stream<List <DailyExercises>> _dailyExercisesStream() => 
    FirebaseFirestore.instance.collection('schedule')
      .where('day', isEqualTo: _currentDay)
      .where('week', isEqualTo: _currentWeek)
      .where('category', isEqualTo: _currentCategory)
      .orderBy('exerciseName')
      .snapshots()
      .map((snapshot) 
      => snapshot.docs.map((doc) => DailyExercises.fromJson(doc.data())).toList());
  
  Stream<List <DailyRequirements>> _dailyRequirementsStream() => 
    FirebaseFirestore.instance.collection('dailyRequirements')
      .where('day', isEqualTo: _currentDay)
      .where('week', isEqualTo: _currentWeek)
      .where('category', isEqualTo: _currentCategory)
      .snapshots()
      .map((snapshot) 
      => snapshot.docs.map((doc) => DailyRequirements.fromJson(doc.data())).toList());

  // Load Daily Exercises from Database
  Widget _loadDailyExercises(){
    return StreamBuilder<List<DailyExercises>>(
      stream: _dailyExercisesStream(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Text('Something Went Wrong ${snapshot.error}');
        }
        else if(snapshot.hasData)
        {
            if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
            
          } else{
            final data = snapshot.data!;

            return ListView(
              physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: data.map(_buildDailyExercises).toList(),
            );
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
  
  // Build UI for Loaded Exercises
  Widget _buildDailyExercises(DailyExercises dailyExercises){
    return 
      Column(
        children: [
          SizedBox(height: 10,),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xffEB5253),
                  width: 1
                ),
                borderRadius:  BorderRadius.circular(25),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black87.withOpacity(0.12),
                    blurRadius: 5.0,
                    spreadRadius: 1.1,
                  )
                ]
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
                ),
                title: Text(
                  dailyExercises.exerciseName,
                  style:Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.red[400],
                  )
                  ,
                ),
                subtitle: Text(
                  '${dailyExercises.count} Counts - ${dailyExercises.durationSecs} Seconds',
                  style:Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xff074AAB),
                  )
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/edit_daily_exercises', arguments: {'dailyExerciseId': dailyExercises.id});
                },
              ),
            ),
          ),
        ],
      );
  }

  // Load Daily Requirements from Database
  Widget _loadDailyRequirements(){
    return StreamBuilder<List<DailyRequirements>>(
      stream: _dailyRequirementsStream(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Text('Something Went Wrong ${snapshot.error}');
        }
        else if(snapshot.hasData)
        {
            if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
            
          } else{

            final data = snapshot.data!;

            return ListView(
              physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: data.map(_buildDailyRequirements).toList(),
            );
          }

        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  // Build UI for Daily Requirements
  Widget _buildDailyRequirements(DailyRequirements dailyRequirements){
    return 
       Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red.withOpacity(0.42),
            ),
            child: Row(
              children: [
                Icon(Icons.watch_later_outlined, color:  Color(0xff074AAB)),
                const SizedBox(width: 7),
                Text('${dailyRequirements.requiredMins} Minutes', style: TextStyle(color:Color(0xff074AAB), fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
              
          const SizedBox(width: 15),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red.withOpacity(0.42),
            ),
            child: Row(
              children: [
                Icon(Icons.fitness_center_outlined, color: Color(0xff074AAB),),
                const SizedBox(width: 7),
                Text('${dailyRequirements.minExercises} Exercises', style: TextStyle(color:Color(0xff074AAB), fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      );
  }

  //Identify Screen Size of Device of User
  void _getScreenSize(){
    _screenHeight = displayHeight(context);
    _screenWidth = displayWidth(context);
    if(_screenHeight < 896 && _screenWidth <414){
      setState(() {
        _isSmallReso = true;
      });
    }else{
      setState(() {
        _isSmallReso = false;
      });
    }
  }

  // Run the Functions after Startup but before the build method 
@override
void didChangeDependencies() {
  
  final data = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
  _currentDay = int.parse(data['selectedDay']!);
  _currentWeek = int.parse(data['selectedWeek']!);
  _currentCategory = data['selectedCategory']!;
  _getScreenSize();
  super.didChangeDependencies();
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
      appBar: AppBar(
          flexibleSpace: Image(
            image: AssetImage('assets/backgroundBlue.png'),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.red[400],
        title: Text('Daily Schedule'),
      ),
      body: SafeArea(
        child:Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top:20, left:20, right:20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  
                  Text(
                    "${_currentCategory}",
                    style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                      color: Colors.red[600],
                    ),
                  ),

                  SizedBox(height: 10),  

                  Text(
                    "Week ${_currentWeek} - Day ${_currentDay}",
                    style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                      color: Colors.red[600],
                    ),
                  ),
                  
                  SizedBox(height: 10),   

                  // Daily Requirements
                  Container(
                    height:  displayHeight(context)*0.08,
                    width: displayWidth(context)*0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black87.withOpacity(0.12),
                          blurRadius: 5.0,
                          spreadRadius: 1.1,
                        )
                      ],
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child:  Material(
                      color:  Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.red[200],
                        onTap: () {
                          Navigator.pushNamed(context, '/admin_daily_requirements', arguments: {'selectedDay': _currentDay.toString(), 'selectedWeek': _currentWeek.toString(), 'selectedCategory': _currentCategory});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                                'Daily Requirements',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 26,
                                    color: Colors.red[400]
                                  ),
                              ),
                          ]),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 15),    
                  
                  _loadDailyRequirements(),
              
                  SizedBox(height: 15),      

                  //Exercises
                  _loadDailyExercises(),
                  
                  SizedBox(height: displayHeight(context)*0.12),      
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, '/add_daily_exercise', arguments: {'currentDay': _currentDay.toString(), 'currentWeek': _currentWeek.toString(), 'currentCategory':_currentCategory });
        },
      ),
    );
  }
}