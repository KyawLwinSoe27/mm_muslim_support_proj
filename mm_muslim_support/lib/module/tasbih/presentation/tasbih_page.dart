import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/tasbih_model.dart';
import 'package:mm_muslim_support/module/tasbih/cubit/tasbih_counter_cubit.dart';
import 'package:mm_muslim_support/utility/dialog_utils.dart';

class TasbihPage extends StatefulWidget {
  const TasbihPage({super.key, required this.tasbih});
  static String routeName = 'tasbih';
  final List<TasbihModel> tasbih;

  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Pre-feed the required information to the Cubit when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cubit = context.read<TasbihCounterCubit>();
        cubit.total = widget.tasbih[cubit.state.tasbihIndex].count;
        cubit.tasbihListLength = widget.tasbih.length;
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
    HapticFeedback.lightImpact();
    final cubit = context.read<TasbihCounterCubit>();
    cubit.increment(cubit.state.tasbihIndex);
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocConsumer<TasbihCounterCubit, TasbihCounterState>(
        listener: (context, state) {
          final cubit = context.read<TasbihCounterCubit>();
          cubit.total = widget.tasbih[state.tasbihIndex].count;
          cubit.tasbihListLength = widget.tasbih.length;
          
          if (state.finished) {
            HapticFeedback.heavyImpact();
            DialogUtils.showSuccessDialog(context, 'Tasbih Finished \nAlhamdulillah');
          } else if (state.count == 0 && state.tasbihIndex > 0) {
             HapticFeedback.mediumImpact(); // phase transition
          }
        },
        builder: (context, state) {
          final currentTasbih = widget.tasbih[state.tasbihIndex];
          final progress = currentTasbih.count > 0 
              ? (state.count / currentTasbih.count).clamp(0.0, 1.0) 
              : 0.0;
              
          // Ensure we don't display counts that have already completed the goal visually right before transition
          final displayCount = state.count > currentTasbih.count ? currentTasbih.count : state.count;

          return SafeArea(
            child: Column(
              children: [
                // Header with back button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Tasbih',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Steps indicator (if there are multiple tasbihs in sequence)
                      if (widget.tasbih.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Step ${state.tasbihIndex + 1} of ${widget.tasbih.length}',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      // Tasbih Arabic Text Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                currentTasbih.arabic,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 40,
                                  height: 1.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Amiri', // Assuming standard arabic font
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentTasbih.translation,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 64),

                      // Interactive Counter Tap Target
                      GestureDetector(
                        onTapDown: _onTapDown,
                        onTapUp: _onTapUp,
                        onTapCancel: _onTapCancel,
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: child,
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Progress Ring
                              SizedBox(
                                width: 260,
                                height: 260,
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 0, end: progress),
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, child) {
                                    return CircularProgressIndicator(
                                      value: value,
                                      strokeWidth: 12,
                                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.colorScheme.primary,
                                      ),
                                      strokeCap: StrokeCap.round,
                                    );
                                  },
                                ),
                              ),
                              // Big Tap Button
                              Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      theme.colorScheme.primary.withValues(alpha: 0.1),
                                      theme.colorScheme.primary.withValues(alpha: 0.02),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                    BoxShadow(
                                      color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '$displayCount',
                                        style: TextStyle(
                                          fontSize: 72,
                                          fontWeight: FontWeight.w800,
                                          color: theme.colorScheme.primary,
                                          height: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'of ${currentTasbih.count}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.primary.withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Inner tap ripple visual
                              Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Bottom Reset Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 48.0),
                  child: IconButton.filledTonal(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.read<TasbihCounterCubit>().reset();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    iconSize: 32,
                    padding: const EdgeInsets.all(16),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.errorContainer,
                      foregroundColor: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
