import 'dart:math';
import 'package:date_calculator/models/notes_model.dart';
import 'package:date_calculator/utils/blank_page.dart';
import 'package:date_calculator/utils/colors.dart';
import 'package:date_calculator/utils/font_util.dart';
import 'package:date_calculator/utils/text_style.dart';
import 'package:date_calculator/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  bool isSearching = false;
  bool sorted = false;
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> searchItem = [];
  TextEditingController searchController = TextEditingController();
  final TextEditingController _headLineController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String noteDate = DateFormat("dd-MM-yyyy hh:mm aaa").format(DateTime.now());
  final _openBox = Hive.box('open_note');

  @override
  void initState() {
    super.initState();
    refreshItems();
    //filteredNotes = sampleNotes;
    searchItem = _items;
  }

  void doSearch(String enterValue) {
    List<Map<String, dynamic>> result = [];

    if (enterValue.isEmpty) {
      result = _items;
    } else {
      result = _items.where((item) {
        final title = item['title'].toString().toLowerCase();
        final content = item['content'].toString().toLowerCase();
        final query = enterValue.toLowerCase();

        return title.contains(query) || content.contains(query);
      }).toList();
    }

    setState(() {
      searchItem = result;
    });
  }

  void _showEdit(BuildContext context, int? itemKey) async {
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _headLineController.text = existingItem['title'];
      _descriptionController.text = existingItem['content'];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0), bottom: Radius.circular(10.0)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: MediaQuery.of(context).viewInsets.bottom,
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
                // Scrollable Content
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 10), // Space for buttons
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                            color: Color(0xFFFFF8E1),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: _headLineController,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            style: getTextStyle(
                                19, FontWeight.normal, AppColors.kBrown),
                            decoration: InputDecoration(
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              hintText: 'Title',
                              hintStyle: getTextStyle(
                                  16, FontWeight.normal, Colors.grey),
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            color: Color(0xFFFFF8E1),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: TextField(
                            controller: _descriptionController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: getTextStyle(
                                16, FontWeight.normal, AppColors.kBlackColor),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type something here',
                              hintStyle: getTextStyle(
                                  14, FontWeight.normal, Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Positioned Buttons
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.kSegmentButton,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Image.asset('assets/icons/arrow_back.png',
                                height: 15,
                                width: 15,
                                color: AppColors.kWhiteColor),
                            label: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        // Save Button
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.kAccept,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              if (_headLineController.text.isEmpty &&
                                  _descriptionController.text.isEmpty) {
                                Fluttertoast.showToast(msg: 'Empty field!');
                              } else if (itemKey == null) {
                                createItem({
                                  "title": _headLineController.text,
                                  "content": _descriptionController.text,
                                  "noteDate": noteDate,
                                });
                                Navigator.pop(context);
                              } else {
                                editItem(itemKey, {
                                  "title": _headLineController.text.trim(),
                                  "content": _descriptionController.text.trim(),
                                  "noteDate": noteDate.trim(),
                                });
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(Icons.save,
                                color: Colors.white, size: 16),
                            label: const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).whenComplete(() => setState(() {
          _headLineController.text = '';
          _descriptionController.text = '';
        }));
  }

  Future<void> createItem(Map<String, dynamic> newItem) async {
    await _openBox.add(newItem);
    print('>>>>>>>>>>>${_openBox.length}');
    refreshItems();
  }

  Future<void> editItem(int itemKey, Map<String, dynamic> item) async {
    await _openBox.put(itemKey, item);
    print('>>>>>>>>>>>${_openBox.length}');
    refreshItems();
  }

  Future<void> deleteItem(int itemKey) async {
    await _openBox.delete(itemKey);
    print('>>>>>>>>>>>${_openBox.length}');
    refreshItems();
  }

  List<Note> sortNotesByModifiedTime(List<Note> notes) {
    if (sorted) {
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    } else {
      notes.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }

    sorted = !sorted;

    return notes;
  }

  getRandomColor() {
    Random random = Random();
    return randomBackgroundColors[
        random.nextInt(randomBackgroundColors.length)];
  }

  void refreshItems() {
    final data = _openBox.keys.map((key) {
      final item = _openBox.get(key);
      return {
        "key": key,
        "title": item["title"],
        "content": item["content"],
        "noteDate": item["noteDate"]
      };
    }).toList();
    setState(() {
      _items = data.reversed.toList();
      searchItem = _items;
      print('____________${_items.length}');
    });
  }

  ///unused
/*
  List<Note> filteredNotes = [];
  List<Note> sampleNotes = [];
  void deleteNote(int index) {
    setState(() {
      Note note = filteredNotes[index];
      filteredNotes.removeAt(index);
      sampleNotes.remove(note);
    });
    //db.updateDataBase();
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredNotes = sampleNotes
          .where((note) =>
      note.content.toLowerCase().contains(searchText.toLowerCase()) ||
          note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void doSearch(String enteredValue) {
    List<Map<String, dynamic>> result = [];
    if (enteredValue.isEmpty) {
      result = _items; // Show all items if the search query is empty
    } else {
      result = _items.where((note) {
        final title = note["title"].toString().toLowerCase();
        final content = note["content"].toString().toLowerCase();
        final query = enteredValue.toLowerCase();

        return title.contains(query) || content.contains(query);
      }).toList();
    }

    setState(() {
      filteredNotes = result.cast<Note>();
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      //backgroundColor: AppColors.kNewBackground.withOpacity(.1),
      //backgroundColor: AppColors.kWarningToastTextColor.withOpacity(.1),
      backgroundColor: Color(0xFFFFFBED).withOpacity(.5),
      appBar: CustomSearchAppBar(
        title: 'NOTES : ${_items.length}',
        searchController: searchController,
        onSearchChanged: doSearch,
        backgroundColor: AppColors.appBarColor,
        titleTextStyle: FontUtil.appBarTitleTextStyle,
        searchTextStyle: const TextStyle(color: AppColors.kBrown, fontSize: 16),
        hintTextStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 8),
        child: Column(
          children: [
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'NOTES : ${_items.length}',
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        //filteredNotes = sortNotesByModifiedTime(filteredNotes);
                      });
                    },
                    padding: const EdgeInsets.all(0),
                    icon: Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(.8),
                          borderRadius: BorderRadius.circular(5)),
                      child: const Icon(
                        Icons.sort,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
            TextField(
              onChanged: (value) => doSearch(value),
              controller: searchController,
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search), labelText: 'Search'),
            ),*/
            Expanded(
              child: searchItem.isEmpty
                  ? ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: height * 0.7),
                      child: BlankPage(
                        margin: EdgeInsets.only(bottom: 5),
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
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 70),
                      itemCount: searchItem.length,
                      itemBuilder: (context, index) {
                        final currentItem = searchItem[index];
                        return noteCardWidget(context, currentItem);
                      },
                    ),
            ),
          ],
        ),
      ),
      //_showEdit(context, null);
      floatingActionButton: FloatingActionButton.extended(
        tooltip: "Create",
        //backgroundColor: AppColors.selectedBottomNavBarIconColor,
        backgroundColor: AppColors.kFloatingButtonColor,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () => _showEdit(context, null),
        icon: Icon(Icons.add_box_rounded, color: AppColors.kBrown, size: 20),
        label: Text(
          "Create",
          style: getCustomTextStyle(
            fontSize: 14,
            color: AppColors.kBrown,
            fontWeight: FontWeight.w500,
            fontFamily: 'MiSans',
          ),
        ),
      ),
    );
  }

  GestureDetector noteCardWidget(
      BuildContext context, Map<String, dynamic> currentItem) {
    return GestureDetector(
      onTap: () {
        _showEdit(context, currentItem['key']);
      },
      child: Card(
        elevation: 1,
        margin: EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 12),
              height: MediaQuery.of(context).size.height / 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5.0),
                  bottomRight: Radius.circular(0.0),
                  bottomLeft: Radius.circular(0.0),
                  topLeft: Radius.circular(5.0),
                ),
                color: Color(0xFFF5E6CC),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      currentItem["title"],
                      style:
                          getTextStyle(15, FontWeight.w500, AppColors.kBrown),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    /*onPressed: () {
                      showCustomDialogBox(context, 'Please Confirm',
                          'Want to Delete?', null, null, onConfirm: () async {
                        deleteItem(currentItem['key']);
                        Navigator.pop(context);
                        //SystemNavigator.pop();
                      }, onCancel: () {
                        Navigator.pop(context);
                      });
                    },*/
                    onPressed: () async {
                      final result = await confirmDialog(context);
                      if (result != null && result) {
                        deleteItem(currentItem['key']);
                        //deleteNote(index);
                      }
                    },
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.kCancel,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0.0),
                  bottomRight: Radius.circular(0.0),
                  bottomLeft: Radius.circular(0.0),
                  topLeft: Radius.circular(0.0),
                ),
                color: Color(0xFFFFF8E1),
                //border: Border.all(color: AppColors.greenButton),
                //color: getRandomColor(),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 5, left: 10, right: 10),
                child: Text(currentItem["content"].toString(),
                    maxLines: 3,
                    style: getTextStyle(
                        16, FontWeight.normal, AppColors.kBlackColor)),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0.0),
                  bottomRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(5.0),
                  topLeft: Radius.circular(0.0),
                ),
                color: Color(0xFFFFF3CD),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Edited: ${currentItem["noteDate"]}',
                  style: getTextStyle(
                      10, FontWeight.normal, AppColors.tabSelectedColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.appBarColor,
            icon: Icon(
              Icons.delete_outline_rounded,
              color: AppColors.kCancel,
              size: 24,
            ),
            title: const Text(
              'Want to delete this?',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kRedNoButton),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'Yes',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.kWhiteColor),
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kGreenColor),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'No',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.kWhiteColor),
                        ),
                      )),
                ]),
          );
        });
  }
}
