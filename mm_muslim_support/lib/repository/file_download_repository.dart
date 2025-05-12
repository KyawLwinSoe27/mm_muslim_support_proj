import 'package:mm_muslim_support/core/enums/folder.dart';
import 'package:mm_muslim_support/service/api_service.dart';
import 'package:mm_muslim_support/service/file_management_service.dart';

abstract class FileRepository {
  Future<String> downloadAndSaveFile({
    required String fileUrl,
    required String fileName,
    required Folder folder,
    required Function(int received, int total) onReceiveProgress,
  });
}

class FileRepositoryImplementation extends FileRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<String> downloadAndSaveFile({
    required String fileUrl,
    required String fileName,
    required Folder folder,
    required Function(int received, int total) onReceiveProgress,
  }) async {
    final dir = await FileManagementService.getDownloadDirectory(folder);
    final filePath = '${dir.path}/$fileName';

    await _apiService.downloadFile(
      url: fileUrl,
      savePath: filePath,
      onReceiveProgress: onReceiveProgress,
    );

    return filePath;
  }
}
