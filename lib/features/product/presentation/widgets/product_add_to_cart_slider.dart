import 'dart:math' as math;

import 'package:afterhours/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductAddToCartSlider extends StatefulWidget {
  final String price;
  final VoidCallback? onAddToCart;

  const ProductAddToCartSlider({
    super.key,
    required this.price,
    required this.onAddToCart,
  });

  @override
  State<ProductAddToCartSlider> createState() => _ProductAddToCartSliderState();
}

class _ProductAddToCartSliderState extends State<ProductAddToCartSlider>
    with TickerProviderStateMixin {
  static const _completionThreshold = 0.78;
  static const _thumbSize = 48.0;
  static const _trackInset = 5.0;

  late final AnimationController _settleController;
  late final AnimationController _pulseController;
  Animation<double>? _settleAnimation;

  double _progress = 0;
  bool _isDragging = false;
  bool _isCompleting = false;
  bool _isComplete = false;
  int _interactionId = 0;

  bool get _isEnabled => widget.onAddToCart != null;

  @override
  void initState() {
    super.initState();
    _settleController = AnimationController(vsync: this)
      ..addListener(() {
        final animation = _settleAnimation;
        if (animation != null && mounted) {
          setState(() => _progress = animation.value.clamp(0.0, 1.0));
        }
      });
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant ProductAddToCartSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onAddToCart != widget.onAddToCart && !_isEnabled) {
      _interactionId++;
      _settleController.stop();
      setState(() {
        _progress = 0;
        _isDragging = false;
        _isCompleting = false;
        _isComplete = false;
      });
    }
  }

  @override
  void dispose() {
    _interactionId++;
    _settleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _animateProgress(
    double target, {
    required Duration duration,
    required Curve curve,
  }) async {
    _settleController.stop();
    _settleController.duration = duration;
    _settleAnimation = Tween<double>(
      begin: _progress,
      end: target,
    ).animate(CurvedAnimation(parent: _settleController, curve: curve));
    await _settleController.forward(from: 0);
  }

  void _handleDragStart(DragStartDetails details) {
    if (!_isEnabled || _isCompleting || _isComplete) return;
    _settleController.stop();
    HapticFeedback.selectionClick();
    setState(() => _isDragging = true);
  }

  void _handleDragUpdate(DragUpdateDetails details, double travel) {
    if (!_isEnabled || !_isDragging || travel <= 0) return;
    setState(() {
      _progress = (_progress + details.delta.dx / travel).clamp(0.0, 1.0);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isEnabled || !_isDragging) return;
    setState(() => _isDragging = false);

    final projectedProgress = _progress + (details.primaryVelocity ?? 0) / 2200;
    if (projectedProgress >= _completionThreshold) {
      _complete();
    } else {
      HapticFeedback.lightImpact();
      _animateProgress(
        0,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutBack,
      );
    }
  }

  Future<void> _complete() async {
    if (!_isEnabled || _isCompleting || _isComplete) return;

    final interactionId = ++_interactionId;
    setState(() {
      _isDragging = false;
      _isCompleting = true;
    });

    HapticFeedback.mediumImpact();
    await _animateProgress(
      1,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
    if (!mounted || interactionId != _interactionId) return;

    widget.onAddToCart?.call();
    HapticFeedback.heavyImpact();
    setState(() {
      _isCompleting = false;
      _isComplete = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 1050));
    if (!mounted || interactionId != _interactionId) return;

    setState(() => _isComplete = false);
    await _animateProgress(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutExpo,
    );
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final activeColor = _isEnabled ? AppColors.yellow : AppColors.textMuted;

    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: _isEnabled
          ? 'Slide to add item to cart for ${widget.price}'
          : 'Out of stock',
      value: _isComplete ? 'Added to cart' : null,
      onTap: _isEnabled ? _complete : null,
      child: SizedBox(
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final safeProgress = _progress.clamp(0.0, 1.0);
            final travel = math.max(
              0.0,
              constraints.maxWidth - (_trackInset * 2) - _thumbSize,
            );
            final thumbLeft = _trackInset + (travel * safeProgress);

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragStart: _handleDragStart,
              onHorizontalDragUpdate: (details) =>
                  _handleDragUpdate(details, travel),
              onHorizontalDragEnd: _handleDragEnd,
              onTap: _isEnabled ? _complete : null,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  final pulse = reduceMotion ? 0.35 : _pulseController.value;
                  final glowStrength = _isComplete
                      ? 0.42
                      : (0.10 + (_progress * 0.24));

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    height: 58,
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(29),
                      border: Border.all(
                        color: _isComplete ? AppColors.white : activeColor,
                        width: _isDragging || _isComplete ? 1.8 : 1.3,
                      ),
                      boxShadow: _isEnabled
                          ? [
                              BoxShadow(
                                color: activeColor.withValues(
                                  alpha: glowStrength,
                                ),
                                blurRadius: 10 + (_progress * 12),
                                spreadRadius: -4,
                              ),
                            ]
                          : null,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: safeProgress,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    activeColor.withValues(alpha: 0.34),
                                    activeColor.withValues(alpha: 0.10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 140),
                          opacity: _progress > 0.18 ? 0 : 1,
                          child: _SliderLabel(
                            price: widget.price,
                            enabled: _isEnabled,
                            pulse: pulse,
                            color: activeColor,
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 160),
                          opacity: _progress > 0.18 && !_isComplete ? 1 : 0,
                          child: Text(
                            _isCompleting ? 'ALMOST THERE' : 'KEEP SLIDING',
                            style: AppTextStyles.buttonSecondary.copyWith(
                              color: activeColor,
                              fontSize: 12,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 160),
                          opacity: _isComplete ? 1 : 0,
                          child: Text(
                            'ADDED TO CART',
                            style: AppTextStyles.buttonSecondary.copyWith(
                              color: AppColors.white,
                              fontSize: 13,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Positioned(
                          left: thumbLeft,
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 140),
                            curve: Curves.easeOutBack,
                            scale: _isDragging ? 1.07 : 1,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOut,
                              width: _thumbSize,
                              height: _thumbSize,
                              decoration: BoxDecoration(
                                color: _isComplete
                                    ? AppColors.white
                                    : activeColor,
                                shape: BoxShape.circle,
                                boxShadow: _isEnabled
                                    ? [
                                        BoxShadow(
                                          color: activeColor.withValues(
                                            alpha: 0.28 + (_progress * 0.25),
                                          ),
                                          blurRadius: 8 + (_progress * 10),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                      scale: CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutBack,
                                      ),
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    ),
                                child: Icon(
                                  _isComplete
                                      ? Icons.check_rounded
                                      : Icons.arrow_forward_rounded,
                                  key: ValueKey(
                                    _isComplete ? 'complete' : 'arrow',
                                  ),
                                  color: AppColors.black,
                                  size: _isComplete ? 27 : 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SliderLabel extends StatelessWidget {
  final String price;
  final bool enabled;
  final double pulse;
  final Color color;

  const _SliderLabel({
    required this.price,
    required this.enabled,
    required this.pulse,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return Text(
        'OUT OF STOCK',
        style: AppTextStyles.buttonSecondary.copyWith(
          color: color,
          fontSize: 13,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              '$price  •  SLIDE TO ADD',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.buttonSecondary.copyWith(
                color: color,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 7),
          Opacity(
            opacity: 0.35 + (pulse * 0.65),
            child: Icon(Icons.chevron_right_rounded, color: color, size: 18),
          ),
        ],
      ),
    );
  }
}
