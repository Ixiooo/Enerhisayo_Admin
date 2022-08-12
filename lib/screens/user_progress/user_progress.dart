import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enerhisayo_admin/models/Exercises.dart';
import 'package:enerhisayo_admin/models/UserData.dart';
import 'package:enerhisayo_admin/models/UserProgress.dart';
import 'package:enerhisayo_admin/screens/user_progress/user_info.dart';
import 'package:flutter/material.dart';

class UserProgressPage extends StatefulWidget {

  static const routeName = '/user_progress';

  const UserProgressPage({ Key? key }) : super(key: key);

  @override
  State<UserProgressPage> createState() => _UserProgressPageState();

}

class _UserProgressPageState extends State<UserProgressPage> {

  // Variable Declarations
  bool isLoaded = false;
  int exerciseCount = 0;

  Stream exerciseListData = FirebaseFirestore.instance.collection('users').orderBy('exerciseName').snapshots();
  
  Stream<List <UserProgress>> readUserProgress() => FirebaseFirestore.instance.collection('userProgress').orderBy('week').snapshots().map((snapshot) 
                                          => snapshot.docs.map((doc) => UserProgress.fromJson(doc.data())).toList());

  Widget _buildUserName(String docId){
    
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .orderBy('firstName')
          .where('id', isEqualTo: docId)
          .get(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData){
          return Text('');
        } 
        else{
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
            
          } else{
            final data = snapshot.data!.docs;

            return Text(
              '${data[0].data()['firstName']} ${data[0].data()['lastName']}'
            );
          }

        }
      },
    );
  }

  // Load the Exercises from Database
  Widget _loadUserProgress(){
    return StreamBuilder<List<UserProgress>>(
      stream:  readUserProgress(),
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
                children: data.map(_buildUserProgress).toList(),
            );
          }
        }
              
        return Container(child: CircularProgressIndicator());
      },
    );
  }

  // Build UI for Loaded UserProgress
  Widget _buildUserProgress(UserProgress userProgress){
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                  ),
                  title:  _buildUserName(userProgress.user_id),
                  subtitle: Text(
                    'Week: ${userProgress.week} || Day ${userProgress.day}',
                    style:Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xff074AAB),
                    )
                  ),
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserInfoPage(userId: userProgress.user_id)
                      )
                    );
                    
                  },
                ),
              ),
            ),
          ),
        ],
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
        title: Text('User Progress'),
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
                    'User Progress', 
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
              _loadUserProgress(),
              const SizedBox(height: 30),
            ],
          )
        ),
      )
      :Container(),
      
    );
  }
  
}