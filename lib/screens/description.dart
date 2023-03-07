import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Description extends StatefulWidget {
  const Description(
      {super.key,
      required this.title,
      required this.description,
      required this.time, 
      required this.ingredients});
  final String title, description, time, ingredients;

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController listofingredientsController = TextEditingController();


  updateRecepie() async {
    if (titleController.text.isEmpty) {
      titleController.text = widget.title;
    }
    if (descriptionController.text.isEmpty) {
      descriptionController.text = widget.description;
    }
    if (listofingredientsController.text.isEmpty) {
      listofingredientsController.text = widget.ingredients;
    }
    
    var currentUser = FirebaseAuth.instance.currentUser;
    String uid = currentUser!.uid;
    var newTime = DateTime.now();
    await FirebaseFirestore.instance
        .collection("recepieces")
        .doc(uid)
        .collection("recepie")
        .doc(widget.time)
        .update({
      "title": titleController.text,
      "description": descriptionController.text,
      "ingredients": listofingredientsController.text,
      "timestamp": newTime
    });
    Fluttertoast.showToast(msg: "Recepie Updated successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBar(title: const Text("Description")),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                  hintText: widget.title,
                  labelText: widget.title, border: const OutlineInputBorder()),
            ),
          ),
          Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: widget.description,

                    labelText: widget.description,
                    border: const OutlineInputBorder()),
              )),
              Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: listofingredientsController,
                decoration: InputDecoration(
                  hintText: widget.ingredients,

                    labelText: widget.ingredients,
                    border: const OutlineInputBorder()),
              )),
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
                "Update Recepie",
                style: GoogleFonts.roboto(fontSize: 18),
              ),
              onPressed: () {
                updateRecepie();
              },
            ),
          )
        ],
      ),
    );
  }
}
