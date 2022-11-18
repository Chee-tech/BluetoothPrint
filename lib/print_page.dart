// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrintingPage extends StatefulWidget {
  const PrintingPage({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);
  final String title;
  final List<Map<String, dynamic>> data;

  @override
  State<PrintingPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PrintingPage> {
  BluetoothPrint bluetooth = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _deviceMsg = "";
  final f = NumberFormat("\$###,##0.00", "en_US");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => {_getDevices()});
  }

  Future<void> _getDevices() async {
    bluetooth.startScan(timeout: const Duration(seconds: 2));
    if (!mounted) return;
    bluetooth.scanResults.listen((devices) {
      if (!mounted) return;
      setState(() => {_devices = devices});
      if (_devices.isEmpty) {
        setState(() => {_deviceMsg = "No devices found"});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _devices.isEmpty
          ? Center(child: Text(_deviceMsg))
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_devices[index].name.toString()),
                  subtitle: Text(_devices[index].address.toString()),
                  onTap: () {
                    _startPrint(_devices[index]);
                  },
                );
              },
            ),
    );
  }

  Future<void> _startPrint(BluetoothDevice device) async {
    if (device.address != null) {
      await bluetooth.connect(device);
      Map<String, dynamic> config = {};
      config['width'] = 40;
      config['height'] = 70;
      config['gap'] = 2;
      List<LineText> list = [];
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "MAAP CN TICKETS",
          align: LineText.ALIGN_CENTER,
          width: 2,
          height: 2,
          weight: 2,
          linefeed: 1));
      for (var i = 0; i < widget.data.length; i++) {
        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: "Ticket # ${widget.data[i]['title']}",
            align: LineText.ALIGN_CENTER,
            width: 1,
            height: 1,
            weight: 1,
            linefeed: 1));
        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content:
                "${f.format(widget.data[i]['price'])} x ${widget.data[i]['qty']}",
            align: LineText.ALIGN_CENTER,
            width: 1,
            height: 1,
            weight: 1,
            linefeed: 1));
        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: f.format(widget.data[i]['price'] * widget.data[i]['qty']),
            align: LineText.ALIGN_CENTER,
            width: 1,
            height: 1,
            weight: 1,
            linefeed: 1));

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: "--------------------------------",
            align: LineText.ALIGN_CENTER,
            width: 1,
            height: 1,
            weight: 1,
            linefeed: 1));
      }
      await bluetooth.printReceipt(config, list);
    }
  }
}
