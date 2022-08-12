import 'package:enerhisayo_admin/models/DailyRequirements.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../utils/size_helpers.dart';



class AdminDailyRequirements extends StatefulWidget {

  static const routeName = '/admin_daily_requirements';


  const AdminDailyRequirements({Key? key,}) : super(key: key);

  @override
  State<AdminDailyRequirements> createState() => _AdminDailyRequirementsState();
}

class _AdminDailyRequirementsState extends State<AdminDailyRequirements> {

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
  
  Stream<List <DailyRequirements>> _dailyRequirementsStream() => 
    FirebaseFirestore.instance.collection('dailyRequirements')
      .where('day', isEqualTo: _currentDay)
      .where('week', isEqualTo: _currentWeek)
      .where('category', isEqualTo: _currentCategory)
      .snapshots()
      .map((snapshot) 
      => snapshot.docs.map((doc) => DailyRequirements.fromJson(doc.data())).toList());

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

  // Build UI for Loaded Daily Requirements
  Widget _buildDailyRequirements(DailyRequirements dailyRequirements){
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
                  '${_currentCategory}: Week ${_currentWeek} - Day ${_currentDay}',
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
                  'Exercises: ${dailyRequirements.minExercises} || Minutes: ${dailyRequirements.requiredMins} Minutes',
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
                  Navigator.of(context).pushNamed('/edit_daily_requirements', arguments: {'dailyRequirementsId': dailyRequirements.id});
                },
              ),
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
        title: Text('Requirements'),
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
                    "Requirements",
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

                  _loadDailyRequirements(),
              
                  SizedBox(height: 15),      
                   
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, '/add_daily_requirements', arguments: {'currentDay': _currentDay.toString(), 'currentWeek': _currentWeek.toString(), 'currentCategory':_currentCategory });
        },
      ),
    );
  }
}