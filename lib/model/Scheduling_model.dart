import 'package:intl/intl.dart';

import 'cancha_model.dart';
class SchedulingModel {
    int? id;
    CanchaModel? cancha;
    DateTime? date;
    String? user;

    SchedulingModel({this.id, this.cancha, this.date, this.user});

    Map<String, dynamic> toMap() {
        return {
            'id': id,
            'cancha': cancha?.toMap(),
            'date': formattedDate(date),
            'user': user,
        };
    }

    factory SchedulingModel.fromMap(Map<String, dynamic> map) {
        return SchedulingModel(
            id: map['id'],
            cancha: CanchaModel.fromMap(map['cancha']),
            date: DateFormat('yyyy-MM-dd').parse(map['date']),
            user: map['user'],
        );
    }

    String formattedDate(DateTime? date) {
        return DateFormat('yyyy-MM-dd').format(date!);
    }


}