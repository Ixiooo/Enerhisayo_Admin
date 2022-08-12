import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enerhisayo_admin/models/Exercises.dart';
import 'package:enerhisayo_admin/utils/utils.dart';
import 'package:flutter/material.dart';

class AddExercise extends StatefulWidget {

  static const routeName = '/add_exercise';

  const AddExercise({ Key? key }) : super(key: key);

  @override
  State<AddExercise> createState() => _AddExerciseState();

}

class _AddExerciseState extends State<AddExercise> {

  // Variable Declarations
  final _addExerciseFormKey = GlobalKey<FormState>(); 
  String _currentExerciseName = '';

  // Add Exercise to Database
  Future _addExercise() async{

    final isValid = _addExerciseFormKey.currentState!.validate();

    if (!isValid){
      Utils.showToast('Please Fill up the Necessary Fields');
      return;
    } 

    try{
      _addExerciseFormKey.currentState!.save();

      FocusScope.of(context).unfocus();

      final docExerciseData = FirebaseFirestore.instance.collection('exercises').doc();
      final activityLogData = Exercise(
        id: docExerciseData.id,
        exerciseName: _currentExerciseName,
        videoUrl:'',
      );
      
      final activityLogDataJson = activityLogData.toJson();

      await docExerciseData.set(activityLogDataJson);

      Utils.showToast('Exercise added successfully');
      Navigator.pop(context);

    } catch (e){
      Utils.showToast(e.toString());
    }
  }

  // Form for Adding Exercise
  Widget _addExerciseForm(){
     return ListView(
                physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [ 
                    Form(
                    key: _addExerciseFormKey,
                    child: Column(
                      children: [

                        // Exercise Name
                        Row(
                          children: [
                            Column(
                              children: const [
                                Text(
                                  'Exercise Name',
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
                  
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          enableSuggestions: false,
                          decoration: const InputDecoration(
                            hintText: 'Exercise Name'
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty ? 'Exercise Name' : null,
                          onSaved: (value) => setState((){
                            _currentExerciseName = value!;
                          }),
                        ),

                        SizedBox(height: 15), 
                      
                      ],
                    ),
                  ),
              ],
            );

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
        title: Text('Add Exercise'),
        actions: [
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600
              )
            ),
            onPressed: (){
              setState(() {
                _addExercise();
              });
            }, 
          )
        ],
      ),

      body:SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.only(top:15, left: 15, right: 15,),
          child: _addExerciseForm()
        ),
      ),
      
    );
  }
  
}