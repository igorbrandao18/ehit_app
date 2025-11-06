import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../features/music_library/domain/entities/song.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../../../design/app_colors.dart';
import '../../../design/design_tokens.dart';
import '../../../utils/responsive_utils.dart';
import '../../base_components/cached_image.dart';

class OfflineSongsList extends StatelessWidget {
  final List<Song> songs;
  final Function(Song, int) onSongTap;
  final Function(Song)? onMoreOptions;

  const OfflineSongsList({
    super.key,
    required this.songs,
    required this.onSongTap,
    this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: songs.length,
      separatorBuilder: (context, index) => SizedBox(
        height: DesignTokens.spaceXS,
      ),
      itemBuilder: (context, index) {
        final song = songs[index];
        return _OfflineSongListItem(
          song: song,
          index: index,
          onTap: () => onSongTap(song, index),
          onMoreOptions: onMoreOptions != null
              ? () => onMoreOptions!(song)
              : null,
        );
      },
    );
  }
}

class _OfflineSongListItem extends StatefulWidget {
  final Song song;
  final int index;
  final VoidCallback onTap;
  final VoidCallback? onMoreOptions;

  const _OfflineSongListItem({
    required this.song,
    required this.index,
    required this.onTap,
    this.onMoreOptions,
  });

  @override
  State<_OfflineSongListItem> createState() => _OfflineSongListItemState();
}

class _OfflineSongListItemState extends State<_OfflineSongListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.getDeviceType(context) == DeviceType.mobile;
    final screenWidth = MediaQuery.of(context).size.width;
    final thumbnailSize = isMobile ? 56.0 : 64.0;
    final horizontalPadding = DesignTokens.spaceMD;

    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) {
        _onTapUp();
        widget.onTap();
      },
      onTapCancel: _onTapUp,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: DesignTokens.spaceXS,
              ),
              padding: EdgeInsets.all(isMobile ? DesignTokens.spaceSM : DesignTokens.spaceMD),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(_isPressed ? 0.12 : 0.08),
                    Colors.white.withOpacity(_isPressed ? 0.06 : 0.03),
                  ],
                ),
                borderRadius: BorderRadius.circular(DesignTokens.radiusLG),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 32,
                    child: Center(
                      child: Text(
                        '${widget.index + 1}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: isMobile ? 15 : 16,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: DesignTokens.spaceSM),

                  _buildThumbnail(thumbnailSize),
                  SizedBox(width: DesignTokens.spaceMD),

                  Expanded(
                    child: _buildSongInfo(isMobile),
                  ),

                  SizedBox(width: DesignTokens.spaceSM),
                  _buildRightActions(isMobile),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThumbnail(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedImage(
              imageUrl: widget.song.imageUrl,
              fit: BoxFit.cover,
              cacheWidth: size.toInt(),
              cacheHeight: size.toInt(),
              errorWidget: Container(
                color: Colors.grey.shade800,
                child: Icon(
                  Icons.music_note,
                  color: Colors.grey.shade400,
                  size: size * 0.4,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongInfo(bool isMobile) {
    if (widget.song.duration.isEmpty || widget.song.duration == '0:00') {
      debugPrint('⚠️ Duração vazia ou inválida para: ${widget.song.title} - valor: "${widget.song.duration}"');
    }
    
    final formattedDuration = _formatDuration(widget.song.duration);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.song.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 15 : 16,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.song.artist,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            Text(
              formattedDuration,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w400,
                height: 1.0,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRightActions(bool isMobile) {
    if (widget.onMoreOptions == null) {
      return const SizedBox.shrink();
    }
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onMoreOptions,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          child: Icon(
            Icons.more_vert,
            color: Colors.white.withOpacity(0.6),
            size: 18,
          ),
        ),
      ),
    );
  }

  String _formatDuration(String duration) {
    try {
      if (duration.contains(':')) {
        final parts = duration.split(':');
        if (parts.length == 2) {
          final minutes = int.tryParse(parts[0]) ?? 0;
          final seconds = int.tryParse(parts[1]) ?? 0;
          return '$minutes:${seconds.toString().padLeft(2, '0')}';
        }
      }
      final seconds = int.tryParse(duration);
      if (seconds != null) {
        final minutes = seconds ~/ 60;
        final remainingSeconds = seconds % 60;
        return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
      }
    } catch (e) {
    }
    return duration.isEmpty ? '0:00' : duration;
  }
}

