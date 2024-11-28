import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DownloadedPage extends HookWidget {
  const DownloadedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedFilter = useState('All');
    final searchController = useTextEditingController();
    final downloads = useState<List<DownloadItem>>([]);
    final sortBy = useState('date'); // 'date', 'name', 'size'
    final sortAscending = useState(false);

    // Initialize downloads
    useEffect(() {
      loadDownloads(downloads);
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Downloads',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortOptions(context, sortBy, sortAscending),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: searchController,
              onChanged: (value) => _filterDownloads(value, downloads),
              decoration: InputDecoration(
                hintText: 'Search downloads',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          _filterDownloads('', downloads);
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),

          // Filter chips
          SizedBox(
            height: 50.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                _buildFilterChip(context, 'All', selectedFilter, downloads),
                SizedBox(width: 8.w),
                _buildFilterChip(
                    context, 'Documents', selectedFilter, downloads),
                SizedBox(width: 8.w),
                _buildFilterChip(context, 'Images', selectedFilter, downloads),
                SizedBox(width: 8.w),
                _buildFilterChip(context, 'Videos', selectedFilter, downloads),
              ],
            ),
          ),

          // Downloaded files list
          Expanded(
            child: downloads.value.isEmpty
                ? _buildEmptyState()
                : _buildFilesList(context, downloads),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDownloadOptions(context, downloads),
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add New', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_done_outlined,
            size: 64.sp,
            color: Colors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Downloads Yet',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your downloaded files will appear here',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    ValueNotifier<String> selectedFilter,
    ValueNotifier<List<DownloadItem>> downloads,
  ) {
    final isSelected = label == selectedFilter.value;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: () {
          selectedFilter.value = label;
          _applyFilter(label, downloads);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilesList(
    BuildContext context,
    ValueNotifier<List<DownloadItem>> downloads,
  ) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: downloads.value.length,
      itemBuilder: (context, index) {
        final item = downloads.value[index];
        return Dismissible(
          key: Key(item.id),
          background: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.delete, color: Colors.white, size: 24.sp),
              ],
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => _deleteFile(item, downloads),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete File'),
                content:
                    const Text('Are you sure you want to delete this file?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.only(bottom: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.w),
              leading: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getFileIcon(item.type),
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(
                item.name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  Text(
                    _formatFileSize(item.size),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Downloaded on ${_formatDate(item.downloadDate)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  _buildPopupMenuItem(
                    icon: Icons.open_in_new,
                    title: 'Open',
                    onTap: () => _openFile(item),
                  ),
                  _buildPopupMenuItem(
                    icon: Icons.share,
                    title: 'Share',
                    onTap: () => _shareFile(item),
                  ),
                  _buildPopupMenuItem(
                    icon: Icons.file_download,
                    title: 'Download Again',
                    onTap: () => _redownloadFile(item),
                  ),
                  _buildPopupMenuItem(
                    icon: Icons.delete,
                    title: 'Delete',
                    textColor: Colors.red,
                    onTap: () => _deleteFile(item, downloads),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PopupMenuItem _buildPopupMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return PopupMenuItem(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: textColor),
          SizedBox(width: 8.w),
          Text(title, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }

  void _showSortOptions(
    BuildContext context,
    ValueNotifier<String> sortBy,
    ValueNotifier<bool> sortAscending,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Sort by',
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            _buildSortOption(
              context,
              'Name',
              Icons.sort_by_alpha,
              sortBy,
              sortAscending,
            ),
            _buildSortOption(
              context,
              'Date',
              Icons.calendar_today,
              sortBy,
              sortAscending,
            ),
            _buildSortOption(
              context,
              'Size',
              Icons.data_usage,
              sortBy,
              sortAscending,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String title,
    IconData icon,
    ValueNotifier<String> sortBy,
    ValueNotifier<bool> sortAscending,
  ) {
    final isSelected = sortBy.value.toLowerCase() == title.toLowerCase();
    return ListTile(
      leading:
          Icon(icon, color: isSelected ? Theme.of(context).primaryColor : null),
      title: Text(title),
      trailing: isSelected
          ? Icon(
              sortAscending.value ? Icons.arrow_upward : Icons.arrow_downward,
              color: Theme.of(context).primaryColor,
            )
          : null,
      onTap: () {
        if (isSelected) {
          sortAscending.value = !sortAscending.value;
        } else {
          sortBy.value = title.toLowerCase();
          sortAscending.value = true;
        }
        Navigator.pop(context);
      },
    );
  }

  void _showDownloadOptions(
    BuildContext context,
    ValueNotifier<List<DownloadItem>> downloads,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Add New Download',
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            _buildDownloadOption(
              context,
              'Scan QR Code',
              Icons.qr_code_scanner,
              () {
                Navigator.pop(context);
                // Implement QR scanning
              },
            ),
            _buildDownloadOption(
              context,
              'Enter URL',
              Icons.link,
              () {
                Navigator.pop(context);
                _showUrlDialog(context, downloads);
              },
            ),
            _buildDownloadOption(
              context,
              'Browse Files',
              Icons.folder,
              () {
                Navigator.pop(context);
                // Implement file browsing
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _showUrlDialog(
      BuildContext context, ValueNotifier<List<DownloadItem>> downloads) {
    final urlController = TextEditingController();
    final isDownloading = ValueNotifier(false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Enter Download URL',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: 'https://',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            ValueListenableBuilder(
              valueListenable: isDownloading,
              builder: (context, downloading, child) {
                return downloading
                    ? LinearProgressIndicator(
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ValueListenableBuilder(
            valueListenable: isDownloading,
            builder: (context, downloading, child) {
              return ElevatedButton(
                onPressed: downloading
                    ? null
                    : () async {
                        if (urlController.text.isEmpty) return;
                        isDownloading.value = true;
                        try {
                          await _downloadFile(
                            urlController.text,
                            downloads,
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Download completed'),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(20.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Download failed: ${e.toString()}'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(20.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        } finally {
                          isDownloading.value = false;
                        }
                      },
                child: Text(downloading ? 'Downloading...' : 'Download'),
              );
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Future<void> _downloadFile(
      String url, ValueNotifier<List<DownloadItem>> downloads) async {
    final dio = Dio();
    final tempDir = await getTemporaryDirectory();
    final fileName = url.split('/').last;
    final savePath = '${tempDir.path}/$fileName';

    await dio.download(url, savePath);
    final file = File(savePath);
    final fileSize = await file.length();

    downloads.value = [
      ...downloads.value,
      DownloadItem(
        id: DateTime.now().toString(),
        name: fileName,
        path: savePath,
        size: fileSize,
        type: _getFileTypeFromExtension(fileName),
        downloadDate: DateTime.now(),
      ),
    ];
  }

  FileType _getFileTypeFromExtension(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
      case 'doc':
      case 'docx':
      case 'txt':
        return FileType.document;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return FileType.image;
      case 'mp4':
      case 'mov':
      case 'avi':
        return FileType.video;
      default:
        return FileType.other;
    }
  }

  IconData _getFileIcon(FileType type) {
    switch (type) {
      case FileType.document:
        return Icons.insert_drive_file;
      case FileType.image:
        return Icons.image;
      case FileType.video:
        return Icons.video_file;
      case FileType.other:
        return Icons.file_present;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> loadDownloads(
      ValueNotifier<List<DownloadItem>> downloads) async {
    // Simulate loading from storage
    await Future.delayed(const Duration(seconds: 1));
    downloads.value = [
      DownloadItem(
        id: '1',
        name: 'Sample Document.pdf',
        path: '/path/to/document.pdf',
        size: 1024 * 1024 * 2, // 2MB
        type: FileType.document,
        downloadDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      DownloadItem(
        id: '2',
        name: 'Sample Image.jpg',
        path: '/path/to/image.jpg',
        size: 1024 * 512, // 512KB
        type: FileType.image,
        downloadDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  void _filterDownloads(
      String query, ValueNotifier<List<DownloadItem>> downloads) {
    // Implement search filtering
  }

  void _applyFilter(
      String filter, ValueNotifier<List<DownloadItem>> downloads) {
    // Implement type filtering
  }

  Future<void> _openFile(DownloadItem item) async {
    // Implement file opening
  }

  Future<void> _shareFile(DownloadItem item) async {
    final xFile = XFile(item.path);
    await Share.shareXFiles([xFile], text: 'Sharing ${item.name}');
  }

  Future<void> _redownloadFile(DownloadItem item) async {
    // Implement redownload
  }

  Future<void> _deleteFile(
    DownloadItem item,
    ValueNotifier<List<DownloadItem>> downloads,
  ) async {
    try {
      final file = File(item.path);
      if (await file.exists()) {
        await file.delete();
      }
      downloads.value = downloads.value.where((i) => i.id != item.id).toList();
    } catch (e) {
      debugPrint('Error deleting file: $e');
    }
  }
}

class DownloadItem {
  final String id;
  final String name;
  final String path;
  final int size;
  final FileType type;
  final DateTime downloadDate;

  DownloadItem({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.type,
    required this.downloadDate,
  });
}

enum FileType {
  document,
  image,
  video,
  other,
}
