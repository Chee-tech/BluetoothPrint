import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printer_test/print_page.dart';
import 'package:printer_test/test_print.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => const TestPrintPage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> data = [
    {
      'title': 'Maggi',
      'price': 5,
      'qty': 7,
    },
    {
      'title': 'Pepper',
      'price': 10,
      'qty': 6,
    },
    {
      'title': 'Milk Candy',
      'price': 20,
      'qty': 5,
    },
    {
      'title': 'Tea Milo',
      'price': 30,
      'qty': 4,
    },
    {
      'title': 'Onions',
      'price': 40,
      'qty': 3,
    },
    {
      'title': 'Rice',
      'price': 50,
      'qty': 2,
    },
    {
      'title': 'Kettle',
      'price': 60,
      'qty': 1,
    },
  ];
  final f = NumberFormat("\$###,##0.00", "en_US");

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    int total = 0;
    total = data
        .map((e) => e['price'] * e['qty'])
        .reduce((value, element) => value + element);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    data[index]['title'].toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "${f.format(data[index]['price'])} x ${data[index]['qty']}"),
                  trailing:
                      Text(f.format(data[index]['price'] * data[index]['qty'])),
                );
              },
            ),
          ),
          Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Text(
                    'Total: ${f.format(total)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 80,
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TestPrintPage(
                                  title: "Bluetooth Devices", data: data)),
                        );
                      },
                      icon: const Icon(Icons.print),
                      label: const Text('Print'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        disabledForegroundColor: Colors.grey,
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
