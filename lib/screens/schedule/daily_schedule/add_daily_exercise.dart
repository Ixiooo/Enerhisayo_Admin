import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enerhisayo_admin/models/DailyExercises.dart';
import 'package:enerhisayo_admin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddDailyExercise extends StatefulWidget {

  static const routeName = '/add_daily_exercise';

  const AddDailyExercise({ Key? key }) : super(key: key);

  @override
  State<AddDailyExercise> createState() => _AddDailyExerciseState();

}

class _AddDailyExerciseState extends State<AddDailyExercise> {

  final _addDailyExerciseFormKey = GlobalKey<FormState>(); 
  
  // Variable Declarations
  int _count = 0;
  int _repCount = 0;
  int _restSecs = 0;
  int _durationSecs = 0;

  int _currentDay = 0;
  int _currentWeek = 0;
  String _currentCategory = '';

  var _exerciseNameDropdown;


  // Add Exercise to Database
  Future _addDailyExercise() async{

    final isValid = _addDailyExerciseFormKey.currentState!.validate();

    if (!isValid){
      Utils.showToast('Please Fill up the Necessary Fields');
      return;
    } else if(_exerciseNameDropdown == '' || _exerciseNameDropdown == null){
      Utils.showToast('Please Fill up the Necessary Fields');
      return;
    }

    
    _addDailyExerciseFormKey.currentState!.save();

    try{
      FocusScope.of(context).unfocus();


      final docDailyExerciseRef = FirebaseFirestore.instance.collection('schedule').doc();
      final warmupExerciseData = DailyExercises(
        id: docDailyExerciseRef.id,
        day: _currentDay,
        week: _currentWeek,
        category: _currentCategory,
        exerciseName: _exerciseNameDropdown,
        count: _count,
        repCount: _repCount,
        restSecs: _restSecs,
        durationSecs:_durationSecs
      );
      
      final warmupExerciseDataJson = warmupExerciseData.toJson();

      await docDailyExerciseRef.set(warmupExerciseDataJson);

      Utils.showToast('Daily Exercise added successfully');
      Navigator.pop(context);

    } catch (e){
      Utils.showToast(e.toString());
    }
  }

  // Load Exercises Name to Dropdown
  Widget _loadExerciseNameDropdown() {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: const [
                Text(
                  'Daily Exercise Name',
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
        FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('exercises')
              .orderBy('exerciseName')
              .get(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Container();

            return DropdownButton(
              isExpanded: true,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              value: _exerciseNameDropdown,
              items: snapshot.data!.docs.map((value) {
                return DropdownMenuItem(
                  value: value.get('exerciseName'),
                  child: Text('${value.get('exerciseName')}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(
                  () {
                    _exerciseNameDropdown = value;
                  },
                );
              },
            );
          },
        ),
      ],
    );
                    
  }

  // Form for Adding Exercise
  Widget _addDailyExerciseForm(){
     return ListView(
                physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [ 
                    Form(
                    key: _addDailyExerciseFormKey,
                    child: Column(
                      children: [

                        _loadExerciseNameDropdown(),

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
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          enableSuggestions: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            hintText: 'Duration (Secs)'
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty ? 'Enter Duration ' : null,
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
  
  // Run the Functions after Startup but before the build method 
  @override
  void didChangeDependencies(){
    final screenData = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    _currentDay = int.parse(screenData['currentDay']!);
    _currentWeek = int.parse(screenData['currentWeek']!);
    _currentCategory =  screenData['currentCategory']!;

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
        title: Text('Add Daily Exercise'),
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
                _addDailyExercise();
                //  checkExist('High Knee March');
              });
            }, 
          )
        ],
      ),

      body:SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.only(top:15, left: 15, right: 15,),
          child: _addDailyExerciseForm()
        ),
      ),
      
    );
  }
  
}