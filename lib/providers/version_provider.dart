import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class VersionService {
  static const String _collectionName = 'app_config';
  static const String _documentName = 'version_control';

  Future<void> checkVersion(BuildContext context) async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;
      debugPrint('Current App Version: $currentVersion');

      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_documentName)
          .get();

      if (!doc.exists) {
        debugPrint('Firestore: Document $_documentName does not exist in $_collectionName');
        return;
      }

      final data = doc.data() as Map<String, dynamic>;
      final String minVersion = data['min_version'] ?? '1.0.0';
      final String latestVersion = data['latest_version'] ?? '1.0.0';
      final String storeUrl = data['store_url'] ?? '';
      final bool forceUpdate = data['force_update'] ?? false;
      
      debugPrint('Firestore Data: min=$minVersion, latest=$latestVersion, force=$forceUpdate');

      // 1. Cek jika di bawah versi minimum (Wajib Update)
      if (_isVersionLower(currentVersion, minVersion)) {
        debugPrint('Action: Showing Mandatory Update Dialog (Lower than Min Version)');
        if (context.mounted) {
          _showUpdateDialog(context, storeUrl, true);
        }
      } 
      // 2. Cek jika di bawah versi terbaru dan force_update aktif (Wajib Update)
      else if (_isVersionLower(currentVersion, latestVersion) && forceUpdate) {
        debugPrint('Action: Showing Mandatory Update Dialog (Force Update Active)');
        if (context.mounted) {
          _showUpdateDialog(context, storeUrl, true);
        }
      }
    } catch (e) {
      debugPrint('Error checking version: $e');
    }
  }

  bool _isVersionLower(String current, String target) {
    try {
      // Bersihkan string dari build number (+9) atau pre-release (-beta)
      // Contoh: "1.0.3+9" -> "1.0.3"
      String cleanCurrent = current.split('+')[0].split('-')[0];
      String cleanTarget = target.split('+')[0].split('-')[0];

      List<int> currentParts = cleanCurrent.split('.').map((e) => int.parse(e.trim())).toList();
      List<int> targetParts = cleanTarget.split('.').map((e) => int.parse(e.trim())).toList();

      int maxLength = currentParts.length > targetParts.length ? currentParts.length : targetParts.length;

      for (int i = 0; i < maxLength; i++) {
        int v1 = i < currentParts.length ? currentParts[i] : 0;
        int v2 = i < targetParts.length ? targetParts[i] : 0;
        
        if (v1 < v2) return true;
        if (v1 > v2) return false;
      }
      return false;
    } catch (e) {
      debugPrint('Error parsing version strings: $current vs $target -> $e');
      return false;
    }
  }

  void _showUpdateDialog(BuildContext context, String url, bool mandatory) {
    showDialog(
      context: context,
      barrierDismissible: !mandatory,
      builder: (context) => PopScope(
        canPop: !mandatory,
        child: AlertDialog(
          backgroundColor: const Color(0xFF2E0249),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Update Tersedia',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            mandatory
                ? 'Versi aplikasi Anda sudah terlalu lama. Silakan update ke versi terbaru untuk melanjutkan permainan.'
                : 'Versi baru tersedia. Apakah Anda ingin memperbarui sekarang?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            if (!mandatory)
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('NANTI', style: TextStyle(color: Colors.grey)),
              ),
            ElevatedButton(
              onPressed: () async {
                final Uri uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AAFF),
                foregroundColor: const Color(0xFF2E0249),
              ),
              child: const Text('UPDATE SEKARANG'),
            ),
          ],
        ),
      ),
    );
  }
}
