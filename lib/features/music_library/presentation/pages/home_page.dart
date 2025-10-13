// features/music_library/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../shared/widgets/layout/page_content.dart';
import '../../../../shared/widgets/music_components/playhits_section.dart';
import '../../../../shared/design/design_tokens.dart';
import '../controllers/music_library_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      extendBodyBehindAppBar: true,
      body: Consumer<MusicLibraryController>(
        builder: (context, controller, child) {
          return PageContent(
            onRefresh: controller.refresh,
            children: [
              // PlayHITS da semana section
              const PlayHitsSection(),
              
              // Bottom padding for player
              const SizedBox(height: DesignTokens.miniPlayerHeight + 20),
            ],
          );
        },
      ),
    );
  }

}