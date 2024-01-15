import 'package:flutter/material.dart';


class ButtonSchedule extends StatelessWidget {
    const ButtonSchedule({
    super.key,
    });

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            width: 120.0, // ancho
            height: 80.0, // alto
            child: FloatingActionButton(
                onPressed: () {
                    Navigator.of(context).pushReplacementNamed("Scheduling");
                },
                backgroundColor: Colors.green,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                        Icon(Icons.sports_soccer),
                        Text("Agendar"),
                    ],
                ),
            ),
        );
    }
}