import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:it20192082_lab02/screens/add_task.dart';
import 'package:it20192082_lab02/screens/description.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = "";
  @override
  void initState() {
    getUid();
    super.initState();
  }

  getUid() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = currentUser!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Recepie"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("recepieces")
              .doc(uid)
              .collection("recepie")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final docs = snapshot.data!.docs;
              print(docs);
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  var time = (docs[index]["time"] as Timestamp).toDate();

                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Description(
                                    title: docs[index]["title"],
                                    description: docs[index]["description"],
                                    ingredients: docs[index]["ingredients"],
                                    time: docs[index]["time"])));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: const Color(0xff121211),
                            borderRadius: BorderRadius.circular(10)),
                        height: 90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      docs[index]["title"],
                                      style: GoogleFonts.roboto(fontSize: 18),
                                    )),
                                const SizedBox(height: 5),
                                Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      docs[index]["description"],
                                      style: GoogleFonts.roboto(fontSize: 18),
                                    )),
                                const SizedBox(height: 5),
                                Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      docs[index]["ingredients"],
                                      style: GoogleFonts.roboto(fontSize: 18),
                                    )),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                FirebaseFirestore.instance
                                    .collection("recepieces")
                                    .doc(uid)
                                    .collection("recepie")
                                    .doc(docs[index]["time"])
                                    .delete();
                              },
                            )
                          ],
                        ),
                      ));
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTask()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
