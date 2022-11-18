// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TestPrintPage extends StatefulWidget {
  const TestPrintPage({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);
  final String title;
  final List<Map<String, dynamic>> data;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TestPrintPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'no device connect';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 4));

    bool isConnected = await bluetoothPrint.isConnected ?? false;

    bluetoothPrint.state.listen((state) {
      if (kDebugMode) {
        print('******************* cur device status: $state');
      }

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  final f = NumberFormat("\$###,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              bluetoothPrint.startScan(timeout: const Duration(seconds: 4)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Text(tips),
                    ),
                  ],
                ),
                const Divider(),
                StreamBuilder<List<BluetoothDevice>>(
                  stream: bluetoothPrint.scanResults,
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!
                        .map((d) => ListTile(
                              title: Text(d.name ?? ''),
                              subtitle: Text(d.address ?? ''),
                              onTap: () async {
                                setState(() {
                                  _device = d;
                                });
                              },
                              trailing: _device != null &&
                                      _device!.address == d.address
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : null,
                            ))
                        .toList(),
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OutlinedButton(
                            onPressed: _connected
                                ? null
                                : () async {
                                    if (_device != null &&
                                        _device!.address != null) {
                                      setState(() {
                                        tips = 'connecting...';
                                      });
                                      await bluetoothPrint.connect(_device!);
                                    } else {
                                      setState(() {
                                        tips = 'please select device';
                                      });
                                      if (kDebugMode) {
                                        print('please select device');
                                      }
                                    }
                                  },
                            child: const Text('connect'),
                          ),
                          const SizedBox(width: 10.0),
                          OutlinedButton(
                            onPressed: _connected
                                ? () async {
                                    setState(() {
                                      tips = 'disconnecting...';
                                    });
                                    await bluetoothPrint.disconnect();
                                  }
                                : null,
                            child: const Text('disconnect'),
                          ),
                        ],
                      ),
                      const Divider(),
                      OutlinedButton(
                        onPressed: _connected
                            ? () async {
                                Map<String, dynamic> config = {};
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
                                      content:
                                          "Ticket # ${widget.data[i]['title']}",
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
                                      content: f.format(widget.data[i]
                                              ['price'] *
                                          widget.data[i]['qty']),
                                      align: LineText.ALIGN_CENTER,
                                      width: 1,
                                      height: 1,
                                      weight: 1,
                                      linefeed: 1));

                                  list.add(LineText(
                                      type: LineText.TYPE_TEXT,
                                      content:
                                          "--------------------------------",
                                      align: LineText.ALIGN_CENTER,
                                      width: 1,
                                      height: 1,
                                      weight: 1,
                                      linefeed: 1));
                                }
                                // list.add(LineText(type: LineText.TYPE_IMAGE, content: base64Image, align: LineText.ALIGN_CENTER, linefeed: 1));

                                await bluetoothPrint.printReceipt(config, list);
                              }
                            : null,
                        child: const Text('print receipt(esc)'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
