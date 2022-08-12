import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enerhisayo_admin/models/WarmupExercises.dart';
import 'package:flutter/material.dart';

class AdminWarmupPage extends StatefulWidget {

  static const routeName = '/admin_warmup_exercises';

  const AdminWarmupPage({ Key? key }) : super(key: key);

  @override
  State<AdminWarmupPage> createState() => _AdminWarmupPageState();

}

class _AdminWarmupPageState extends State<AdminWarmupPage> {

  // Variable Declarations
  bool isLoaded = false;
  int exerciseCount = 0;
  Stream exerciseListData = FirebaseFirestore.instance.collection('warmupExercises').orderBy('exerciseName').snapshots();
  
  Stream<List <WarmupExercises>> _exerciseCountStream() => 
    FirebaseFirestore.instance.collection('warmupExercises')
      .snapshots()
      .map((snapshot) 
      => snapshot.docs.map((doc) => WarmupExercises.fromJson(doc.data())).toList());

  Stream<List <WarmupExercises>> readWarmups() => FirebaseFirestore.instance.collection('warmupExercises').orderBy('exerciseName').snapshots().map((snapshot) 
                                          => snapshot.docs.map((doc) => WarmupExercises.fromJson(doc.data())).toList());

  // Load Warmup Exercises from Database
  Widget _loadWarmups(){
    return StreamBuilder<List<WarmupExercises>>(
      stream:  readWarmups(),
      builder: (context, snapshot,){
        if(snapshot.hasError){
          return Text('Something Went Wrong ${snapshot.error}');
        }
        else if(snapshot.hasData){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
            
          } else{
            final data = snapshot.data!;

            return ListView(
              physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: data.map(_buildWarmups).toList(),
            );
          }
        }
              
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  // Build UI for Loaded Warmup Exercises
  Widget _buildWarmups(WarmupExercises exercises){

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
                  exercises.exerciseName,
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
                  '${exercises.count} Counts - ${exercises.durationSecs} Seconds',
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
                  Navigator.of(context).pushNamed('/edit_warmup_exercise', arguments: {'warmupExerciseId': exercises.id});
                },
              ),
            ),
          ),
        ],
      );
    }

  // Get Number of Warmup Exercises
  Widget _loadExerciseCount(){
    return StreamBuilder<List<WarmupExercises>>(
      stream: _exerciseCountStream(),
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
                children: [
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
                            Icon(Icons.fitness_center_outlined, color: Color(0xff074AAB),),
                            const SizedBox(width: 7),
                            Text('${data.length} Exercises', style: TextStyle(color:Color(0xff074AAB), fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
            );
          }

        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  // Run the Functions after Startup but before the build method 
  @override
  void didChangeDependencies(){
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
        title: Text('Warmup Exercises'),
      ),
      
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, '/add_warmup_exercise');
        },
      ),
      body: isLoaded
      ?SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.only(top:15, left: 15, right: 15,),
          child: Column(
            children: [
              SizedBox(height: 15),    

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  
                  Text(
                    'Warmup Exercises', 
                    style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 36,
                        color: Colors.red[600],
                      ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _loadExerciseCount(),
              const SizedBox(height: 15),
              _loadWarmups(),
              const SizedBox(height: 30),
            ],
          )
        ),
      )
      :Container(),
      
    );
  }
  
}