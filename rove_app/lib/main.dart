import 'package:flutter/material.dart';
import 'services/rove_repository.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = RoveRepository();
  runApp(RoveApp(repository: repository));
}
