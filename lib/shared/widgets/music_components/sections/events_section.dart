import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../design/design_tokens.dart';
import '../../../../features/music_library/presentation/controllers/events_controller.dart';
import '../../../../features/music_library/data/models/event_model.dart';
import '../section_title.dart';
import '../../base_components/cached_image.dart';

class EventsSection extends StatefulWidget {
  const EventsSection({super.key});

  @override
  State<EventsSection> createState() => _EventsSectionState();
}

class _EventsSectionState extends State<EventsSection> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized && mounted) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<EventsController>().initialize();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return _buildLoadingState();
        }

        if (controller.hasError) {
          return _buildErrorState(controller.errorMessage ?? 'Erro desconhecido');
        }

        if (controller.events.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildContent(context, controller.events);
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: DesignTokens.eventCardHeight + DesignTokens.spaceXL + DesignTokens.albumCardTextHeight,
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spaceMD),
      child: Center(
        child: Text(
          error,
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<EventModel> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Eventos'),
        const SizedBox(height: DesignTokens.spaceMD),
        SizedBox(
          height: DesignTokens.eventCardHeight + DesignTokens.spaceXL + DesignTokens.albumCardTextHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
            itemCount: events.length,
            itemBuilder: (context, index) {
              return _buildEventCard(context, events[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event) {
    const cardWidth = DesignTokens.eventCardWidth;
    const cardHeight = DesignTokens.eventCardHeight;
    
    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: DesignTokens.cardSpacing),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            'event-detail',
            pathParameters: {'eventId': event.id.toString()},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: cardHeight,
                  width: cardWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(DesignTokens.cardBorderRadius),
                    color: Colors.grey[800],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.cardBorderRadius),
                    child: _buildEventImage(event, cardWidth, cardHeight),
                  ),
                ),
                Positioned(
                  top: DesignTokens.spaceSM,
                  left: DesignTokens.spaceSM,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: DesignTokens.spaceXS,
                      vertical: DesignTokens.spaceXS / 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(DesignTokens.opacityStrong),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
                    ),
                    child: Text(
                      event.locationTag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: DesignTokens.fontSizeXS,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spaceSM),
            Text(
              event.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: DesignTokens.fontSizeSM,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: DesignTokens.spaceXS),
            Text(
              event.venue,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: DesignTokens.fontSizeXS,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventImage(EventModel event, double width, double height) {
    final photoUrl = event.photo;
    
    if (photoUrl != null && photoUrl.isNotEmpty && photoUrl != 'null') {
      return CachedImage(
        imageUrl: photoUrl,
        fit: BoxFit.cover,
        width: width,
        height: height,
        cacheWidth: width.toInt(),
        cacheHeight: height.toInt(),
        errorWidget: _buildPlaceholder(width, height),
      );
    }
    
    return _buildPlaceholder(width, height);
  }

  Widget _buildPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[800],
      child: const Icon(
        Icons.event,
        color: Colors.white54,
        size: DesignTokens.iconXL,
      ),
    );
  }
}
