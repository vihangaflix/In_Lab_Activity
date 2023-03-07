import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController listofingredientsController = TextEditingController();


  addRecepie() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    String uid = currentUser!.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection("recepieces")
        .doc(uid)
        .collection("recepie")
        .doc(time.toString())
        .set({
      "title": titleController.text,
      "description": descriptionController.text,
      "ingredients": listofingredientsController.text,
      "time": time
    });
    Fluttertoast.showToast(msg: "Recepie Added");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Recepie")),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
           TextField(
            controller: titleController,
            decoration: const InputDecoration(
                labelText: "Enter Title", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
           TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
                labelText: "Enter Description", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
           TextField(
            controller: listofingredientsController,
            decoration: const InputDecoration(
                labelText: "Enter Ingredients", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.purple.shade100;
                }
                return Theme.of(context).primaryColor;
              })),
              child: Text(
                "Add Recepie",
                style: GoogleFonts.roboto(fontSize: 18),
              ),
              onPressed: () {
                addRecepie();
              },
            ),
          )
        ]),
      ),
    );
  }
}
