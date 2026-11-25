import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

// So that DRF can parse them i guess
String? _dateOnly(DateTime? d) => d?.toIso8601String().split('T').first;

@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    this.id,
    required this.title,
    required this.description,
    required this.gitLink,
    this.otherLink,
    required this.startedAt,
    this.endedAt,
    this.isOngoing = false,
    this.timeRangeStr = '',
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  // Server-generated
  @JsonKey(includeToJson: false)
  final String? id;
  @JsonKey(includeToJson: false)
  final bool isOngoing;
  @JsonKey(includeToJson: false, defaultValue: '')
  final String timeRangeStr;
  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;
  @JsonKey(includeToJson: false, defaultValue: '')
  final String starredByNames;

  // Writable
  final String title;
  final String description;
  final String gitLink;
  final String? otherLink;

  @JsonKey(toJson: _dateOnly)
  final DateTime startedAt;
  @JsonKey(toJson: _dateOnly)
  final DateTime? endedAt;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
