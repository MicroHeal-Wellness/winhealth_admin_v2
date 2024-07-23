import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winhealth_admin_v2/components/notes_card.dart';
import 'package:winhealth_admin_v2/models/notes.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/edit_notes.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';
import 'package:winhealth_admin_v2/services/note_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';
import 'package:http/http.dart' as http;

class NotesHome extends StatefulWidget {
  final UserModel patient;
  const NotesHome({
    super.key,
    required this.patient,
  });

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  bool showbtn = false;
  bool loading = false;
  List<Note> notes = [];
  ScrollController scrollController = ScrollController();
  TextEditingController noteController = TextEditingController();
  PlatformFile? selectedFile;
  @override
  void initState() {
    scrollController.addListener(() {
      //scroll listener
      double showoffset =
          10.0; //Back to top botton will show on scroll offset 10.0

      if (scrollController.offset > showoffset) {
        showbtn = true;
        setState(() {
          //update state
        });
      } else {
        showbtn = false;
        setState(() {
          //update state
        });
      }
    });
    getInitData();
    super.initState();
  }

  getInitData() async {
    setState(() {
      loading = true;
    });
    notes = await NoteService.fetchNotesByPatientId(widget.patient.id!);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100.withOpacity(0.4),
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: showbtn ? 1.0 : 0.0,
        child: FloatingActionButton(
          onPressed: () {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
          backgroundColor: primaryColor,
          child: const Icon(
            Icons.arrow_upward,
          ),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const BackButton(),
                        const SizedBox(
                          width: 32,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${widget.patient.firstName}'s Notes/Reports",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: notes.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No Notes",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return NotesCard(
                                        note: notes[index],
                                        onEdit: () async {
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditNotesHome(
                                                note: notes[index],
                                              ),
                                            ),
                                          );
                                          await getInitData();
                                        },
                                        onRemove: () async {
                                          Navigator.of(context).pop();
                                          bool resp =
                                              await NoteService.removeNote(
                                                  notes[index].id);
                                          if (!resp) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Something went wrong, try again later");
                                          } else {
                                            await getInitData();
                                          }
                                        });
                                  },
                                  itemCount: notes.length,
                                ),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Add New Note",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                "Content:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                controller: noteController,
                                validator: (value) {
                                  return (value!.isNotEmpty || value != null)
                                      ? null
                                      : "Note is required";
                                },
                                minLines: 5,
                                maxLines: 15,
                                decoration: const InputDecoration(
                                  hintText: 'Enter note content',
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                onChanged: (value) {},
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                "Attachment:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(width: 1),
                                ),
                                height: 200,
                                child: Center(
                                  child: MaterialButton(
                                    onPressed: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles();

                                      if (result != null) {
                                        // print(result.files.first.name);
                                        // print(result.files.first.bytes);

                                        // print(response.statusCode);
                                        setState(() {
                                          selectedFile = result.files.first;
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "No File Selected!",
                                        );
                                      }
                                    },
                                    child: Text(selectedFile != null
                                        ? "Selected File: ${selectedFile!.name}"
                                        : "Upload File"),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  if (noteController.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Please fill note content");
                                  } else {
                                    var payload = {
                                      "content": noteController.text,
                                      "patient": widget.patient.id,
                                    };
                                    if (selectedFile != null) {
                                      http.StreamedResponse response =
                                          await BaseService
                                              .authenticatedFileUpload(
                                                  selectedFile!);
                                      if (response.statusCode == 200) {
                                        var fileResponse = await response.stream
                                            .bytesToString();
                                        var decodedFile =
                                            jsonDecode(fileResponse);
                                        if (decodedFile['data']['id'] != null) {
                                          payload['attachment'] =
                                              decodedFile['data']['id'];
                                        }
                                      }
                                    }
                                    bool resp =
                                        await NoteService.addNote(payload);
                                    if (resp) {
                                      Fluttertoast.showToast(msg: "Note Added");
                                      await getInitData();
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Something Went Wrong");
                                    }
                                  }
                                },
                                minWidth: double.infinity,
                                color: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Text(
                                    "Add Note",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
