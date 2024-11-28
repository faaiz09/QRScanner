import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannedQRsPage extends HookWidget {
  final List<String> scannedQRs;

  const ScannedQRsPage({super.key, required this.scannedQRs});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final filteredQRs = useState<List<String>>(scannedQRs);
    final selectedQRs = useState<Set<String>>({});

    useEffect(() {
      filteredQRs.value = scannedQRs;
      return null;
    }, [scannedQRs]);

    void filterQRs(String query) {
      if (query.isEmpty) {
        filteredQRs.value = scannedQRs;
      } else {
        filteredQRs.value = scannedQRs
            .where((qr) => qr.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    }

    void deleteQR(String qr) {
      scannedQRs.remove(qr);
      filterQRs(searchController.text);
      selectedQRs.value.remove(qr);
      selectedQRs.value = Set.from(selectedQRs.value);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('QR Code deleted'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          action: SnackBarAction(
            label: 'Undo',
            textColor: Colors.white,
            onPressed: () {
              scannedQRs.add(qr);
              filterQRs(searchController.text);
            },
          ),
        ),
      );
    }

    Future<void> shareQRs() async {
      if (selectedQRs.value.isEmpty) return;
      await Share.share(selectedQRs.value.join('\n'));
    }

    Future<void> copyQRs() async {
      if (selectedQRs.value.isEmpty) return;
      await Clipboard.setData(
          ClipboardData(text: selectedQRs.value.join('\n')));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${selectedQRs.value.length} QR code(s) copied'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(20.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }

    void toggleSelectAll() {
      if (selectedQRs.value.length == filteredQRs.value.length) {
        selectedQRs.value = {};
      } else {
        selectedQRs.value = Set.from(filteredQRs.value);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedQRs.value.isEmpty
              ? 'Scanned QR Codes'
              : '${selectedQRs.value.length} selected',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (selectedQRs.value.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: copyQRs,
              tooltip: 'Copy selected',
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: shareQRs,
              tooltip: 'Share selected',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                selectedQRs.value.forEach(deleteQR);
                selectedQRs.value = {};
              },
              tooltip: 'Delete selected',
            ),
          ],
          IconButton(
            icon: Icon(
              selectedQRs.value.length == filteredQRs.value.length
                  ? Icons.select_all
                  : Icons.deselect,
            ),
            onPressed: toggleSelectAll,
            tooltip: selectedQRs.value.length == filteredQRs.value.length
                ? 'Deselect all'
                : 'Select all',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: searchController,
              onChanged: filterQRs,
              decoration: InputDecoration(
                hintText: 'Search QR codes',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          filterQRs('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: filteredQRs.value.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_2,
                          size: 64.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          searchController.text.isEmpty
                              ? 'No scanned QR codes yet!'
                              : 'No matching QR codes found',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn()
                : ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: filteredQRs.value.length,
                    itemBuilder: (context, index) {
                      final qr = filteredQRs.value[index];
                      final isSelected = selectedQRs.value.contains(qr);

                      return Dismissible(
                        key: Key(qr),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => deleteQR(qr),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete QR Code'),
                              content: const Text(
                                  'Are you sure you want to delete this QR code?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          elevation: 2,
                          margin: EdgeInsets.only(bottom: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: isSelected
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : null,
                          child: ListTile(
                            onTap: () {
                              if (selectedQRs.value.isEmpty) {
                                _handleQRTap(context, qr);
                              } else {
                                if (isSelected) {
                                  selectedQRs.value =
                                      Set.from(selectedQRs.value)..remove(qr);
                                } else {
                                  selectedQRs.value =
                                      Set.from(selectedQRs.value)..add(qr);
                                }
                              }
                            },
                            onLongPress: () {
                              if (isSelected) {
                                selectedQRs.value = Set.from(selectedQRs.value)
                                  ..remove(qr);
                              } else {
                                selectedQRs.value = Set.from(selectedQRs.value)
                                  ..add(qr);
                              }
                            },
                            leading: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.qr_code_2,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            title: Text(
                              qr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Scanned on ${DateTime.now().toString().split(' ')[0]}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_isURL(qr))
                                  IconButton(
                                    icon: const Icon(Icons.open_in_new),
                                    onPressed: () => _launchURL(context, qr),
                                    tooltip: 'Open URL',
                                  ),
                                PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: const Icon(Icons.copy),
                                        title: const Text('Copy'),
                                        contentPadding: EdgeInsets.zero,
                                        onTap: () {
                                          Navigator.pop(context);
                                          Clipboard.setData(
                                              ClipboardData(text: qr));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  const Text('QR code copied'),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              margin: EdgeInsets.all(20.w),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: const Icon(Icons.share),
                                        title: const Text('Share'),
                                        contentPadding: EdgeInsets.zero,
                                        onTap: () {
                                          Navigator.pop(context);
                                          Share.share(qr);
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: const Icon(Icons.delete,
                                            color: Colors.red),
                                        title: const Text('Delete',
                                            style:
                                                TextStyle(color: Colors.red)),
                                        contentPadding: EdgeInsets.zero,
                                        onTap: () {
                                          Navigator.pop(context);
                                          deleteQR(qr);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fadeIn().slideX(
                            begin: 0.1,
                            duration:
                                Duration(milliseconds: 200 + (index * 50)),
                          );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  bool _isURL(String text) {
    return text.startsWith('http://') || text.startsWith('https://');
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open URL'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(20.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _handleQRTap(BuildContext context, String qr) {
    if (_isURL(qr)) {
      _launchURL(context, qr);
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
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
                'QR Code Content',
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              SelectableText(
                qr,
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: qr));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('QR code copied'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(20.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Share.share(qr);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}

// Provider for managing QR codes
final scannedQRsProvider =
    StateNotifierProvider<ScannedQRsNotifier, List<ScannedQR>>((ref) {
  return ScannedQRsNotifier();
});

class ScannedQRsNotifier extends StateNotifier<List<ScannedQR>> {
  ScannedQRsNotifier() : super([]);

  void addQR(String content) {
    state = [
      ...state,
      ScannedQR(
        id: DateTime.now().toString(),
        content: content,
        scannedAt: DateTime.now(),
      ),
    ];
  }

  void removeQR(String id) {
    state = state.where((qr) => qr.id != id).toList();
  }

  void clearAll() {
    state = [];
  }
}

class ScannedQR {
  final String id;
  final String content;
  final DateTime scannedAt;

  ScannedQR({
    required this.id,
    required this.content,
    required this.scannedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'scannedAt': scannedAt.toIso8601String(),
    };
  }

  factory ScannedQR.fromJson(Map<String, dynamic> json) {
    return ScannedQR(
      id: json['id'] as String,
      content: json['content'] as String,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
    );
  }
}
