import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/common/bloc/download_file_bloc/download_file_bloc.dart';
import 'package:mm_muslim_support/module/quran/cubit/book_mark_cubit/book_mark_cubit.dart';
import 'package:pdfx/pdfx.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  static const String routeName = '/quran_screen';

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  PdfController? _pdfController;
  int _currentPage = 1;
  int _totalPages = 0;
  bool _showControls = true;

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _showJumpToPageDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Jump to Page'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter page (1 - $_totalPages)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                final page = int.tryParse(controller.text);
                if (page != null && page > 0 && page <= _totalPages) {
                  _pdfController?.animateToPage(
                    page,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid page number between 1 and $_totalPages'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Go'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocConsumer<DownloadFileBloc, DownloadFileState>(
        listener: (context, state) async {
          if (state is DownloadSuccess && mounted) {
            _pdfController ??= PdfController(
              document: PdfDocument.openFile(state.filePath),
              initialPage: state.currentPage,
            );
            setState(() {
              _currentPage = state.currentPage;
            });
          }
        },
        builder: (context, state) {
          if (state is DownloadInProgress) {
            return _buildDownloadingView(state, theme);
          } else if (state is DownloadSuccess && _pdfController != null) {
            return _buildPdfReaderView(context, state, theme);
          } else if (state is DownloadFailure) {
            return _buildErrorView(state, theme);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDownloadingView(DownloadInProgress state, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 64,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Preparing your Quran',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Downloading files... ${state.progress}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: state.progress / 100,
                minHeight: 12,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(DownloadFailure state, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Failed to load',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(state.message),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfReaderView(BuildContext context, DownloadSuccess state, ThemeData theme) {
    return Stack(
      children: [
        // PDF Viewer
        Positioned.fill(
          child: GestureDetector(
            onTap: _toggleControls,
            child: PdfView(
              controller: _pdfController!,
              scrollDirection: Axis.horizontal,
              pageSnapping: true,
              physics: const BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(
                color: theme.colorScheme.surface,
              ),
              onPageChanged: (page) {
                setState(() => _currentPage = page);
              },
              onDocumentLoaded: (document) {
                setState(() => _totalPages = document.pagesCount);
              },
            ),
          ),
        ),

        // Top App Bar (Floating)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: _showControls ? 0 : -100,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.surface.withValues(alpha: 0.9),
                  theme.colorScheme.surface.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    '$_currentPage / ${_totalPages > 0 ? _totalPages : "-"}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Controls (Floating)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          bottom: _showControls ? MediaQuery.of(context).padding.bottom + 24 : -100,
          left: 24,
          right: 24,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      theme: theme,
                      icon: Icons.search_rounded,
                      label: 'Jump To',
                      onTap: () => _showJumpToPageDialog(context),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                    _buildControlButton(
                      theme: theme,
                      icon: Icons.bookmark_add_rounded,
                      label: 'Bookmark',
                      onTap: () {
                        context.read<BookMarkCubit>().saveBookMark(
                          state.filePath,
                          _currentPage,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.bookmark_added_rounded, color: Colors.white),
                                SizedBox(width: 12),
                                Text('Bookmark saved successfully!'),
                              ],
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: theme.colorScheme.onPrimaryContainer,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
