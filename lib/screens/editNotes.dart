import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/controllers/authcontroller.dart';
import 'package:todo_app/models/notesmodel.dart';
import 'package:todo_app/services/database.dart';
import 'package:todo_app/widgets/addNotes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class EditNotes extends StatefulWidget {
  String initalContentValue;
  String initalTitleValue;
  final NotesModel notesModel;
  EditNotes(
      {Key key,
      this.initalContentValue,
      this.notesModel,
      this.initalTitleValue})
      : super(key: key);

  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  final AuthController _authController = Get.put(AuthController());
  Widget flotingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (Get.context.mediaQueryViewInsets.bottom != 0 &&
            widget.initalContentValue != '') {
          Database().updateNotes(
              widget.initalTitleValue,
              widget.initalContentValue,
              _authController.user.uid,
              widget.notesModel.notesId);
          Get.snackbar('Notes Updated', 'Your notes are modified.',
              icon: Icon(FontAwesomeIcons.pen),
              snackPosition: SnackPosition.BOTTOM,
              overlayBlur: 0.5,
              duration: Duration(milliseconds: 800));
        } else {
          Database()
              .deleteNotes(widget.notesModel.notesId, _authController.user.uid);

          Get.snackbar('Note Deleted', 'Your notes are important.',
              icon: Icon(FontAwesomeIcons.pen),
              snackPosition: SnackPosition.BOTTOM,
              overlayBlur: 0.5,
              duration: Duration(milliseconds: 800));
        }
      },
      backgroundColor: Colors.deepPurple[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      tooltip:
          (Get.context.mediaQueryViewInsets.bottom != 0) ? 'Update' : 'Delete',
      child: (Get.context.mediaQueryViewInsets.bottom != 0 &&
              widget.initalContentValue != '')
          ? Icon(FontAwesomeIcons.check)
          : Icon(FontAwesomeIcons.trash),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: bottomAppBar(context),
      floatingActionButton: flotingButton(context),
      floatingActionButtonLocation:
          (MediaQuery.of(context).viewInsets.bottom == 0)
              ? FloatingActionButtonLocation.centerDocked
              : FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      backgroundColor: Colors.deepPurple[100],
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 800),
        child: AddNotes(
          intialTitleValue: widget.initalTitleValue,
          onChangedTi: (value) {
            if (value != '') {
              setState(() {
                widget.initalTitleValue = value;
              });
            } else if (value == '') {
              setState(() {
                widget.initalTitleValue = value;
              });
            }
          },
          intialContentValue: widget.initalContentValue,
          onChangedCon: (value) {
            if (value != '') {
              setState(() {
                widget.initalContentValue = value;
              });
            } else if (value == '') {
              setState(() {
                widget.initalContentValue = value;
              });
            }
          },
        ),
        switchOutCurve: Curves.easeInOutCubic,
        switchInCurve: Curves.fastLinearToSlowEaseIn,
        transitionBuilder: (Widget child, Animation<double> animation) =>
            ScaleTransition(
          scale: animation,
          child: child,
        ),
      ),
    );
  }
}
