import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
  });

  final String id;
  final String title;
  final String content;
  final DateTime modifiedTime;

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? modifiedTime,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      modifiedTime: modifiedTime ?? this.modifiedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'modifiedTime': Timestamp.fromDate(modifiedTime),
    };
  }

  factory Note.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Note(
      id: doc.id,
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      modifiedTime: (data['modifiedTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
