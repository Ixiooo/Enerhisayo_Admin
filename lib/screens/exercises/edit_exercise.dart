import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enerhisayo_admin/models/Exercises.dart';
import 'package:enerhisayo_admin/utils/size_helpers.dart';
import 'package:enerhisayo_admin/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class EditExercise extends StatefulWidget {


  static const routeName = '/edit_exercise';

  const EditExercise({ 
    Key? key 
  }) : super(key: key);

  @override
  State<EditExercise> createState() => _EditExerciseState();

}

class _EditExerciseState extends State<EditExercise> {

  // Variable Declarations
  final _updateExerciseFormKey = GlobalKey<FormState>(); 
  Exercise? _currentExercise;
  String _selectedExerciseId = '';
  String _oldExerciseName = '';
  String _currentExerciseName = '';
  bool isLoaded = false;

  String videoUrl ='';
  String oldVideoUrl ='';
  bool hasVideo = false;
  bool isUrlLoaded = false;

  bool initialRun = true;

  FirebaseStorage storage = FirebaseStorage.instance;

  // Upload the Asset to Database
  Future<void> _uploadAsset(String inputSource) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery);

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        Reference reference = storage.ref('exercises/'+fileName);
        UploadTask uploadTask = storage.ref('exercises/'+fileName).putFile(imageFile, SettableMetadata(contentType: 'image/gif'));


        Utils.showToast('Uploading, Please Wait');
        uploadTask.whenComplete(()async{
          try{
            videoUrl = await reference.getDownloadURL();

            // Update the videoUrl
            try{
              FocusScope.of(context).unfocus();

              final docExerciseData = FirebaseFirestore.instance.collection('exercises').doc(_selectedExerciseId);
              await docExerciseData.update({
                'videoUrl' : videoUrl,
              });

              Utils.showToast('Asset Updated successfully');

            } catch (e){
              Utils.showToast(e.toString());
            }


            setState(() {
              hasVideo = true;
              isUrlLoaded = true;
              oldVideoUrl = videoUrl;
            });
          }catch(onError){
            print("Error");
          }
        });
        
      } on FirebaseException catch (error) {
        Utils.showToast(error.message.toString());
        print(error);
        
      }
    } catch (err) {
      print(err);
    }
  }

  // Change Existing Asset in Database
  Future<void> _changeAsset(String inputSource) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery);

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        
        await storage.refFromURL(oldVideoUrl).delete();

        Reference reference = storage.ref('exercises/'+fileName);
        UploadTask uploadTask = storage.ref('exercises/'+fileName).putFile(imageFile, SettableMetadata(contentType: 'image/gif'));

        Utils.showToast('Uploading, Please Wait');
        uploadTask.whenComplete(()async{
          try{
            videoUrl = await reference.getDownloadURL();

            // Update the videoUrl
            try{
              FocusScope.of(context).unfocus();

              final docExerciseData = FirebaseFirestore.instance.collection('exercises').doc(_selectedExerciseId);
              await docExerciseData.update({
                'videoUrl' : videoUrl,
              });

              Utils.showToast('Asset Updated successfully');

            } catch (e){
              Utils.showToast(e.toString());
            }


            setState(() {
              hasVideo = true;
              isUrlLoaded = true;
              oldVideoUrl = videoUrl;
            });
          }catch(onError){
            print("Error");
          }
        });
      
      } on FirebaseException catch (error) {
        Utils.showToast(error.message.toString());
        print(error);
      }

    } catch (err) {
      print(err);
    }
  }

  // Load Existing Asset to App
  Future<QuerySnapshot<Map<String,dynamic>>> _loadAsset() async {
    final getExerciseData = FirebaseFirestore.instance
                                            .collection("exercises")
                                            .where("exerciseName", isEqualTo: _oldExerciseName);
    final getExerciseDataSnapshot = await getExerciseData.get();

    return getExerciseDataSnapshot;
  }
  
  // Delete Existing Asset in Database
  Future<void> _deleteAsset(String ref) async {
    
    Utils.showToast('Deleting Asset, Please Wait');
    await storage.refFromURL(ref).delete();
    // Rebuild the UI
    setState(() {
      hasVideo=false;
    });
  }

  // Delete Exercise from Database
  Future _deleteExercise() async{

    try{
      FocusScope.of(context).unfocus();

      final docExerciseData = FirebaseFirestore.instance.collection('exercises').doc(_selectedExerciseId);
      await docExerciseData.delete();

      await FirebaseFirestore.instance.collection('warmupExercises')
        .where('exerciseName', isEqualTo: _oldExerciseName)
        .get()
        .then((value)=> value.docs.forEach((doc) { 
            doc.reference.delete();
          })
        );

      await FirebaseFirestore.instance.collection('schedule')
        .where('exerciseName', isEqualTo: _oldExerciseName)
        .get()
        .then((value)=> value.docs.forEach((doc) { 
            doc.reference.delete();
          })
        );
      if(hasVideo){
        await storage.refFromURL(videoUrl).delete();
      }
      Utils.showToast('Exercise Deleted Successfully');

    } catch (e){
      // Utils.showToast(e.toString());
      print(e.toString());
    }
  }

  // Update Exercise to Database
  Future _updateExercise() async{

    final isValid = _updateExerciseFormKey.currentState!.validate();

    if (!isValid){
      Utils.showToast('Please Fill up the Necessary Fields');
      return;
    } 

    try{
      _updateExerciseFormKey.currentState!.save();

      FocusScope.of(context).unfocus();

      final docExerciseData = FirebaseFirestore.instance.collection('exercises').doc(_selectedExerciseId);
      await docExerciseData.update({
         'exerciseName' : _currentExerciseName,
      });

      await FirebaseFirestore.instance.collection('warmupExercises')
        .where('exerciseName', isEqualTo: _oldExerciseName)
        .get()
        .then((value)=> value.docs.forEach((doc) { 
            doc.reference.update({'exerciseName': _currentExerciseName});
          })
        );

      await FirebaseFirestore.instance.collection('schedule')
        .where('exerciseName', isEqualTo: _oldExerciseName)
        .get()
        .then((value)=> value.docs.forEach((doc) { 
            doc.reference.update({'exerciseName': _currentExerciseName});
          })
        );


      Utils.showToast('Exercise updated successfully');
      Navigator.pop(context);

    } catch (e){
      Utils.showToast(e.toString());
    }
  }

  // Form for Editing Exercise
  Widget _editExerciseForm(){
     return ListView(
                physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [ 
                    Form(
                    key: _updateExerciseFormKey,
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
                          initialValue: _currentExerciseName,
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

                        // Exercise Gif
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                          child: Container(
                            width: displayHeight(context)*0.3,
                            height: displayHeight(context)*0.4,
                            // child: _loadExercisesGif(videoUrl)
                            child:_loadExercisesFuture(),
                            
                          ),
                        ),

                        hasVideo
                        ?Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _changeAsset('gallery'),
                              icon: const Icon(Icons.upload_outlined),
                              label: const Text('Change')),
                              SizedBox(width: 30),
                            ElevatedButton.icon(
                              onPressed: () => _deleteAsset(videoUrl),
                              icon: const Icon(Icons.delete),
                              label: const Text('Delete')),
                          ],
                        )
                        :ElevatedButton.icon(
                          onPressed: () => _uploadAsset('gallery'),
                          icon: const Icon(Icons.upload_outlined),
                          label: const Text('Upload')),

                      ],
                    ),
                  ),
              ],
            );

  }

  // Load Existing Asset to UI
  Widget _loadExercisesFuture(){
    return hasVideo
    ?isUrlLoaded
      ?FutureBuilder(
        future: _loadAsset(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
                final List<QueryDocumentSnapshot<Map<String, dynamic>>> image =
                    snapshot.data!.docs;
            return _loadExercisesGif(image.first.data()['videoUrl']);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
      :Center(
        child: CircularProgressIndicator(),
      )
    :Center(
      child: Text(
        'No Video Available',
      )
    );
  }

  //Load the Asset of Selected Exercise
  Widget _loadExercisesGif(String url){
    return hasVideo
    ?isUrlLoaded
      ?Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(255, 151, 151, 151),
            width: 1
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: 
          CachedNetworkImage(
            placeholder: (context, url) => Center(child: const CircularProgressIndicator()),
            errorWidget: (context, url, error) => Center(child: Text('Video Failed to Load, Check Your Network Connection')),
            imageUrl: url,
            fit:BoxFit.fill,
          )
        ),
      )
      :Center(
        child: CircularProgressIndicator(),
      )
    :Center(
      child: Text(
        'No Video Available',
      )
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
          content: Text("Are you sure you want to delete this exercise?"),
          actions: [
            TextButton(
              child: Text("Yes"),
              onPressed:  () {
                hasVideo = false;
                _deleteExercise();
                Navigator.popUntil(context, ModalRoute.withName('/admin_exercises'));
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

  //Set the Video URL of Current Video
  void _setVideoURL()async{

    final getExerciseData = FirebaseFirestore.instance
                                            .collection("exercises")
                                            .where("exerciseName", isEqualTo: _oldExerciseName);
    final getExerciseDataSnapshot = await getExerciseData.get();
    if(getExerciseDataSnapshot.docs.length > 0){
      _currentExercise = Exercise.fromJson(getExerciseDataSnapshot.docs[0].data());
      if(_currentExercise!.videoUrl == '' || _currentExercise!.videoUrl == null){
        setState(() {
          hasVideo=false;
        });
      }else{
        setState(() {
          hasVideo = true;
          videoUrl = _currentExercise!.videoUrl;
          oldVideoUrl = videoUrl;
          isUrlLoaded = true;
        });
      }
    }else {
      setState(() {
        hasVideo=false;
      });
    }
  }

  //Get Data of Current Exercise
  void _getdata() async {

    final data = FirebaseFirestore.instance.collection('exercises').doc(_selectedExerciseId);
    final snapshot = await data.get();

    Exercise exerciseData = Exercise.fromJson(snapshot.data()!);
    _currentExerciseName = exerciseData.exerciseName;
    setState(() {
      isLoaded = true;
    });
  }
  
  // Run the Functions after Startup but before the build method 
  @override
  void didChangeDependencies(){

    if(initialRun){
      final screenData = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      _selectedExerciseId = screenData['exerciseId']!;
      _oldExerciseName = screenData['exerciseName']!;

      _getdata();

      _setVideoURL();
      initialRun = false;
    }
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
        title: Text('Edit Exercise'),
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
                _updateExercise();
              });
            }, 
          )
        ],
      ),

      body: isLoaded
      ?SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.only(top:15, left: 15, right: 15,),
          child: _editExerciseForm()
        ),
      )
      :Container(),
      
    );
  }
  
}