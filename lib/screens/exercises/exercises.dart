import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enerhisayo_admin/models/Exercises.dart';
import 'package:flutter/material.dart';

class AdminExercisePage extends StatefulWidget {

  static const routeName = '/admin_exercises';

  const AdminExercisePage({ Key? key }) : super(key: key);

  @override
  State<AdminExercisePage> createState() => _AdminExercisePageState();

}

class _AdminExercisePageState extends State<AdminExercisePage> {

  // Variable Declarations
  bool isLoaded = false;
  int exerciseCount = 0;

  Stream exerciseListData = FirebaseFirestore.instance.collection('exercises').orderBy('exerciseName').snapshots();
  
  Stream<List <Exercise>> _exerciseCountStream() => 
    FirebaseFirestore.instance.collection('exercises')
      .snapshots()
      .map((snapshot) 
      => snapshot.docs.map((doc) => Exercise.fromJson(doc.data())).toList());

  Stream<List <Exercise>> readExercises() => FirebaseFirestore.instance.collection('exercises').orderBy('exerciseName').snapshots().map((snapshot) 
                                          => snapshot.docs.map((doc) => Exercise.fromJson(doc.data())).toList());

  // Load the Exercises from Database
  Widget _loadExercises(){
    return StreamBuilder<List<Exercise>>(
      stream:  readExercises(),
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
                children: data.map(_buildExercises).toList(),
            );
          }
        }
              
        return Container(child: CircularProgressIndicator());
      },
    );
  }

  // Build UI for Loaded Exercises
  Widget _buildExercises(Exercise exercises){
    bool hasVideo = false;
    if(exercises.videoUrl != ''){
      hasVideo=true;
    }else{
      hasVideo = false;
    }

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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:  5),
                child: ListTile(
                  onTap: (){
                    Navigator.of(context).pushNamed('/edit_exercise', arguments: {'exerciseId': exercises.id, 'exerciseName': exercises.exerciseName});
                  },
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
                  ),
                  trailing: hasVideo
                  ?Icon(
                    Icons.video_collection,
                    color: Colors.red[400],
                  )
                  :null,
                ),
              ),
            ),
          ),
        ],
      );
  }

  // Get Number of Exercises
  Widget _loadExerciseCount(){
    return StreamBuilder<List<Exercise>>(
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
        title: Text('Exercises'),
      ),
      
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, '/add_exercise');
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
                    'Exercises', 
                    style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 42,
                        color: Colors.red[600],
                      ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _loadExerciseCount(),
              const SizedBox(height: 15),
              _loadExercises(),
              const SizedBox(height: 30),
            ],
          )
        ),
      )
      :Container(),
      
    );
  }
  
}