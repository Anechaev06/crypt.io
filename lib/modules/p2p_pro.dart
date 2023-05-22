import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class P2pProPage extends StatefulWidget {
  const P2pProPage({Key? key}) : super(key: key);

  @override
  State<P2pProPage> createState() => _P2pProPageState();
}

class _P2pProPageState extends State<P2pProPage> {
  List<List<dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  Future<void> loadCSV() async {
    String csvContent = await rootBundle.loadString('assets/P2P_pro.csv');
    setState(() => data = const CsvToListConverter().convert(csvContent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('P2P pro'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: data.isEmpty
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('To Buy')),
                    DataColumn(label: Text('To Sell')),
                    DataColumn(label: Text('Sprets')),
                    DataColumn(label: Text('To Exchange')),
                    DataColumn(label: Text('Price to Buy')),
                    DataColumn(label: Text('Price to Sell')),
                  ],
                  rows: List.generate(
                    data.length - 1,
                    (index) => DataRow(
                      cells: <DataCell>[
                        for (var cell in data[index + 1])
                          DataCell(Text(cell.toString())),
                      ],
                    ),
                  ).toList(),
                ),
              ),
      ),
    );
  }
}
