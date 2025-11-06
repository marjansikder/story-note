import 'package:date_calculator/models/notes_model.dart';
import 'package:date_calculator/providers/auth_provider.dart';
import 'package:date_calculator/providers/notes_provider.dart';
import 'package:date_calculator/utils/blank_page.dart';
import 'package:date_calculator/utils/colors.dart';
import 'package:date_calculator/utils/font_util.dart';
import 'package:date_calculator/utils/text_style.dart';
import 'package:date_calculator/utils/toast.dart';
import 'package:date_calculator/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class NotesPadScreen extends ConsumerStatefulWidget {
  const NotesPadScreen({super.key});

  @override
  ConsumerState<NotesPadScreen> createState() => _NotesPadScreenState();
}

class _NotesPadScreenState extends ConsumerState<NotesPadScreen> {
  final _headLineController = TextEditingController();
  final _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _headLineController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void doSearch(String query) {
    setState(() {
      _searchQuery = query.trim();
    });
  }

  void _showEdit(BuildContext context, {Note? note}) {
    if (note != null) {
      _headLineController
        ..text = note.title
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: _headLineController.text.length),
        );
      _descriptionController
        ..text = note.content
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: _descriptionController.text.length),
        );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(10), bottom: Radius.circular(10)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(sheetContext).padding.top,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFF3CD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          _buildTitleFieldRow(),
                          _buildDescriptionField(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: _buildBottomButtons(sheetContext, note),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      _headLineController.clear();
      _descriptionController.clear();
    });
  }

  Widget _buildTitleFieldRow() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8E1),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _headLineController,
              maxLines: 1,
              keyboardType: TextInputType.text,
              style: getCustomTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.kBrown),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kOrgHeader, width: 1),
                ),
                hintText: 'Title',
                hintStyle: getCustomTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey),
              ),
            ),
          ),
          if (_headLineController.text.isNotEmpty ||
              _descriptionController.text.isNotEmpty) ...[
            InkWell(
              onTap: () {
                final combinedText = _headLineController.text.isNotEmpty
                    ? '${_headLineController.text}\n${_descriptionController.text}'
                    : _descriptionController.text;
                Clipboard.setData(ClipboardData(text: combinedText)).then((_) {
                  Toast.showToast('All copied!');
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Image.asset(
                  "assets/icons/ic_copy_all.png",
                  scale: 24,
                  color: AppColors.kGreyButtonColor,
                ),
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8E1),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextField(
        controller: _descriptionController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: getTextStyle(15, FontWeight.normal, AppColors.kBlackColor),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something here',
          hintStyle: getTextStyle(13, FontWeight.normal, Colors.grey),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext sheetContext, Note? existingNote) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kSegmentButton,
                padding: const EdgeInsets.symmetric(vertical: 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.of(sheetContext).pop(),
              icon: Image.asset(
                'assets/icons/ic_arrow_back.png',
                height: 15,
                width: 15,
                color: AppColors.kWhiteColor,
              ),
              label: const Text(
                'Back',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kAccept,
                padding: const EdgeInsets.symmetric(vertical: 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                final headline = _headLineController.text.trim();
                final description = _descriptionController.text.trim();

                if (headline.isEmpty && description.isEmpty) {
                  Toast.showErrorToast('Empty field!');
                  return;
                }
                _saveNote(sheetContext, existingNote, headline, description);
              },
              icon: Image.asset(
                'assets/icons/ic_save.png',
                height: 13,
                width: 13,
                color: AppColors.kWhiteColor,
              ),
              label: const Text(
                'Save',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildNoteCard(BuildContext context, Note note) {
    return GestureDetector(
      onTap: () => _showEdit(context, note: note),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            _buildNoteTitleBar(context, note),
            _buildNoteContent(note),
            _buildNoteFooter(note),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteTitleBar(BuildContext context, Note note) {
    return Container(
      padding: const EdgeInsets.only(left: 12),
      height: MediaQuery.of(context).size.height / 30,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(5),
          topLeft: Radius.circular(5),
        ),
        color: Color(0xFFF5E6CC),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              note.title,
              style: getTextStyle(14, FontWeight.w500, AppColors.kBrown),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () async {
              final confirm = await confirmDialog(context);
              if (confirm == true) {
                await _deleteNote(note);
                if (context.mounted) {
                  Toast.showSuccessToast('Successfully deleted!');
                }
              }
            },
            icon: Image.asset(
              "assets/icons/ic_delete.png",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteContent(Note note) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 10,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8E1),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
        child: Text(
          note.content,
          maxLines: 3,
          style: getTextStyle(14, FontWeight.normal, AppColors.kBlackColor),
        ),
      ),
    );
  }

  Widget _buildNoteFooter(Note note) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(5),
          bottomLeft: Radius.circular(5),
        ),
        color: Color(0xFFFFF3CD),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Edited: ${DateFormat("dd-MM-yyyy hh:mm aaa").format(note.modifiedTime)}',
          style:
              getTextStyle(10, FontWeight.normal, AppColors.tabSelectedColor),
        ),
      ),
    );
  }

  Future<bool?> confirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.appBarColor,
          icon: Icon(Icons.delete_outline_rounded,
              color: AppColors.kCancel, size: 24),
          title: const Text('Want to delete this?',
              style: TextStyle(color: Colors.black, fontSize: 16)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kRedNoButton),
                child: const SizedBox(
                  width: 60,
                  child: Text('Yes',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.kWhiteColor)),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kGreenColor),
                child: const SizedBox(
                  width: 60,
                  child: Text('No',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.kWhiteColor)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final notesAsync = ref.watch(notesStreamProvider);
    final notes = notesAsync.value ?? [];
    final filteredNotes = _filteredNotes(notes);

    return Scaffold(
      backgroundColor: AppColors.kBgColor.withOpacity(.3),
      appBar: CustomSearchAppBar(
        title: 'NOTES : ${notes.length}',
        searchController: _searchController,
        onSearchChanged: doSearch,
        backgroundColor: AppColors.appBarColor,
        titleTextStyle: FontUtil.appBarTitleTextStyle,
        searchTextStyle: const TextStyle(color: AppColors.kBrown, fontSize: 16),
        hintTextStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
      body: Column(
        children: [
          Expanded(
            child: notesAsync.when(
              data: (_) {
                return filteredNotes.isEmpty
                    ? ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: height * .7),
                        child: BlankPage(
                          children: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/note_list.png',
                                  color: AppColors.bottomNavBarIconColor,
                                  scale: 10),
                              const SizedBox(height: 5),
                              Text(
                                "Empty list",
                                style: getCustomTextStyle(
                                  fontSize: 16,
                                  color: AppColors.bottomNavBarIconColor,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'MiSans',
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 12, bottom: 8),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 70),
                          itemCount: filteredNotes.length,
                          itemBuilder: (context, index) =>
                              _buildNoteCard(context, filteredNotes[index]),
                        ),
                      );
              },
              loading: () =>
                  Center(child: SpinKitFadingCircle(color: AppColors.kBrown)),
              error: (err, _) => Center(
                child: Text(
                  'Failed to load notes: $err',
                  style: getTextStyle(14, FontWeight.normal, Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: FloatingActionButton(
          tooltip: "Create",
          backgroundColor: AppColors.kFloatingButtonColor,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () => _showEdit(context),
          child: Image.asset("assets/icons/add_note.png",
              height: 24, color: AppColors.kBrown),
        ),
      ),
    );
  }

  List<Note> _filteredNotes(List<Note> notes) {
    if (_searchQuery.isEmpty) return notes;
    final lowerQuery = _searchQuery.toLowerCase();
    return notes.where((note) {
      return note.title.toLowerCase().contains(lowerQuery) ||
          note.content.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<void> _saveNote(BuildContext sheetContext, Note? existingNote,
      String title, String content) async {
    final user = ref.read(authStateProvider).asData?.value;
    if (user == null) {
      Toast.showErrorToast('User not authenticated');
      return;
    }
    final repository = ref.read(notesRepositoryProvider);
    final now = DateTime.now();

    try {
      if (sheetContext.mounted) {
        Navigator.of(sheetContext).pop();
      }
      if (existingNote == null) {
        await repository.createNote(
          user.uid,
          Note(
            id: '',
            title: title,
            content: content,
            modifiedTime: now,
          ),
        );
      } else {
        await repository.upsertNote(
          user.uid,
          existingNote.copyWith(
            title: title,
            content: content,
            modifiedTime: now,
          ),
        );
      }
    } catch (err) {
      Toast.showErrorToast('Failed to save note: $err');
    }
  }

  Future<void> _deleteNote(Note note) async {
    final user = ref.read(authStateProvider).asData?.value;
    if (user == null) {
      Toast.showErrorToast('User not authenticated');
      return;
    }
    try {
      await ref.read(notesRepositoryProvider).deleteNote(user.uid, note);
    } catch (err) {
      Toast.showErrorToast('Failed to delete note: $err');
    }
  }
}
