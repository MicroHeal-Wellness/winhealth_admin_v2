// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winhealth_admin_v2/models/notes.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';
import 'package:winhealth_admin_v2/services/note_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';
import 'package:http/http.dart' as http;

class EditNotesHome extends StatefulWidget {
  final Note note;
  const EditNotesHome({super.key, required this.note});

  @override
  State<EditNotesHome> createState() => _EditNotesHomeState();
}

class _EditNotesHomeState extends State<EditNotesHome> {
  TextEditingController noteController = TextEditingController();
  PlatformFile? selectedFile;
  bool loading = true;
  bool btnLoading = false;
  bool isOriginalFile = false;
  @override
  void initState() {
    super.initState();
    setInitData();
  }

  setInitData() {
    setState(() {
      loading = true;
    });
    noteController.text = widget.note.content ?? "";
    if (widget.note.attachment != null) {
      isOriginalFile = true;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      BackButton(),
                      SizedBox(
                        width: 32,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Edit Note",
                          style: TextStyle(
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
                  Row(
                    children: [
                      const Text(
                        "Attachment:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          if (isOriginalFile) {
                            setState(
                              () {
                                isOriginalFile = false;
                              },
                            );
                          } else {
                            setState(() {
                              selectedFile = null;
                            });
                          }
                        },
                        icon: const Icon(Icons.delete),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  isOriginalFile
                      ? Center(
                          child: Column(
                            children: [
                              const Text("Click to view the attachment"),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                    widget.note.attachment!.filenameDownload ??
                                        "File"),
                              ),
                            ],
                          ),
                        )
                      : Container(
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
                        Fluttertoast.showToast(msg: "Please fill note content");
                      } else {
                        Map payload = {
                          "content": noteController.text,
                        };
                        if (widget.note.attachment != null &&
                            isOriginalFile == false) {
                          final response =
                              await BaseService.makeAuthenticatedRequest(
                            '${BaseService.BASE_URL}/files/${widget.note.attachment!.id}',
                            method: 'DELETE',
                          );
                          if (response.statusCode == 204) {
                            payload['attachment'] = null;
                          } else {
                            Fluttertoast.showToast(
                                msg: "Error deleting original file.");
                          }
                        }
                        if (isOriginalFile == false) {
                          if (selectedFile != null) {
                            http.StreamedResponse response =
                                await BaseService.authenticatedFileUpload(
                                    selectedFile!);
                            if (response.statusCode == 200) {
                              var fileResponse =
                                  await response.stream.bytesToString();
                              var decodedFile = jsonDecode(fileResponse);
                              if (decodedFile['data']['id'] != null) {
                                payload['attachment'] =
                                    decodedFile['data']['id'];
                              }
                            }
                          }
                        }
                        bool resp = await NoteService.updateNote(
                            widget.note.id, payload);
                        if (resp) {
                          Fluttertoast.showToast(msg: "Note Updated");
                          Navigator.of(context).pop();
                        } else {
                          Fluttertoast.showToast(msg: "Something Went Wrong");
                        }
                      }
                    },
                    minWidth: double.infinity,
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: btnLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              "Update Note",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
