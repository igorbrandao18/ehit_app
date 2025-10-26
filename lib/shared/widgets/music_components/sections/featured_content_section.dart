import 'package:flutter/material.dart';
import '../../../design/layout_tokens.dart';
import '../../../design/app_colors.dart';
class FeaturedContentSection extends StatelessWidget {
  const FeaturedContentSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: LayoutTokens.featuredCardHeight,
      margin: const EdgeInsets.symmetric(horizontal: LayoutTokens.paddingMD),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(LayoutTokens.radiusLG),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(LayoutTokens.radiusLG),
                          topRight: Radius.circular(LayoutTokens.radiusLG),
                        ),
                        image: const DecorationImage(
                          image: NetworkImage('https://via.placeholder.com/150x100/FF6B6B/FFFFFF?text=Artista'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(LayoutTokens.paddingSM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PLAYLIST',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'SERTANEJO RAIZ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
