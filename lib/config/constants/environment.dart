import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environmet {
  static initEnvironmet() async {
    await dotenv.load(fileName: '.env');
  }

  static String apiUrl = dotenv.env['API_URL'] ?? 'No se ha configurado el API';
  static String urlSocket = dotenv.env['BASE_URL'] ?? '';
}
