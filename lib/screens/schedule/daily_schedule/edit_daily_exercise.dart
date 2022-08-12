import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enerhisayo_admin/models/DailyExercises.dart';
import 'package:enerhisayo_admin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditDailyExercise extends StatefulWidget {

  static const routeName = '/edit_daily_exercises';

  const EditDailyExercise({ Key? key }) : super(key: key);

  @override
  State<EditDailyExercise> createState() => _EditDailyExerciseState();

}

class _EditDailyExerciseState extends State<EditDailyExercise> {

  // Variable Declarations
  final _updateDailyExerciseFormKey = GlobalKey<FormState>(); 

  String _selectedExerciseId = '';
    
  int _count = 0;
  int _repCount = 0;
  int _restSecs = 0;
  int _durationSecs = 0;

  String _currentExerciseName = '';
  bool isLoaded = false;

  // Delete Daily Exercise from Database
  Future _deleteDailyExercise() async{

    try{
      FocusScope.of(context).unfocus();

      final docExerciseData = FirebaseFirestore.instance.collection('schedule').doc(_selectedExerciseId);
      await docExerciseData.delete();

      
      Utils.showToast('Schedule Deleted Successfully');

    } catch (e){
      Utils.showToast(e.toString());
    }
  }

  // Update Daily Exercise from Database
  Future _updateDailyExercise() async{

    final isValid = _updateDailyExerciseFormKey.currentState!.validate();

    if (!isValid){
      Utils.showToast('Please Fill up the Necessary Fields');
      return;
    } 

    try{
      _updateDailyExerciseFormKey.currentState!.save();

      FocusScope.of(context).unfocus();

      final docExerciseData = FirebaseFirestore.instance.collection('schedule').doc(_selectedExerciseId);
      await docExerciseData.update({
         'count' : _count,
         'repCount' : _repCount,
         'durationSecs' : _durationSecs,
         'restSecs' : _restSecs,
      });

      Utils.showToast('Schedule updated successfully');
      Navigator.pop(context);

    } catch (e){
      Utils.showToast(e.toString());
    }
  }

  // Form for Editing Daily Exercise
  Widget _editDailyExerciseForm(){
     return ListView(
                physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [ 
                    Form(
                    key: _updateDailyExerciseFormKey,
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
                          enabled: false,
                          initialValue: _currentExerciseName,
                          // controller: firstNameController..text=_currentExerciseName,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          enableSuggestions: false,
                          decoration: const InputDecoration(
                            hintText: 'Exercise Name'
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty ? 'Enter Exercise Name' : null,
                          onSaved: (value) => setState((){
                            _currentExerciseName = value!;
                          }),
                        ),

                        SizedBox(height: 15), 

                        // Count
                        Row(
                          children: [
                            Column(
                              children: const [
                                Text(
                                  'Count',
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
                          initialValue: _count.toString(),
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          enableSuggestions: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            hintText: 'Count'
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty ? 'Enter Count' : null,
                          onSaved: (value) => setState((){
                            _count = int.parse(value!);
                          }),
                        ),

                        SizedBox(height: 15), 

                         // Rep Count
                        Row(
                          children: [
                            Column(
                              children: const [
                                Text(
                                  'Rep Count',
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
                          initialValue: _repCount.toString(),
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          enableSuggestions: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            hintText: 'Rep Count'
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty ? 'Enter Rep Count' : null,
                          onSaved: (value) => setState((){
                            _repCount = int.parse(value!);
                          }),
                        ),

                        SizedBox(height: 15), 

                        // Duration Secs
                        Row(
                          children: [
                            Column(
                              children: const [
                                Text(
                                  'Duration (Secs)',
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
                          initialValue: _durationSecs.toString(),
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          enableSuggestions: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            hintText: 'Duration (Secs)'
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty ? 'Enter Duration' : null,
                          onSaved: (value) => setState((){
                            _durationSecs = int.parse(value!);
                          }),
                        ),

                        SizedBox(height: 15), 

                        // Rest Secs
                        Row(
                          children: [
                            Column(
                              children: const [
                                Text(
                                  'Rest Time (Secs)',
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
                          initialValue: _restSecs.toString(),
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          enableSuggestions: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            hintText: 'Rest Time (Secs)'
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty ? 'Enter Rest Time' : null,
                          onSaved: (value) => setState((){
                            _restSecs = int.parse(value!);
                          }),
                        ),

                        SizedBox(height: 15), 
                      ],
                    ),
                  ),
              ],
            );

  }

  //Promp Asking User if the user really wants to delete
  Future<void> _deleteAlertDialog() async{
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Exercise"),
          content: Text("Are you sure you want to delete this Schedule?"),
          actions: [
            TextButton(
              child: Text("Yes"),
              onPressed:  () {
                _deleteDailyExercise();
                Navigator.popUntil(context, ModalRoute.withName('/daily_schedule'));
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed:  () {
                Navigator.of(context).pop();  
              },
            ),
          ]
        );
      }
    );
  }

  //Get Data of Current Exercise
  void _getdata() async {

    final data = FirebaseFirestore.instance.collection('schedule').doc(_selectedExerciseId);
    final snapshot = await data.get();

    DailyExercises warmupExerciseData = DailyExercises.fromJson(snapshot.data()!);
    _currentExerciseName = warmupExerciseData.exerciseName;
    _count = warmupExerciseData.count;
    _repCount = warmupExerciseData.repCount;
    _restSecs = warmupExerciseData.restSecs;
    _durationSecs = warmupExerciseData.durationSecs;

    setState(() {
      isLoaded = true;
    });
  }
  
  // Run the Functions on Startup
  @override
  void initState() {
    super.initState();    

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final screenData = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      _selectedExerciseId = screenData['dailyExerciseId']!;

      _getdata();
    });
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
        title: Text('Edit Schedule'),
        actions: [
          TextButton(
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600
              )
            ),
            onPressed: (){
              setState(() {
                _deleteAlertDialog();
              });
            }, 
          ),
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
                _updateDailyExercise();
              });
            }, 
          )
        ],
      ),

      body: isLoaded
      ?SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.only(top:15, left: 15, right: 15,),
          child: _editDailyExerciseForm()
        ),
      )
      :Container(),
      
    );
  }
  
}