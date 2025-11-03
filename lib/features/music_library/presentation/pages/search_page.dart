import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/injection/injection_container.dart' as di;
import '../../../../shared/widgets/layout/app_layout.dart';
import '../../../../shared/widgets/layout/app_header.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/widgets/base_components/app_search_field.dart';
import '../../../../shared/widgets/music_components/section_title.dart';
import '../../../../shared/widgets/music_components/lists/genres_list_section.dart';
import '../controllers/genres_controller.dart';
import '../../domain/entities/genre.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  GenresController? _controller;
  final TextEditingController _searchController = TextEditingController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (_controller != null) return; // Já inicializado
    
    _controller = di.sl<GenresController>();
    _controller?.initialize();
    
    _isInitialized = true;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Garantir que o controller seja inicializado mesmo após hot reload
    if (!_isInitialized || _controller == null) {
      _initializeController();
    }

    if (_controller == null) {
      return const AppLayout(
        appBar: AppHeader(title: 'Buscar'),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryRed,
          ),
        ),
      );
    }

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
        child: ChangeNotifierProvider.value(
          value: _controller!,
          child: Consumer<GenresController>(
            builder: (context, controller, child) {
              if (controller.isLoading) {
                return _buildLoadingState();
              }

              if (controller.errorMessage != null) {
                return _buildErrorState(controller);
              }

              if (controller.genres.isEmpty) {
                return _buildEmptyState();
              }

              return _buildContent(controller);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryRed,
      ),
    );
  }

  Widget _buildErrorState(GenresController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spaceLG),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: DesignTokens.spaceMD),
            const Text(
              'Erro ao carregar gêneros',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spaceSM),
            Text(
              controller.errorMessage!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spaceLG),
            ElevatedButton.icon(
              onPressed: () => controller.refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spaceLG),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.music_off,
              color: Colors.white70,
              size: 64,
            ),
            const SizedBox(height: DesignTokens.spaceMD),
            const Text(
              'Nenhum gênero encontrado',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(GenresController controller) {
    final headerPadding = DesignTokens.screenPadding;
    final filteredGenres = controller.filteredGenres;

    return RefreshIndicator(
      onRefresh: () async {
        await controller.refresh();
      },
      color: AppColors.primaryRed,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de busca - logo abaixo do header
            Padding(
              padding: EdgeInsets.only(
                left: headerPadding,
                right: headerPadding,
                top: DesignTokens.spaceMD,
                bottom: DesignTokens.spaceLG,
              ),
              child: _buildSearchBar(controller),
            ),
            // Título "Gêneros" - logo após a barra de busca
            const SectionTitle(
              title: 'Gêneros',
              fontSize: 24,
            ),
            const SizedBox(height: DesignTokens.spaceMD),
            // Lista de gêneros ou mensagem quando não há resultados
            GenresListSection(
              genres: filteredGenres,
              searchQuery: controller.searchQuery,
              onGenreTap: (genre) => _onGenreTap(context, genre),
            ),
            // Espaçamento final
            SizedBox(height: DesignTokens.spaceXL),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(GenresController controller) {
    return AppSearchField(
      controller: _searchController,
      hintText: 'O que você quer ouvir?',
      onChanged: (value) {
        controller.updateSearchQuery(value);
      },
      onClear: () {
        controller.clearSearch();
      },
    );
  }

  void _onGenreTap(BuildContext context, Genre genre) {
    // Navegar para página de detalhes do gênero
    context.pushNamed(
      'category-detail',
      pathParameters: {'categoryTitle': genre.name},
      extra: '',
    );
  }
}

