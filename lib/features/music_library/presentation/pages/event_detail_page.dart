import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../../shared/widgets/base_components/cached_image.dart';
import '../controllers/events_controller.dart';
import '../../data/models/event_model.dart';

class EventDetailPage extends StatefulWidget {
  final String eventId;
  
  const EventDetailPage({
    super.key,
    required this.eventId,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsController>(
      builder: (context, controller, child) {
        final event = controller.events
            .where((e) => e.id.toString() == widget.eventId)
            .firstOrNull;

        if (event == null) {
          return GradientScaffold(
            appBar: AppBar(
              title: const Text('Evento não encontrado'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(
              child: Text(
                'Evento não encontrado',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return GradientScaffold(
          showMiniPlayer: false,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: DesignTokens.playerHorizontalSpacing,
                          ),
                          child: _buildHeaderSection(context, event),
                        ),
                        const SizedBox(height: DesignTokens.spaceLG),
                        if (event.description != null && event.description!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: DesignTokens.playerHorizontalSpacing,
                            ),
                            child: _buildDescriptionSection(context, event),
                          ),
                        if (event.description != null && event.description!.isNotEmpty)
                          const SizedBox(height: DesignTokens.spaceLG),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: DesignTokens.playerHorizontalSpacing,
                          ),
                          child: _buildEventInfoSection(context, event),
                        ),
                        if (event.links != null && event.links!.isNotEmpty)
                          const SizedBox(height: DesignTokens.spaceLG),
                        if (event.links != null && event.links!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: DesignTokens.playerHorizontalSpacing,
                            ),
                            child: _buildLinksSection(context, event),
                          ),
                        SizedBox(
                          height: ResponsiveUtils.getMiniPlayerHeight(context) +
                              DesignTokens.spaceLG,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = ResponsiveUtils.getScreenWidth(context);
    final iconSize = screenWidth * DesignTokens.playerIconSizeRatio;
    final padding = DesignTokens.playerHorizontalSpacing;
    
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, EventModel event) {
    final screenWidth = ResponsiveUtils.getScreenWidth(context);
    final imageSize = screenWidth * 0.7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: imageSize,
          height: imageSize * 0.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(DesignTokens.opacityShadow),
                blurRadius: DesignTokens.playerShadowBlur,
                offset: const Offset(0, DesignTokens.playerShadowOffset),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
            child: event.photo != null && event.photo!.isNotEmpty
                ? CachedImage(
                    imageUrl: event.photo!,
                    fit: BoxFit.cover,
                    width: imageSize,
                    height: imageSize * 0.6,
                    cacheWidth: imageSize.toInt(),
                    cacheHeight: (imageSize * 0.6).toInt(),
                    errorWidget: _buildImagePlaceholder(imageSize),
                  )
                : _buildImagePlaceholder(imageSize),
          ),
        ),
        const SizedBox(height: DesignTokens.spaceLG),
        Text(
          event.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveUtils.getScreenWidth(context) *
                DesignTokens.playerTitleFontSizeRatio,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: DesignTokens.spaceSM),
        Text(
          event.venue,
          style: TextStyle(
            color: Colors.white70,
            fontSize: ResponsiveUtils.getScreenWidth(context) *
                DesignTokens.playerFontSizeRatio,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: DesignTokens.spaceXS),
        Text(
          '${event.city}, ${event.state} - ${event.formattedDate}',
          style: TextStyle(
            color: Colors.white70,
            fontSize: ResponsiveUtils.getScreenWidth(context) *
                DesignTokens.playerFontSizeRatio,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context, EventModel event) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spaceLG),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusLG),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: DesignTokens.spaceSM),
              Text(
                'Sobre o Evento',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveUtils.getScreenWidth(context) *
                      DesignTokens.playerFontSizeRatio * 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spaceMD),
          Text(
            event.description!,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: ResponsiveUtils.getScreenWidth(context) *
                  DesignTokens.playerFontSizeRatio * 0.9,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinksSection(BuildContext context, EventModel event) {
    final links = event.links!;
    final linkEntries = links.entries.toList();

    if (linkEntries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.link,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: DesignTokens.spaceSM),
            Text(
              'Links',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveUtils.getScreenWidth(context) *
                    DesignTokens.playerFontSizeRatio * 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spaceMD),
        ...linkEntries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spaceSM),
            child: _buildLinkCard(context, entry.key, entry.value),
          );
        }),
      ],
    );
  }

  Widget _buildLinkCard(BuildContext context, String label, dynamic url) {
    if (url == null || url.toString().isEmpty) {
      return const SizedBox.shrink();
    }

    final urlString = url.toString();
    final icon = _getLinkIcon(label.toLowerCase());
    final color = _getLinkColor(label.toLowerCase());

    return GestureDetector(
      onTap: () => _launchURL(urlString),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spaceMD),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(DesignTokens.spaceSM),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: DesignTokens.spaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatLinkLabel(label),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveUtils.getScreenWidth(context) *
                          DesignTokens.playerFontSizeRatio,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spaceXS / 2),
                  Text(
                    urlString,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: ResponsiveUtils.getScreenWidth(context) *
                          DesignTokens.playerFontSizeRatio * 0.8,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getLinkIcon(String label) {
    if (label.contains('ingresso') || label.contains('ticket')) {
      return Icons.confirmation_number;
    } else if (label.contains('instagram')) {
      return Icons.camera_alt;
    } else if (label.contains('facebook')) {
      return Icons.facebook;
    } else if (label.contains('twitter') || label.contains('x')) {
      return Icons.alternate_email;
    } else if (label.contains('youtube')) {
      return Icons.play_circle;
    } else if (label.contains('site') || label.contains('web')) {
      return Icons.language;
    } else if (label.contains('whatsapp')) {
      return Icons.chat;
    } else {
      return Icons.link;
    }
  }

  Color _getLinkColor(String label) {
    if (label.contains('ingresso') || label.contains('ticket')) {
      return Colors.orange;
    } else if (label.contains('instagram')) {
      return const Color(0xFFE4405F);
    } else if (label.contains('facebook')) {
      return const Color(0xFF1877F2);
    } else if (label.contains('twitter') || label.contains('x')) {
      return Colors.blue;
    } else if (label.contains('youtube')) {
      return Colors.red;
    } else if (label.contains('whatsapp')) {
      return const Color(0xFF25D366);
    } else {
      return Colors.blue;
    }
  }

  String _formatLinkLabel(String label) {
    return label
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Não foi possível abrir o link: $url'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildImagePlaceholder(double size) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
      ),
      child: Icon(
        Icons.event,
        color: Colors.white54,
        size: size * 0.2,
      ),
    );
  }

  Widget _buildEventInfoSection(BuildContext context, EventModel event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          context,
          icon: Icons.location_on,
          title: 'Local',
          value: event.venue,
        ),
        const SizedBox(height: DesignTokens.spaceMD),
        _buildInfoCard(
          context,
          icon: Icons.place,
          title: 'Cidade',
          value: '${event.city}, ${event.state}',
        ),
        const SizedBox(height: DesignTokens.spaceMD),
        _buildInfoCard(
          context,
          icon: Icons.calendar_today,
          title: 'Data',
          value: _formatDate(event.date),
        ),
        const SizedBox(height: DesignTokens.spaceMD),
        _buildInfoCard(
          context,
          icon: Icons.label,
          title: 'Tag',
          value: event.locationTag,
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spaceMD),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white70,
            size: 24,
          ),
          const SizedBox(width: DesignTokens.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: DesignTokens.spaceXS),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Janeiro',
        'Fevereiro',
        'Março',
        'Abril',
        'Maio',
        'Junho',
        'Julho',
        'Agosto',
        'Setembro',
        'Outubro',
        'Novembro',
        'Dezembro'
      ];
      return '${date.day} de ${months[date.month - 1]} de ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
