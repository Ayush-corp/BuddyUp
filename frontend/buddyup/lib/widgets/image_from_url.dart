import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageFromUrl extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const ImageFromUrl({super.key,
    required this.imageUrl,
    this.width,
    this.height,
  });

  @override
  _ImageFromUrlState createState() => _ImageFromUrlState();
}

class _ImageFromUrlState extends State<ImageFromUrl> {
  late Future<http.Response> _responseFuture;
  late Uint8List _bytes;

  @override
  void initState() {
    super.initState();
    _responseFuture = http.get(Uri.parse(widget.imageUrl));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _responseFuture,
      builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data!.statusCode == 200) {
          _bytes = snapshot.data!.bodyBytes;
          return Image.memory(
            _bytes,
            width: widget.width,
            height: widget.height,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}