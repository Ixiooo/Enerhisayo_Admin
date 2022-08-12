import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enerhisayo_admin/models/DailyRequirements.dart';
import 'package:enerhisayo_admin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditDailyRequirements extends StatefulWidget {

  static const routeName = '/edit_daily_requirements';

  const EditDailyRequirements({ Key? key }) : super(key: key);

  @override
  State<EditDailyRequirements> createState() => _EditDailyRequirementsState();

}

class _EditDailyRequirementsState extends State<EditDailyRequirements> {

  // Variable Declarations
  final _updateDailyExerciseFormKey = GlobalKey<FormState>(); 

  String _selectedRequirementId = '';
    
  int _minExercises = 0;
  int _requiredMins = 0;

  String _currentExerciseName = '';
  bool isLoaded = false;

  // Delete Daily Exercise from Database
  Future _deleteDailyExercise() async{

    try{
      FocusScope.of(context).unfocus();

      final docExerciseData = FirebaseFirestore.instance.collection('dailyRequirements').doc(_selectedRequirementId);
      await docExerciseData.delete();

      
      Utils.showToast('Requirements Deleted Successfully');

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

      final docExerciseData = FirebaseFirestore.instance.collection('dailyRequirements').doc(_selectedRequirementId);
      await docExerciseData.update({
         'minExercises' : _minExercises,
         'requiredMins' : _requiredMins
      });

      Utils.showToast('Requirements updated successfully');
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

                // Required Exercises
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
                  initialValue: _minExercises.toString(),
                  // controller: firstNameController..text=_currentExerciseName,
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
                    _minExercises = int.parse(value!) ;
                  }),
                ),

                SizedBox(height: 15), 

                // REquired Mins
                Row(
                  children: [
                    Column(
                      children: const [
                        Text(
                          'Required Time(Mins)',
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
                  initialValue: _requiredMins.toString(),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  enableSuggestions: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'Required Time(Mins)'
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

  //Promp Asking User if the user really wants to delete
  Future<void> _deleteAlertDialog() async{
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Requirements"),
          content: Text("Are you sure you want to delete this requirement?"),
          actions: [
            TextButton(
              child: Text("Yes"),
              onPressed:  () {
                _deleteDailyExercise();
                Navigator.popUntil(context, ModalRoute.withName('/admin_daily_requirements'));
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

    final data = FirebaseFirestore.instance.collection('dailyRequirements').doc(_selectedRequirementId);
    final snapshot = await data.get();

    DailyRequirements warmupExerciseData = DailyRequirements.fromJson(snapshot.data()!);
    _minExercises = warmupExerciseData.minExercises;
    _requiredMins = warmupExerciseData.requiredMins;

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
      _selectedRequirementId = screenData['dailyRequirementsId']!;

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
        title: Text('Edit Requirements'),
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