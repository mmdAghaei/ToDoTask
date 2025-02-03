import 'package:hive/hive.dart';

part 'taskClass.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  int? id;

  @HiveField(1)
  bool person;

  @HiveField(2)
  String title;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  bool status;

  Task(this.title, this.person, this.date, this.status, {this.id});

  // تبدیل به JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'person': person,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  // ایجاد از JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      json['title'],
      json['person'],
      DateTime.parse(json['date']),
      json['status'],
      id: json['id'],
    );
  }
}
