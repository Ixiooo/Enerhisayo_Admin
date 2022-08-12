import 'package:enerhisayo_admin/utils/size_helpers.dart';
import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {

  static const routeName = '/admin_schedule';

  const Schedule({ Key? key }) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();

}

class _ScheduleState extends State<Schedule> {
  
  // Variable Declarations
  List<Widget> _weeklyWorkoutList = [];
  String categoryDropdown = 'Overweight';

  double _screenHeight = 0;
  double _screenWidth = 0;
  bool _isSmallReso = false;

  bool isLoaded = false;

  // Generate Data for Weekly Exercises
  Widget _workoutWeek(int week){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
        children: [

          SizedBox(height: 10),

          Text(
            "Week ${week}",
            style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(
              fontWeight: FontWeight.w700,
              fontSize: !_isSmallReso
              ?32
              :28,
              color: Colors.red[400],
            ),
          ),
          
          SizedBox(height: 10),
          

        ],
    );
  }

  // Generate Data for Daily Exercises
  Widget _workOutDay(int day, int week){

    return 
    Column(
      children: [
        Row(
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height:  displayHeight(context)*0.08,
              width: displayWidth(context)*0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black87.withOpacity(0.12),
                    blurRadius: 5.0,
                    spreadRadius: 1.1,
                  )
                ]
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  splashColor: Colors.red[200],
                  onTap: () {
                      Navigator.of(context)
                      .pushNamed('/daily_schedule', arguments: {'selectedDay': day.toString(), 'selectedWeek': week.toString(), 'selectedCategory':categoryDropdown });
                      
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        // Day No. and No. of Exercises
                        Expanded(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Day ${day}',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: !_isSmallReso
                                    ?28
                                    :20,
                                    color: Colors.red[400],
                                  ),
                              )
                            ],
                          )
                        ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6)
      ],
    );
  }
  
  // Generate the Workout Based on the Subscription of User
  void _generateWorkout() {
    setState(() {
      // _weeklyWorkoutList.add(_workout());
      for(int weekCounter = 0; weekCounter < 4; weekCounter++){
        _weeklyWorkoutList.add(_workoutWeek(weekCounter+1));
        
        for(int dayCounter = 0; dayCounter < 6; dayCounter++){
          _weeklyWorkoutList.add(_workOutDay(dayCounter+1, weekCounter+1));
        }
      }
    });
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
  void didChangeDependencies(){
    _getScreenSize();
    _weeklyWorkoutList.clear();
    _generateWorkout();
    isLoaded = true;
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
        title: Text('Schedule'),
      ),
      body: isLoaded
      ?SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.only(top:15, left: 15, right: 15,),
          child: Column(
            children: [
              SizedBox(height: 15),  

              // Category Dropdown
              Row(
                children: [
                  Column(
                    children: const [
                      Text(
                        'Category',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              DropdownButton<String>(
                isExpanded: true,
                value: categoryDropdown,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.red,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    categoryDropdown = newValue!;
                  });
                },
                items: <String>['Overweight', 'Obese Class I', 'Obese Class II', 'Obese Class III']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              // Week Builder 
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _weeklyWorkoutList.length,
                  itemBuilder: (context,index){
                return _weeklyWorkoutList[index];
              }),

              const SizedBox(height: 30),

            ],
          )
        ),
      )
      :Container(),
      
    );
  }
  
}