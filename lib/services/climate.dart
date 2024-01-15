import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



class ClimateService{
    Future<double> getClimateForDate(DateTime date) async {
        const String apiKey = 'nsBrjSXZ5HNP6xPh4L0Sw8A0PYOwL8pg';
        final String apiUrl =
            'https://api.tomorrow.io/v4/weather/forecast?location=42.3478,-71.0466&apikey=$apiKey&startTime=${date.toUtc().toIso8601String()}&endTime=${date.add(const Duration(days: 1)).toUtc().toIso8601String()}';
        try {
            final http.Response response = await http.get(
                Uri.parse(apiUrl),
            ).timeout(const Duration(minutes: 1));
            if (response != null) {
                if (response.statusCode == 200) {
                    final Map<String, dynamic> data = json.decode(response.body);
                    num  precipitationProbability = data['timelines']['daily'][0]['values']['precipitationProbabilityAvg'];
                    double doublePrecipitationProbability = precipitationProbability.toDouble();
                    return doublePrecipitationProbability;
                }else{
                    return 0;
                }
            }else{
                return 0;
            }
        } catch (exeption){
            return 0;
        }
    }
}


