import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/layout/app_layout.dart';
import '../../../../shared/widgets/layout/app_header.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../../shared/widgets/music_components/cards/genre_card.dart';
import '../controllers/genres_controller.dart';
import '../../domain/entities/genre.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // O controller será inicializado quando o widget for construído
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<GenresController>(context, listen: false);
      controller.initialize();
    });
    
    // Listener para filtrar em tempo real enquanto digita
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase().trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  List<Genre> _filterGenres(List<Genre> genres) {
    if (_searchQuery.isEmpty) {
      return genres;
    }
    return genres.where((genre) {
      return genre.name.toLowerCase().contains(_searchQuery);
    }).toList();
  }

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
        child: Consumer<GenresController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryRed,
                ),
              );
            }

            if (controller.errorMessage != null) {
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
                      Text(
                        'Erro ao carregar gêneros',
                        style: const TextStyle(
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

            if (controller.genres.isEmpty) {
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

            final filteredGenres = _filterGenres(controller.genres);
            return _buildContent(context, filteredGenres, controller);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Genre> genres, GenresController controller) {
    final headerPadding = DesignTokens.screenPadding;

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
              child: _buildSearchBar(),
            ),
            // Título "Gêneros" - logo após a barra de busca
            Padding(
              padding: EdgeInsets.symmetric(horizontal: headerPadding),
              child: const Text(
                'Gêneros',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: DesignTokens.spaceMD),
            // Lista de gêneros ou mensagem quando não há resultados
            if (genres.isEmpty && _searchQuery.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: headerPadding),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(DesignTokens.spaceXL),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          color: AppColors.textTertiary,
                          size: 64,
                        ),
                        const SizedBox(height: DesignTokens.spaceMD),
                        Text(
                          'Nenhum gênero encontrado',
                          style: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: DesignTokens.spaceSM),
                        Text(
                          'Tente buscar com outros termos',
                          style: TextStyle(
                            color: AppColors.textTertiary.withOpacity(0.7),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: headerPadding),
                child: _buildGenresGrid(context, genres),
              ),
            // Espaçamento final
            SizedBox(height: DesignTokens.spaceXL),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(DesignTokens.inputBorderRadius),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'O que você quer ouvir?',
          hintStyle: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textTertiary,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.textTertiary,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceMD,
            vertical: DesignTokens.spaceMD,
          ),
        ),
        onSubmitted: (value) {
          // Filtro já acontece em tempo real
        },
      ),
    );
  }

  Widget _buildGenresGrid(BuildContext context, List<Genre> genres) {
    final spacing = ResponsiveUtils.getResponsiveSpacing(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: genres.length,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        final genre = genres[index];
        return GenreCard(
          name: genre.name,
          imageUrl: genre.imageUrl,
          onTap: () => _onGenreTap(context, genre),
        );
      },
    );
  }

  void _onGenreTap(BuildContext context, Genre genre) {
    // TODO: Navegar para página de músicas do gênero
    // Por enquanto, apenas mostra um snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gênero: ${genre.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

