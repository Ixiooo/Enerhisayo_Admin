import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enerhisayo_admin/models/WarmupExercises.dart';
import 'package:enerhisayo_admin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddWarmupExercises extends StatefulWidget {

  static const routeName = '/add_warmup_exercise';

  const AddWarmupExercises({ Key? key }) : super(key: key);

  @override
  State<AddWarmupExercises> createState() => _AddWarmupExercisesState();

}

class _AddWarmupExercisesState extends State<AddWarmupExercises> {

  // Variable Declarations
  final _addWarmupExerciseFormKey = GlobalKey<FormState>(); 
  
  int _count = 0;
  int _repCount = 0;
  int _restSecs = 0;
  int _durationSecs = 0;

  var _exerciseNameDropdown;


  // Add Warmup Exercise to Database
  Future _addWarmupExercise() async{

    final isValid = _addWarmupExerciseFormKey.currentState!.validate();

    if (!isValid){
      Utils.showToast('Please Fill up the Necessary Fields');
      return;
    } else if(_exerciseNameDropdown == '' || _exerciseNameDropdown == null){
      Utils.showToast('Please Fill up the Necessary Fields');
      return;
    }

    
    _addWarmupExerciseFormKey.currentState!.save();

    try{
      FocusScope.of(context).unfocus();


      final docWarmupExerciseRef = FirebaseFirestore.instance.collection('warmupExercises').doc();
      final warmupExerciseData = WarmupExercises(
        id: docWarmupExerciseRef.id,
        exerciseName: _exerciseNameDropdown,
        count: _count,
        repCount: _repCount,
        restSecs: _restSecs,
        durationSecs:_durationSecs
      );
      
      final warmupExerciseDataJson = warmupExerciseData.toJson();

      await docWarmupExerciseRef.set(warmupExerciseDataJson);

      Utils.showToast('Warmup Exercise added successfully');
      Navigator.pop(context);

    } catch (e){
      Utils.showToast(e.toString());
    }
  }

  // Load Warmup from Database
  Widget _loadExerciseNameDropdown() {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: const [
                Text(
                  'Warmup Exercise Name',
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

  // Form for Adding Warmup Exercise
  Widget _addWarmupExerciseForm(){
     return ListView(
                physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [ 
                    Form(
                    key: _addWarmupExerciseFormKey,
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
        title: Text('Add Warmup Exercise'),
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
                _addWarmupExercise();
                //  checkExist('High Knee March');
              });
            }, 
          )
        ],
      ),

      body:SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.only(top:15, left: 15, right: 15,),
          child: _addWarmupExerciseForm()
        ),
      ),
      
    );
  }
  
}