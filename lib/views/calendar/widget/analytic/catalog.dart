import 'package:alem_application/bloc/analytic_client_bloc/CropRotation_client.dart';
import 'package:alem_application/bloc/analytic_client_bloc/contract_inside_bloc.dart';
import 'package:alem_application/views/calendar/widget/analytic/contract_list.dart';
import 'package:alem_application/views/calendar/widget/analytic/crops_list.dart';
import 'package:alem_application/views/calendar/widget/analytic/subcides_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/analytic_client_bloc/subcides_client.dart';

// ignore: use_key_in_widget_constructors
class CatalogAnalytic extends StatelessWidget {
  final styleElevated = ButtonStyle(
    fixedSize: MaterialStateProperty.all(Size(400, 60)),
    backgroundColor:
        MaterialStateProperty.all<Color>(Color.fromARGB(255, 0, 113, 199)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    ),
  );
  final sizeB = const SizedBox(height: 10);
  final sizeEl = const SizedBox(
    width: 10,
  );
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            sizeB,
            ElevatedButton(
              style: styleElevated,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return BlocProvider(
                      create: (context) => SubcidesListBloc(),
                      child: SubcidesList(),
                    );
                  }),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.polyline_sharp),
                  sizeEl,
                  Text("Субсидии")
                ],
              ),
            ),
            sizeB,
            ElevatedButton(
              style: styleElevated,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return BlocProvider(
                      create: (context) =>
                          CropRotationBloc()..add(CropRotationFetched()),
                      child: CropRotationScreen(),
                    );
                  }),
                );
              },
              child: Row(
                children: [
                  const Icon(Icons.agriculture_rounded),
                  sizeEl,
                  const Text("Севооборот")
                ],
              ),
            ),
            sizeB,
            ElevatedButton(
              style: styleElevated,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return BlocProvider(
                      create: (context) =>
                          ContractInsideBloc()..add(ContractInsideFetched()),
                      child: ContractInsideScreen(),
                    );
                  }),
                );
              },
              child: Row(
                children: [
                  const Icon(Icons.edit_document),
                  sizeEl,
                  const Text("Анализ по договорам")
                ],
              ),
            ),
            sizeB,
          ],
        ),
      ),
    );
  }
}
