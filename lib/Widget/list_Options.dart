import 'dart:convert';
import 'package:flutter/services.dart';
class ListOptions {
  final List<String> groupOptions;
  final List<String> unitGroupOptions;
  final List<String> selectedGSTOptions;
   final List<String> selectedRequireOptions;
  final List<String> selectedMeetingOptions;

  ListOptions({
    required this.groupOptions,
    required this.unitGroupOptions,
    required this.selectedGSTOptions,
    required this.selectedRequireOptions,
    required this.selectedMeetingOptions,
  });
  factory ListOptions.fromJson(Map<String, dynamic> json) {
    return ListOptions(
      groupOptions: List<String>.from(json['groupOptions']),
      unitGroupOptions: List<String>.from(json['unitGroupOptions']),
      selectedGSTOptions: List<String>.from(json['selectedGSTOptions']),
      selectedRequireOptions: List<String>.from(json['selectedRequireOptions']),
      selectedMeetingOptions: List<String>.from(json['selectedMeetingOptions']),
    );
  }
}
  // Function to fetch data from a JSON file
  Future<ListOptions> fetchData() async {
    try {
      String jsonString =
          await rootBundle.loadString('lib/JSON/jsonlist.json');
      Map<String, dynamic> data = json.decode(jsonString);
      return ListOptions.fromJson(data);
    } catch (error) {
      throw Exception('Failed to load data: $error');
    }
  }

