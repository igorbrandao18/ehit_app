import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../shared/design/app_colors.dart';
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
                        SizedBox(height: DesignTokens.playerVerticalSpacing),
                        _buildEventInfoSection(context, event),
                        SizedBox(height: ResponsiveUtils.getMiniPlayerHeight(context) + DesignTokens.spaceLG),
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
    final imageUrl = event.photo ?? '';

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
            child: CachedImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: imageSize,
              height: imageSize * 0.6,
              cacheWidth: imageSize.toInt(),
              cacheHeight: (imageSize * 0.6).toInt(),
              errorWidget: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                ),
                child: Icon(
                  Icons.event,
                  color: Colors.white54,
                  size: imageSize * 0.2,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: DesignTokens.spaceLG),
        Text(
          event.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveUtils.getScreenWidth(context) * DesignTokens.playerTitleFontSizeRatio,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: DesignTokens.spaceSM),
      ],
    );
  }

  Widget _buildEventInfoSection(BuildContext context, EventModel event) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.playerHorizontalSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            context,
            icon: Icons.location_on,
            title: 'Local',
            value: event.venue,
          ),
          SizedBox(height: DesignTokens.spaceMD),
          _buildInfoCard(
            context,
            icon: Icons.place,
            title: 'Cidade',
            value: '${event.city}, ${event.state}',
          ),
          SizedBox(height: DesignTokens.spaceMD),
          _buildInfoCard(
            context,
            icon: Icons.calendar_today,
            title: 'Data',
            value: _formatDate(event.date),
          ),
          SizedBox(height: DesignTokens.spaceMD),
          _buildInfoCard(
            context,
            icon: Icons.label,
            title: 'Tag',
            value: event.locationTag,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(DesignTokens.spaceMD),
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
          SizedBox(width: DesignTokens.spaceMD),
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
                SizedBox(height: DesignTokens.spaceXS),
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

