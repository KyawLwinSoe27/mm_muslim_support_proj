import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/common/bloc/download_file_bloc/download_file_bloc.dart';
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
      body: BlocBuilder<DownloadFileBloc, DownloadFileState>(
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
            _pdfController ??= PdfController(
              document: PdfDocument.openFile(state.filePath),
            );
      
            return SizedBox.expand(
              child: PdfView(
                controller: _pdfController!,
                scrollDirection: Axis.horizontal,
                pageSnapping: true,
                physics: const BouncingScrollPhysics(),
              ),
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