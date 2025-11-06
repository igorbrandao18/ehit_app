import 'package:flutter/material.dart';
import '../widgets/base_components/cached_image.dart';

class ImageUtils {
  ImageUtils._();
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
  static String getFallbackImageUrl(String? url, {String? fallbackText}) {
    if (isValidImageUrl(url)) return url!;
    final text = fallbackText ?? 'Image';
    return 'https://via.placeholder.com/300x300/333333/ffffff?text=${Uri.encodeComponent(text)}';
  }
  static Widget buildNetworkImage(
    String? imageUrl, {
    BoxFit fit = BoxFit.cover,
    Widget? fallbackWidget,
    double? width,
    double? height,
  }) {
    if (!isValidImageUrl(imageUrl)) {
      return fallbackWidget ?? _buildDefaultFallback();
    }
    return CachedImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: width != null ? width.toInt() : null,
      cacheHeight: height != null ? height.toInt() : null,
      errorWidget: fallbackWidget ?? _buildDefaultFallback(),
      placeholder: Container(
        color: Colors.grey[300],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
  static Widget _buildDefaultFallback() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
        size: 48,
      ),
    );
  }
}
