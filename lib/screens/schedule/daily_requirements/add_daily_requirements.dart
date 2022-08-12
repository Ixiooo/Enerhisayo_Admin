import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enerhisayo_admin/models/DailyRequirements.dart';
import 'package:enerhisayo_admin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddDailyRequirements extends StatefulWidget {

  static const routeName = '/add_daily_requirements';

  const AddDailyRequirements({ Key? key }) : super(key: key);

  @override
  State<AddDailyRequirements> createState() => _AddDailyRequirementsState();

}

class _AddDailyRequirementsState extends State<AddDailyRequirements> {

  // Variable Declarations
  final _addDailyRequirementsFormKey = GlobalKey<FormState>(); 
  
  int _requiredMins = 0;
  int _minExercises = 0;

  int _currentDay = 0;
  int _currentWeek = 0;
  String _currentCategory = '';


  // Add Daily Requirements to Database
  Future _addDailyRequirements() async{

    final isValid = _addDailyRequirementsFormKey.currentState!.validate();

    if (!isValid){
      Utils.showToast('Please Fill up the Necessary Fields');
      return;
    }

    
    _addDailyRequirementsFormKey.currentState!.save();

    try{
      FocusScope.of(context).unfocus();


      final docDailyRequirementsRef = FirebaseFirestore.instance.collection('dailyRequirements').doc();
      final warmupExerciseData = DailyRequirements(
        id: docDailyRequirementsRef.id,
        day: _currentDay,
        week: _currentWeek,
        category: _currentCategory,
        minExercises: _minExercises,
        requiredMins: _requiredMins,
      );
      
      final warmupExerciseDataJson = warmupExerciseData.toJson();

      await docDailyRequirementsRef.set(warmupExerciseDataJson);

      Utils.showToast('Daily Exercise added successfully');
      Navigator.pop(context);

    } catch (e){
      Utils.showToast(e.toString());
    }
  }

  // Form for Adding Daily Requirements 
  Widget _addDailyRequirementsForm(){
     return ListView(
                physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [ 
                    Form(
                    key: _addDailyRequirementsFormKey,
                    child: Column(
                      children: [

                        // Exercises
                        Row(
                          children: [
                            Column(
                              children: const [
                                Text(
                                  'Required Exercises',
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
                            hintText: 'Required Exercises'
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty ? 'Enter Required Exercises' : null,
                          onSaved: (value) => setState((){
                            _minExercises = int.parse(value!);
                          }),
                        ),

                        SizedBox(height: 15), 

                         // Required Time (Mins)
                        Row(
                          children: [
                            Column(
                              children: const [
                                Text(
                                  'Required Time (Mins)',
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
                            hintText: 'Required Time (Mins)'
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty ? 'Enter Required Time' : null,
                          onSaved: (value) => setState((){
                            _requiredMins = int.parse(value!);
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
        title: Text('Add Requirement'),
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
                _addDailyRequirements();
                //  checkExist('High Knee March');
              });
            }, 
          )
        ],
      ),

      body:SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.only(top:15, left: 15, right: 15,),
          child: _addDailyRequirementsForm()
        ),
      ),
      
    );
  }
  
}