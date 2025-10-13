// shared/utils/image_utils.dart
import 'package:flutter/material.dart';

/// Utilitários para manipulação de imagens
class ImageUtils {
  ImageUtils._();

  /// Valida se uma URL de imagem é válida
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    
    // Verifica se é uma URL válida
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Retorna uma URL de fallback se a URL fornecida for inválida
  static String getFallbackImageUrl(String? url, {String? fallbackText}) {
    if (isValidImageUrl(url)) return url!;
    
    final text = fallbackText ?? 'Image';
    return 'https://via.placeholder.com/300x300/333333/ffffff?text=${Uri.encodeComponent(text)}';
  }

  /// Constrói um widget de imagem de rede com tratamento de erro robusto
  static Widget buildNetworkImage(
    String? imageUrl, {
    BoxFit fit = BoxFit.cover,
    Widget? fallbackWidget,
    double? width,
    double? height,
  }) {
    // Se a URL for inválida, retorna o fallback diretamente
    if (!isValidImageUrl(imageUrl)) {
      return fallbackWidget ?? _buildDefaultFallback();
    }

    return Image.network(
      imageUrl!,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return fallbackWidget ?? _buildDefaultFallback();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  /// Widget de fallback padrão
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
