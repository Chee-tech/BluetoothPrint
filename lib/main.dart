import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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
      home: const MyHomePage(
        title: '',
      ),
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
  void createPdf() async {
    final doc = pw.Document(
      version: PdfVersion.pdf_1_5, compress: true,
      //  title: widget.companyName,author: widget.name,
    );
    final font = await PdfGoogleFonts.tinosBold();
    final font2 = await PdfGoogleFonts.tinosRegular();
    final image = await imageFromAssetBundle('assets/image/openheartlogo.png');
//final provider =  await imageFromAssetBundle(profileImage);
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(left: 0, right: 0),
                  child: pw.Row(children: [
                    pw.Text("",
                        style: pw.TextStyle(
                            font: font,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green,
                            fontSize: 15)),
                    pw.Spacer(),
                    pw.Image(image, width: 70, height: 70),
                    pw.SizedBox(width: 10),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Text("Open Heart Recruitment Ltd",
                              style: pw.TextStyle(
                                  font: font,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.green,
                                  fontSize: 18)),
                          pw.Text("A Caring Compassionate Community",
                              style: pw.TextStyle(
                                font: font,
                                fontWeight: pw.FontWeight.normal,
                                color: PdfColors.black,
                              )),
                          pw.Text("Email: info@openheartrecruitment.com",
                              style: pw.TextStyle(
                                font: font,
                                fontWeight: pw.FontWeight.normal,
                                color: PdfColors.black,
                              )),
                          pw.Text("Contact address: 07424764440",
                              style: pw.TextStyle(
                                font: font,
                                fontWeight: pw.FontWeight.normal,
                                color: PdfColors.black,
                              )),
                        ]),
                  ]),
                ),
                pw.SizedBox(height: 70),
                pw.Text("Dear Currie,",
                    style: pw.TextStyle(
                      font: font2,
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColors.black,
                    )),
                pw.SizedBox(height: 50),
                pw.Text("A LETTER OF ATTESTATION",
                    style: pw.TextStyle(
                      font: font,
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColors.black,
                    )),
                pw.SizedBox(height: 10),
                pw.Text(
                    "I am writing to testify that PE & JE Healthcare Limited is in partnership "
                    " with our company Open Heart Recruitment Ltd as a sub-contractor. PE & JE Healthcare Limited provides carers "
                    "and nurses to my clients. Their vetting and staff recruitment are of a higher standard,"
                    " compliant and responsive to industrial requirements. This can be evidenced by the quality"
                    " of the excellent staff they supply to us.",
                    style: pw.TextStyle(
                      font: font2,
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColors.black,
                    )),
                pw.SizedBox(height: 30),
                pw.Text("Yours faithfully ",
                    style: pw.TextStyle(
                      font: font2,
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColors.black,
                    )),
                pw.Text("Emmanuel Chukwudi Odoh",
                    style: pw.TextStyle(
                      font: font2,
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColors.black,
                    )),
                pw.Text("Director",
                    style: pw.TextStyle(
                      font: font2,
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColors.black,
                    )),
                pw.Text("Open Heart Recruitment Ltd",
                    style: pw.TextStyle(
                      font: font2,
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColors.black,
                    )),
              ]);
        }));
    await Printing.layoutPdf(
        onLayout: (
      PdfPageFormat format,
    ) async =>
            doc.save());
    //  await Printing.sharePdf(bytes: await doc.save(), filename: 'my-document.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              icon: const Icon(Icons.print),
              label: const Text("Print"),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createPdf();
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
