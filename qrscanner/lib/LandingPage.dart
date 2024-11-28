import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrscanner/providers/theme_provider.dart';

class LandingPage extends HookWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    final pageController = usePageController();

    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) => selectedIndex.value = index,
              children: [
                _buildHomePage(context),
                const QRScannerView(),
                const HistoryView(),
                const ProfileView(),
              ],
            ),
          ),

          // Custom Bottom Navigation
          Positioned(
            bottom: 20.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              height: 70.h,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                    label: 'Home',
                    index: 0,
                    selectedIndex: selectedIndex.value,
                    onTap: () {
                      selectedIndex.value = 0;
                      pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.qr_code_scanner_outlined,
                    selectedIcon: Icons.qr_code_scanner,
                    label: 'Scan',
                    index: 1,
                    selectedIndex: selectedIndex.value,
                    onTap: () {
                      selectedIndex.value = 1;
                      pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.history_outlined,
                    selectedIcon: Icons.history,
                    label: 'History',
                    index: 2,
                    selectedIndex: selectedIndex.value,
                    onTap: () {
                      selectedIndex.value = 2;
                      pageController.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.person_outline,
                    selectedIcon: Icons.person,
                    label: 'Profile',
                    index: 3,
                    selectedIndex: selectedIndex.value,
                    onTap: () {
                      selectedIndex.value = 3;
                      pageController.animateToPage(
                        3,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ],
              ),
            ),
          ).animate().slideY(
                begin: 2,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required int selectedIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).iconTheme.color,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Faaiz Akhtar',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 24.r,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  'FA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          _buildQuickActions(context),
          SizedBox(height: 30.h),
          _buildRecentScans(context),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionCard(
              context,
              icon: Icons.qr_code_scanner,
              label: 'Scan QR',
              onTap: () {},
            ),
            _buildActionCard(
              context,
              icon: Icons.history,
              label: 'History',
              onTap: () {},
            ),
            _buildActionCard(
              context,
              icon: Icons.settings,
              label: 'Settings',
              onTap: () {},
            ),
          ],
        ),
      ],
    ).animate().fadeIn().slideX(
          begin: -0.2,
          duration: const Duration(milliseconds: 500),
        );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32.sp,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentScans(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Scans',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.w),
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.qr_code,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: Text(
                  'Scanned QR ${index + 1}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Scanned 2 hours ago',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ],
    ).animate().fadeIn().slideX(
          begin: 0.2,
          duration: const Duration(milliseconds: 500),
          delay: const Duration(milliseconds: 200),
        );
  }
}

class QRScannerView extends StatefulWidget {
  const QRScannerView({super.key});

  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: cameraController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty && isScanning) {
              isScanning = false;
              String code = barcodes.first.rawValue ?? '';
              _handleScannedCode(code);
            }
          },
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 250.w,
                  height: 250.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Expanded(child: SizedBox()),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Align QR code within frame',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleScannedCode(String code) {
    HapticFeedback.mediumImpact();
    // Handle the scanned code here
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
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              'QR Code Scanned!',
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              code,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      isScanning = true;
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Scan Another'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryView extends HookWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scan History',
            style: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.w),
                    leading: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.qr_code,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: Text(
                      'Scanned QR ${index + 1}',
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
                          'https://example.com/qr${index + 1}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Scanned on ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}',
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
                        PopupMenuItem(
                          child: Row(
                            children: [
                              const Icon(Icons.copy),
                              SizedBox(width: 8.w),
                              const Text('Copy'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              const Icon(Icons.share),
                              SizedBox(width: 8.w),
                              const Text('Share'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              const Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8.w),
                              const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          const _ProfileHeader(),
          SizedBox(height: 32.h),
          const _ProfileMenu(),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            'JD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Faaiz Akhtar',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'john.doe@example.com',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _ProfileMenu extends ConsumerWidget {
  const _ProfileMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return Column(
      children: [
        _buildMenuItem(
          context,
          icon: Icons.person_outline,
          title: 'Edit Profile',
          onTap: () {},
        ),
        _buildMenuItem(
          context,
          icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
          title: 'Dark Mode',
          trailing: Switch.adaptive(
            value: isDarkMode,
            onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
            activeColor: Theme.of(context).primaryColor,
          ),
          onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
        ),
        _buildMenuItem(
          context,
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          onTap: () {},
        ),
        _buildMenuItem(
          context,
          icon: Icons.security_outlined,
          title: 'Privacy & Security',
          onTap: () {},
        ),
        _buildMenuItem(
          context,
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () {},
        ),
        _buildMenuItem(
          context,
          icon: Icons.logout,
          title: 'Logout',
          textColor: Colors.red,
          onTap: () => Navigator.of(context).pushReplacementNamed('/'),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Widget? trailing,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: textColor ?? Theme.of(context).iconTheme.color,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        trailing: trailing ??
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: textColor ?? Colors.grey,
            ),
      ),
    );
  }
}
