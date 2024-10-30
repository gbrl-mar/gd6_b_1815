import 'package:flutter/material.dart';
import 'package:gd6_b_1815/database/sql_helper2.dart';
import 'package:gd6_b_1815/entity/region.dart';

class Inputregion extends StatefulWidget{
  const Inputregion(
    {super.key,
    required this.title,
    required this.idRegion,
    required this.kota,
    required this.gajiUMR,
    });
    final String? title,kota,gajiUMR;
    final int? idRegion;

    @override
    State<Inputregion> createState() => _Inputregstate();

}

class _Inputregstate extends State <Inputregion>{
  TextEditingController controllerKota = TextEditingController();
  TextEditingController controllerGajiUMR = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.idRegion != null) {
      controllerKota.text = widget.kota!;
       controllerGajiUMR.text = widget.gajiUMR!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Region"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: controllerKota,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Kota',
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerGajiUMR,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Gaji UMR',
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              if (widget.idRegion == null) {
                await addRegion();
              } else {
                await editRegion(widget.idRegion!);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> addRegion() async {
    await SQLHelper2.addRegion(controllerKota.text, controllerGajiUMR.text);
  }

  Future<void> editRegion(int idRegion) async {
    await SQLHelper2.editRegion(idRegion, controllerKota.text, controllerGajiUMR.text);
  }
}
