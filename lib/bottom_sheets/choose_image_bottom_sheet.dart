import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseImageBottomSheet {
  static void show({
    required BuildContext context,
    required Function onCancel,
    required Function onCamera,
    required Function onGallery,
  }) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext cont) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  onCamera();
                },
                child: Text(
                  'Use Camera',
                  style: GoogleFonts.roboto(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  onGallery();
                },
                child: Text(
                  'Gallery',
                  style: GoogleFonts.roboto(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                onCancel();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.roboto(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          );
        });
  }
}
