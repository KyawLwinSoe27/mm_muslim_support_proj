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

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DownloadFileBloc, DownloadFileState>(
        listener: (context, state) async {
          if (state is DownloadSuccess) {
            _pdfController ??= PdfController(
              document: PdfDocument.openFile(state.filePath),
              initialPage: state.currentPage,
            );
          }
        },
        builder: (context, state) {
          if (state is DownloadInProgress) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Downloading: ${state.progress} %'),
                const SizedBox(height: 20),
                LinearProgressIndicator(value: state.progress / 100),
              ],
            );
          } else if (state is DownloadSuccess) {
            return Stack(
              children: [
                Positioned.fill(
                  child: PdfView(
                    controller: _pdfController!,
                    scrollDirection: Axis.horizontal,
                    pageSnapping: true,
                    physics: const BouncingScrollPhysics(),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: IntrinsicWidth(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Page',
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 8,
                              ),
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onSubmitted: (value) {
                              final page = int.tryParse(value);
                              if (page != null && page > 0) {
                                _pdfController?.animateToPage(
                                  page,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Enter a valid page number'),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.bookmark_add, size: 28),
                          onPressed: () async {
                            final currentPage = _pdfController?.page ?? 1;
                            context.read<BookMarkCubit>().saveBookMark(
                              state.filePath,
                              currentPage,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Bookmark saved!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is DownloadFailure) {
            return Text('Download Failed: ${state.message}');
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
