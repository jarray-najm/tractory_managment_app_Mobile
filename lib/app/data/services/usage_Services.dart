import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../utils/constants.dart';
import '../models/usage_Model.dart';

class UsageService extends GetxService {
  Future<List<Usage>> getAllUsage() async {
    final response = await http.get(
        Uri.parse('https://tractor-managment-app-node.onrender.com/usages'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Usage.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load usage');
    }
  }

  Future<void> addUsage(Usage usage) async {
    final response = await http.post(
      Uri.parse('https://tractor-managment-app-node.onrender.com/usages'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(usage.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add usage');
    }
  }

  Future<void> updateUsage(Usage usage) async {
    final response = await http.put(
      Uri.parse(
          'https://tractor-managment-app-node.onrender.com/usages/${usage.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(usage.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update usage');
    }
  }

  Future<void> deleteUsage(int id) async {
    final response = await http.delete(
      Uri.parse('https://tractor-managment-app-node.onrender.com/usages/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete usage');
    }
  }
}