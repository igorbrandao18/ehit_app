import 'package:flutter/material.dart';
import '../../../../shared/widgets/layout/app_layout.dart';
import '../../../../shared/widgets/layout/app_header.dart';
import '../../../../shared/design/app_colors.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: AppHeader(
        title: 'Buscar',
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.solidBackground,
        ),
        child: const Center(
          child: Text('Página de Busca'),
        ),
      ),
    );
  }
}

