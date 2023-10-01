import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'team_model.g.dart';

@JsonSerializable(createToJson: false)
class TeamModel {
  final int id;
  @JsonKey(name: "first_name")
  final String firstName;
  @JsonKey(name: "last_name")
  final String lastName;
  final String email, gender, avatar;
  final String domain;
  final bool available;

  TeamModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.avatar,
    required this.domain,
    required this.available,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);

  static Future<List<TeamModel>> getFromJson(String asset) async {
    final str = await rootBundle.loadString(asset);
    final List<dynamic> jsonData = json.decode(str);
    return List<TeamModel>.from(jsonData.map((x) => TeamModel.fromJson(x)));
  }

  static TeamModel errorModel() {
    return TeamModel(
      id: -1,
      firstName: "error",
      lastName: "error",
      email: "error",
      gender: "error",
      avatar: "error",
      domain: "error",
      available: false,
    );
  }
}
