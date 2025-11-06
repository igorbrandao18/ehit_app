import 'package:flutter/material.dart';
import '../../../../features/music_library/domain/entities/song.dart';
import '../../../design/app_colors.dart';
import '../../../design/design_tokens.dart';
import '../../../utils/responsive_utils.dart';
import '../../base_components/cached_image.dart';

class OfflineSongCard extends StatefulWidget {
  final Song song;
  final int index;
  final VoidCallback onTap;
  final VoidCallback? onMoreOptions;

  const OfflineSongCard({
    super.key,
    required this.song,
    required this.index,
    required this.onTap,
    this.onMoreOptions,
  });

  @override
  State<OfflineSongCard> createState() => _OfflineSongCardState();
}

class _OfflineSongCardState extends State<OfflineSongCard>
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
      end: 0.97,
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
    final thumbnailSize = isMobile ? 60.0 : 70.0;

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
              margin: EdgeInsets.only(
                bottom: DesignTokens.spaceSM,
                left: DesignTokens.spaceMD,
                right: DesignTokens.spaceMD,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.03),
                  ],
                ),
                borderRadius: BorderRadius.circular(DesignTokens.radiusLG),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusLG),
                  onTap: widget.onTap,
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? DesignTokens.spaceSM : DesignTokens.spaceMD),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.index + 1}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: isMobile ? 14 : 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: DesignTokens.spaceSM),
                        
                        _buildThumbnail(thumbnailSize),
                        SizedBox(width: DesignTokens.spaceMD),
                        
                        Expanded(
                          child: _buildSongInfo(isMobile),
                        ),
                        
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.genreCardRed.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.download_done,
                                color: AppColors.genreCardRed,
                                size: 12,
                              ),
                            ),
                            SizedBox(width: DesignTokens.spaceSM),
                            if (widget.onMoreOptions != null)
                              IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.white.withOpacity(0.6),
                                  size: 20,
                                ),
                                onPressed: widget.onMoreOptions,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
            blurRadius: 8,
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
                    Colors.black.withOpacity(0.3),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
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
        SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                widget.song.artist,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: DesignTokens.spaceXS),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: DesignTokens.spaceXS),
            Text(
              widget.song.duration,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

