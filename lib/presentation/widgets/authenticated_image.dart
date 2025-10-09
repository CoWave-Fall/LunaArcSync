import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:dio/dio.dart';

class AuthenticatedImage extends StatefulWidget {
  final String imageUrl;

  const AuthenticatedImage({super.key, required this.imageUrl});

  @override
  State<AuthenticatedImage> createState() => _AuthenticatedImageState();
}

class _AuthenticatedImageState extends State<AuthenticatedImage> {
  Future<Uint8List>? _imageFuture;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() {
    final apiClient = getIt<ApiClient>();
    _imageFuture = apiClient.dio
        .get(
          widget.imageUrl,
          options: Options(responseType: ResponseType.bytes),
        )
        .then((response) => response.data as Uint8List);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 50),
                const SizedBox(height: 8),
                const Text("Failed to load image.", style: TextStyle(color: Colors.grey)),
                if (snapshot.hasError)
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          );
        }
        return Image.memory(snapshot.data!);
      },
    );
  }
}
