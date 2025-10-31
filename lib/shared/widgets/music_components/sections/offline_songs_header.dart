import 'package:flutter/material.dart';
import '../../../design/app_colors.dart';
import '../../../design/design_tokens.dart';
import '../../../utils/responsive_utils.dart';

/// Header impressionante para a seção de músicas offline
class OfflineSongsHeader extends StatelessWidget {
  final int totalSongs;
  final Function()? onShufflePlay;
  final Function()? onPlayAll;

  const OfflineSongsHeader({
    super.key,
    required this.totalSongs,
    this.onShufflePlay,
    this.onPlayAll,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = ResponsiveUtils.getDeviceType(context) == DeviceType.mobile;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryRed.withOpacity(0.2),
            AppColors.primaryRed.withOpacity(0.05),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? DesignTokens.spaceMD : DesignTokens.spaceLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título e badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spaceSM,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
                    border: Border.all(
                      color: AppColors.primaryRed.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.download_done,
                        color: AppColors.primaryRed,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'OFFLINE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? DesignTokens.spaceMD : DesignTokens.spaceLG),
            
            // Estatísticas
            Text(
              '$totalSongs ${totalSongs == 1 ? 'Música' : 'Músicas'}',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 32 : 40,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            SizedBox(height: DesignTokens.spaceXS),
            Text(
              'Disponíveis offline',
              style: TextStyle(
                color: Colors.white70,
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: isMobile ? DesignTokens.spaceMD : DesignTokens.spaceLG),
            
            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    icon: Icons.play_circle_fill,
                    label: 'Tocar tudo',
                    onTap: onPlayAll,
                    isPrimary: true,
                  ),
                ),
                SizedBox(width: DesignTokens.spaceSM),
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    icon: Icons.shuffle,
                    label: 'Embaralhar',
                    onTap: onShufflePlay,
                    isPrimary: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required bool isPrimary,
  }) {
    final isMobile = ResponsiveUtils.getDeviceType(context) == DeviceType.mobile;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? DesignTokens.spaceSM : DesignTokens.spaceMD,
            horizontal: DesignTokens.spaceSM,
          ),
          decoration: BoxDecoration(
            gradient: isPrimary
                ? LinearGradient(
                    colors: [
                      AppColors.primaryRed,
                      AppColors.primaryRed.withOpacity(0.8),
                    ],
                  )
                : null,
            color: isPrimary ? null : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
            border: isPrimary
                ? null
                : Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: isMobile ? 20 : 24,
              ),
              SizedBox(width: DesignTokens.spaceXS),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

