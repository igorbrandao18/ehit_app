import 'package:flutter/material.dart';
import '../../design/app_colors.dart';
import '../../design/design_tokens.dart';
import '../../utils/responsive_utils.dart';
import '../../../features/music_library/domain/entities/song.dart';

/// Dialog de confirmação profissional e reutilizável - Full Screen
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final IconData? icon;
  final Color? iconColor;
  final Color? confirmButtonColor;
  final bool isDestructive;
  final Widget? customContent;
  final Song? song;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.icon,
    this.iconColor,
    this.confirmButtonColor,
    this.isDestructive = false,
    this.customContent,
    this.song,
  });

  /// Método estático para exibir o dialog em tela cheia
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    IconData? icon,
    Color? iconColor,
    Color? confirmButtonColor,
    bool isDestructive = false,
    Widget? customContent,
    Song? song,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ConfirmDialog(
          title: title,
          message: message,
          confirmText: confirmText,
          cancelText: cancelText,
          icon: icon,
          iconColor: iconColor,
          confirmButtonColor: confirmButtonColor,
          isDestructive: isDestructive,
          customContent: customContent,
          song: song,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? 
        (isDestructive ? AppColors.primaryRed : AppColors.primaryRed);
    final effectiveConfirmColor = confirmButtonColor ?? 
        (isDestructive ? AppColors.primaryRed : AppColors.primaryRed);

    final horizontalPadding = ResponsiveUtils.getResponsiveSpacing(
      context,
      mobile: DesignTokens.spaceMD,
      tablet: DesignTokens.spaceLG,
      desktop: DesignTokens.spaceXL,
    );

    return Scaffold(
      backgroundColor: AppColors.solidBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: ResponsiveUtils.getScreenHeight(context) - 
                         MediaQuery.of(context).padding.top - 
                         MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // Header com música (se fornecido) ou ícone
              if (song != null) ...[
                _buildSongInfo(context),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
                  context,
                  mobile: DesignTokens.spaceMD,
                  tablet: DesignTokens.spaceLG,
                  desktop: DesignTokens.spaceXL,
                )),
              ] else if (icon != null) ...[
                Container(
                  width: ResponsiveUtils.getResponsiveImageSize(
                    context,
                    mobile: DesignTokens.iconXXL,
                    tablet: DesignTokens.iconXXL + DesignTokens.spaceMD,
                    desktop: DesignTokens.iconXXL + DesignTokens.spaceLG,
                  ),
                  height: ResponsiveUtils.getResponsiveImageSize(
                    context,
                    mobile: DesignTokens.iconXXL,
                    tablet: DesignTokens.iconXXL + DesignTokens.spaceMD,
                    desktop: DesignTokens.iconXXL + DesignTokens.spaceLG,
                  ),
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: effectiveIconColor,
                    size: ResponsiveUtils.getResponsiveIconSize(
                      context,
                      mobile: DesignTokens.iconLG,
                      tablet: DesignTokens.iconXL,
                      desktop: DesignTokens.iconXL + DesignTokens.spaceSM,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
                  context,
                  mobile: DesignTokens.spaceLG,
                  tablet: DesignTokens.spaceXL,
                  desktop: DesignTokens.spaceXL + DesignTokens.spaceMD,
                )),
              ] else
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
                  context,
                  mobile: DesignTokens.spaceLG,
                  tablet: DesignTokens.spaceXL,
                  desktop: DesignTokens.spaceXL + DesignTokens.spaceMD,
                )),

              // Título
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    mobile: DesignTokens.fontSizeXL,
                    tablet: DesignTokens.fontSizeXL + DesignTokens.fontSizeAdjustmentMedium,
                    desktop: DesignTokens.fontSizeXL + DesignTokens.fontSizeAdjustmentLarge,
                  ),
                  fontWeight: FontWeight.w700,
                  height: DesignTokens.lineHeightTight,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
                context,
                mobile: DesignTokens.spaceMD,
                tablet: DesignTokens.spaceLG,
                desktop: DesignTokens.spaceXL,
              )),

              // Mensagem ou conteúdo customizado
              customContent != null
                  ? customContent!
                  : Text(
                      message,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          mobile: DesignTokens.fontSizeSM,
                          tablet: DesignTokens.fontSizeMD,
                          desktop: DesignTokens.fontSizeLG,
                        ),
                        fontWeight: FontWeight.w400,
                        height: DesignTokens.lineHeightNormal,
                      ),
                      textAlign: TextAlign.center,
                    ),

              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
                context,
                mobile: DesignTokens.spaceLG,
                tablet: DesignTokens.spaceXL,
                desktop: DesignTokens.spaceXL + DesignTokens.spaceMD,
              )),

              // Divisor
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.1),
              ),

              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
                context,
                mobile: DesignTokens.spaceMD,
                tablet: DesignTokens.spaceLG,
                desktop: DesignTokens.spaceXL,
              )),

              // Botões de ação
              Column(
                children: [
                  // Botão Confirmar (primeiro quando destrutivo)
                  if (isDestructive) ...[
                    SizedBox(
                      width: double.infinity,
                      child: _ActionButton(
                        text: confirmText ?? 'Confirmar',
                        onPressed: () => Navigator.of(context).pop(true),
                        isPrimary: true,
                        isDestructive: isDestructive,
                        primaryColor: effectiveConfirmColor,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
                      context,
                      mobile: DesignTokens.spaceSM,
                      tablet: DesignTokens.spaceMD,
                      desktop: DesignTokens.spaceMD,
                    )),
                  ],
                  // Botão Cancelar
                  SizedBox(
                    width: double.infinity,
                    child: _ActionButton(
                      text: cancelText ?? 'Cancelar',
                      onPressed: () => Navigator.of(context).pop(false),
                      isPrimary: !isDestructive,
                      isDestructive: false,
                      primaryColor: effectiveConfirmColor,
                    ),
                  ),
                  // Botão Confirmar (segundo quando não destrutivo)
                  if (!isDestructive) ...[
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
                      context,
                      mobile: DesignTokens.spaceSM,
                      tablet: DesignTokens.spaceMD,
                      desktop: DesignTokens.spaceMD,
                    )),
                    SizedBox(
                      width: double.infinity,
                      child: _ActionButton(
                        text: confirmText ?? 'Confirmar',
                        onPressed: () => Navigator.of(context).pop(true),
                        isPrimary: true,
                        isDestructive: isDestructive,
                        primaryColor: effectiveConfirmColor,
                      ),
                    ),
                  ],
                ],
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSongInfo(BuildContext context) {
    if (song == null) return const SizedBox.shrink();

    final coverSize = ResponsiveUtils.getResponsiveImageSize(
      context,
      mobile: DesignTokens.musicCardWidth,
      tablet: DesignTokens.musicCardWidth + DesignTokens.spaceXL * 2,
      desktop: DesignTokens.musicCardWidth + DesignTokens.spaceXL * 4,
    );

    final iconSize = ResponsiveUtils.getResponsiveIconSize(
      context,
      mobile: DesignTokens.iconXL,
      tablet: DesignTokens.iconXL + DesignTokens.spaceMD,
      desktop: DesignTokens.iconXL + DesignTokens.spaceLG,
    );

    return Column(
      children: [
        // Capa do álbum
        Container(
          width: coverSize,
          height: coverSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLG),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: ResponsiveUtils.getResponsiveSpacing(
                  context,
                  mobile: 15,
                  tablet: 20,
                  desktop: 25,
                ),
                offset: Offset(
                  0,
                  ResponsiveUtils.getResponsiveSpacing(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                ),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLG),
            child: song!.imageUrl.isNotEmpty
                ? Image.network(
                    song!.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade800,
                        child: Icon(
                          Icons.music_note,
                          color: Colors.grey.shade400,
                          size: iconSize,
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey.shade800,
                    child: Icon(
                      Icons.music_note,
                      color: Colors.grey.shade400,
                      size: iconSize,
                    ),
                  ),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
          context,
          mobile: DesignTokens.spaceSM,
          tablet: DesignTokens.spaceMD,
          desktop: DesignTokens.spaceLG,
        )),
        // Título da música
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveSpacing(
              context,
              mobile: DesignTokens.spaceSM,
              tablet: DesignTokens.spaceMD,
              desktop: DesignTokens.spaceLG,
            ),
          ),
          child: Text(
            song!.title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                mobile: DesignTokens.fontSizeLG + DesignTokens.fontSizeAdjustmentSmall,
                tablet: DesignTokens.fontSizeXL - DesignTokens.fontSizeAdjustmentSmall,
                desktop: DesignTokens.fontSizeXL,
              ),
              fontWeight: FontWeight.w700,
              height: DesignTokens.lineHeightTight,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
          context,
          mobile: DesignTokens.spaceXS,
          tablet: DesignTokens.spaceSM,
          desktop: DesignTokens.spaceMD,
        )),
        // Artista
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveSpacing(
              context,
              mobile: DesignTokens.spaceSM,
              tablet: DesignTokens.spaceMD,
              desktop: DesignTokens.spaceLG,
            ),
          ),
          child: Text(
            song!.artist,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                mobile: DesignTokens.fontSizeSM,
                tablet: DesignTokens.fontSizeMD,
                desktop: DesignTokens.fontSizeLG,
              ),
              fontWeight: FontWeight.w400,
              height: DesignTokens.lineHeightNormal,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Duração (opcional)
        if (song!.duration.isNotEmpty && song!.duration != '0:00') ...[
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
            context,
            mobile: DesignTokens.spaceXS,
            tablet: DesignTokens.spaceSM,
            desktop: DesignTokens.spaceMD,
          )),
          Text(
            song!.duration,
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                mobile: DesignTokens.fontSizeXS,
                tablet: DesignTokens.fontSizeSM,
                desktop: DesignTokens.fontSizeSM + DesignTokens.fontSizeAdjustmentSmall,
              ),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Botão de ação do dialog
class _ActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDestructive;
  final Color? primaryColor;

  const _ActionButton({
    required this.text,
    required this.onPressed,
    required this.isPrimary,
    required this.isDestructive,
    this.primaryColor,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) {
        _animationController.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
              child: Builder(
                builder: (context) {
                  final buttonHeight = ResponsiveUtils.getResponsiveSpacing(
                    context,
                    mobile: 52,
                    tablet: 56,
                    desktop: 60,
                  );
                  final fontSize = ResponsiveUtils.getResponsiveFontSize(
                    context,
                    mobile: 15,
                    tablet: 16,
                    desktop: 17,
                  );
                  
                  return Container(
                    height: buttonHeight,
                    decoration: BoxDecoration(
                      color: widget.isPrimary
                          ? widget.primaryColor ?? AppColors.primaryRed
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                      border: widget.isPrimary
                          ? null
                          : Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: ResponsiveUtils.getResponsiveSpacing(
                                context,
                                mobile: 1.0,
                                tablet: 1.5,
                                desktop: 2.0,
                              ),
                            ),
                    ),
                    child: Center(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          color: widget.isPrimary
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontSize: fontSize,
                          fontWeight: widget.isPrimary
                              ? FontWeight.w700
                              : FontWeight.w600,
                          letterSpacing: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            mobile: 0.3,
                            tablet: 0.5,
                            desktop: 0.7,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          );
        },
      ),
    );
  }
}
