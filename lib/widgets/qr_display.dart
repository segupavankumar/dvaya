import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrDisplay extends StatelessWidget {
  final String data;

  const QrDisplay({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: 200,
        backgroundColor: Colors.white,
        eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black),
        dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Colors.black),
      ),
    );
  }
}
