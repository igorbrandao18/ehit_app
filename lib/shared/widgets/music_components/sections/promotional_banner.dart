import 'package:flutter/material.dart';
import '../../../design/layout_tokens.dart';
class PromotionalBanner extends StatelessWidget {
  const PromotionalBanner({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: LayoutTokens.bannerCardHeight + LayoutTokens.paddingMD,
      margin: const EdgeInsets.symmetric(vertical: LayoutTokens.paddingSM),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: LayoutTokens.paddingMD),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: LayoutTokens.bannerCardWidth,
            margin: const EdgeInsets.only(right: LayoutTokens.cardMargin),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(LayoutTokens.radiusMD),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getProductIcon(index),
                  size: 24,
                  color: Colors.grey[700],
                ),
                const SizedBox(height: LayoutTokens.paddingXS),
                Text(
                  _getProductName(index),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  IconData _getProductIcon(int index) {
    switch (index) {
      case 0:
        return Icons.ac_unit; 
      case 1:
        return Icons.cable; 
      case 2:
        return Icons.battery_charging_full; 
      case 3:
        return Icons.diamond; 
      case 4:
        return Icons.shopping_bag; 
      default:
        return Icons.shopping_cart;
    }
  }
  String _getProductName(int index) {
    switch (index) {
      case 0:
        return 'Ventilador';
      case 1:
        return 'Cabo USB';
      case 2:
        return 'Carregador';
      case 3:
        return 'Brincos';
      case 4:
        return 'Shopee';
      default:
        return 'Produto';
    }
  }
}
