import 'dart:convert';

import 'package:flutter/services.dart';

class Suggestions {
  String keyword;
  int id;
  String autocompleteterm;
  String country;

  Suggestions({
    this.keyword,
    this.id,
    this.autocompleteterm,
    this.country
  });

  factory Suggestions.fromJson(Map<String, dynamic> parsedJson) {
    return Suggestions(
        keyword: parsedJson['keyword'] as String,
        id: parsedJson['id'],
        autocompleteterm: parsedJson['autocompleteTerm'] as String,
        country: parsedJson['country'] as String
    );
  }
}

class SuggestionsViewModel {
  static List<Suggestions> suggestions;

  static Future loadsuggestions() async {
    try {
      suggestions = new List<Suggestions>();
      String jsonString = await rootBundle.loadString('assets/sample.json');
      Map parsedJson = json.decode(jsonString);
      var categoryJson = parsedJson['suggestions'] as List;
      for (int i = 0; i < categoryJson.length; i++) {
        suggestions.add(new Suggestions.fromJson(categoryJson[i]));
      }
    } catch (e) {
      print(e);
    }
  }
}

