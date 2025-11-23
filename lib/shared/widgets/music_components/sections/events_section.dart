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
          final controller = context.read<EventsController>();
          controller.initialize();
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
          return _buildErrorState(context, controller.errorMessage ?? 'Erro desconhecido');
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
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
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
          height: 200,
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
    final imageUrl = event.cover;
    final finalImageUrl = (imageUrl != null && imageUrl.isNotEmpty)
        ? imageUrl
        : 'https://via.placeholder.com/300';
    
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: DesignTokens.spaceMD),
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
                height: 140,
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                  color: Colors.grey[800],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                  child: CachedImage(
                    imageUrl: finalImageUrl,
                    fit: BoxFit.cover,
                    width: 280,
                    height: 140,
                    cacheWidth: 280,
                    cacheHeight: 140,
                    errorWidget: Container(
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.event,
                        color: Colors.white54,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    event.locationTag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
            ),
            const SizedBox(height: 8),
          Text(
            event.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            event.venue,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
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
}

