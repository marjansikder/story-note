import 'package:date_calculator/utils/blank_page.dart';
import 'package:date_calculator/utils/colors.dart';
import 'package:date_calculator/utils/font_util.dart';
import 'package:date_calculator/utils/text_style.dart';
import 'package:date_calculator/utils/toast.dart';
import 'package:date_calculator/utils/toast_util.dart';
import 'package:date_calculator/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class NotesPadScreen extends StatefulWidget {
  const NotesPadScreen({super.key});

  @override
  State<NotesPadScreen> createState() => _NotesPadScreenState();
}

class _NotesPadScreenState extends State<NotesPadScreen> {
  final _headLineController = TextEditingController();
  final _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final _openBox = Hive.box('open_note');
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> searchItem = [];

  @override
  void initState() {
    super.initState();
    refreshItems();
  }

  /// --------------------- REFRESH & SORT ---------------------
  void refreshItems() {
    final data = _openBox.keys.map((key) {
      final item = _openBox.get(key);
      final dateString = item["noteDate"] ?? '';
      DateTime parsedDate;

      try {
        parsedDate = DateFormat("dd-MM-yyyy hh:mm aaa").parse(dateString);
      } catch (_) {
        // fallback if parsing fails
        parsedDate = DateTime.now();
      }

      return {
        "key": key,
        "title": item["title"],
        "content": item["content"],
        "noteDate": item["noteDate"],
        "parsedDate": parsedDate,
      };
    }).toList();

    // Sort by latest date first
    data.sort((a, b) => b["parsedDate"].compareTo(a["parsedDate"]));

    setState(() {
      _items = data;
      searchItem = data;
    });
  }

  /// --------------------- HIVE CRUD ---------------------
  Future<void> createItem(Map<String, dynamic> newItem) async {
    await _openBox.add(newItem);
    refreshItems();
  }

  Future<void> editItem(int itemKey, Map<String, dynamic> item) async {
    await _openBox.put(itemKey, item);
    refreshItems();
  }

  Future<void> deleteItem(int itemKey) async {
    await _openBox.delete(itemKey);
    refreshItems();
  }

  /// --------------------- SEARCH LOGIC ---------------------
  void doSearch(String query) {
    if (query.isEmpty) {
      setState(() => searchItem = _items);
      return;
    }

    final lowerQuery = query.toLowerCase();
    final result = _items.where((item) {
      final title = (item['title'] ?? '').toLowerCase();
      final content = (item['content'] ?? '').toLowerCase();
      return title.contains(lowerQuery) || content.contains(lowerQuery);
    }).toList();

    setState(() => searchItem = result);
  }

  /// --------------------- BOTTOM SHEET (CREATE/EDIT NOTE) ---------------------
  void _showEdit(BuildContext context, {int? itemKey}) {
    // If editing, load existing note
    if (itemKey != null) {
      final existingItem = _items.firstWhere((el) => el['key'] == itemKey);
      _headLineController.text = existingItem['title'];
      _descriptionController.text = existingItem['content'];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.circular(10)),
      ),
      builder: (context) {
        return SafeArea(
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
                  // Scrollable content
                  Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                  // Positioned save/back buttons
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: _buildBottomButtons(itemKey),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      // Clear text fields upon closing
      setState(() {
        _headLineController.clear();
        _descriptionController.clear();
      });
    });
  }

  /// Builds the row containing the Title text field + optional "Copy All" button
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
              style: getCustomTextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.kBrown),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kOrgHeader, width: 1),
                ),
                hintText: 'Title',
                hintStyle: getCustomTextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.grey),
              ),
            ),
          ),
          if (_headLineController.text.isNotEmpty || _descriptionController.text.isNotEmpty) ...[
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

  /// Builds the description text field
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

  /// Builds the bottom row with [Back] and [Save] buttons
  Widget _buildBottomButtons(int? itemKey) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Back
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kSegmentButton,
                padding: const EdgeInsets.symmetric(vertical: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.pop(context),
              icon: Image.asset(
                'assets/icons/ic_arrow_back.png',
                height: 15,
                width: 15,
                color: AppColors.kWhiteColor,
              ),
              label: const Text(
                'Back',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Save
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kAccept,
                padding: const EdgeInsets.symmetric(vertical: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                final headline = _headLineController.text.trim();
                final description = _descriptionController.text.trim();

                if (headline.isEmpty && description.isEmpty) {
                  Toast.showErrorToast('Empty field!');
                  return;
                }

                final currentDate = DateFormat("dd-MM-yyyy hh:mm aaa").format(DateTime.now());

                if (itemKey == null) {
                  createItem({
                    "title": headline,
                    "content": description,
                    "noteDate": currentDate,
                  });
                } else {
                  editItem(itemKey, {
                    "title": headline,
                    "content": description,
                    "noteDate": currentDate,
                  });
                }
                Navigator.pop(context);
              },
              icon: Image.asset(
                'assets/icons/ic_save.png',
                height: 13,
                width: 13,
                color: AppColors.kWhiteColor,
              ),
              label: const Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// --------------------- UI (LIST ITEM) ---------------------
  GestureDetector _buildNoteCard(BuildContext context, Map<String, dynamic> currentItem) {
    return GestureDetector(
      onTap: () => _showEdit(context, itemKey: currentItem['key']),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            _buildNoteTitleBar(context, currentItem),
            _buildNoteContent(currentItem),
            _buildNoteFooter(currentItem),
          ],
        ),
      ),
    );
  }

  /// The top bar that shows title + delete icon
  Widget _buildNoteTitleBar(BuildContext context, Map<String, dynamic> item) {
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
              item["title"] ?? '',
              style: getTextStyle(14, FontWeight.w500, AppColors.kBrown),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () async {
              final confirm = await confirmDialog(context);
              if (confirm == true) {
                deleteItem(item['key']);
                //Toast.showSuccessToast('Successfully deleted!');
                //ToastMessage.infoShow('Successfully deleted!');
                ToastMessage.infoShowCustom('Successfully deleted!');
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

  /// The middle content section
  Widget _buildNoteContent(Map<String, dynamic> item) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 9,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8E1),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
        child: Text(
          item["content"] ?? '',
          maxLines: 3,
          style: getTextStyle(15, FontWeight.normal, AppColors.kBlackColor),
        ),
      ),
    );
  }

  /// The bottom footer that shows date/time
  Widget _buildNoteFooter(Map<String, dynamic> item) {
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
          'Edited: ${item["noteDate"]}',
          style: getTextStyle(10, FontWeight.normal, AppColors.tabSelectedColor),
        ),
      ),
    );
  }

  /// Confirmation dialog for deleting an item
  Future<bool?> confirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.appBarColor,
          icon: Icon(Icons.delete_outline_rounded, color: AppColors.kCancel, size: 24),
          title: const Text('Want to delete this?', style: TextStyle(color: Colors.black, fontSize: 16)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.kRedNoButton),
                child: const SizedBox(
                  width: 60,
                  child: Text('Yes', textAlign: TextAlign.center, style: TextStyle(color: AppColors.kWhiteColor)),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.kGreenColor),
                child: const SizedBox(
                  width: 60,
                  child: Text('No', textAlign: TextAlign.center, style: TextStyle(color: AppColors.kWhiteColor)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// --------------------- BUILD ---------------------
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.kBgColor.withOpacity(.3),
      appBar: CustomSearchAppBar(
        title: 'NOTES : ${_items.length}',
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
            child: searchItem.isEmpty
                ? ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: height * .7),
                    child: BlankPage(
                      children: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/icons/note_list.png', color: AppColors.bottomNavBarIconColor, scale: 10),
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
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 8),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 70),
                      itemCount: searchItem.length,
                      itemBuilder: (context, index) => _buildNoteCard(context, searchItem[index]),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () => _showEdit(context),
          child: Image.asset("assets/icons/ic_add.png", height: 18, color: AppColors.kBrown),
        ),
      ),
    );
  }
}
