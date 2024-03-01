// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/notes.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';
import 'dart:html' as html;

class NotesCard extends StatelessWidget {
  final Note note;
  final VoidCallback onRemove;
  const NotesCard({super.key, required this.note, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.4))),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Added on: ${(note.dateUpdated ?? note.dateCreated).toString().split(".").first}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title:
                                const Text("Are you sure you want to delete?"),
                            actions: [
                              MaterialButton(
                                onPressed: onRemove,
                                child: const Text("yes"),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("No"),
                              ),
                            ],
                          );
                        });
                      });
                },
                icon: const Icon(Icons.delete),
              )
            ],
          ),
          const Divider(),
          note.attachment != null
              ? Row(
                  children: [
                    Text(
                      "Attachment: ${note.attachment!.filenameDownload}",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    MaterialButton(
                      onPressed: () async {
                        html.window.open(
                            "${BaseService.BASE_URL}/assets/${note.attachment!.id!}",
                            'new tab');
                      },
                      color: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.download,
                              color: Colors.white,
                              size: 12,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Download",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          const Text(
            "Note:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            "${note.content}",
          )
        ],
      ),
    );
  }
}
