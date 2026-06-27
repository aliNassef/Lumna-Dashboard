import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/remote_config.dart';

class ForceUpdateWrapper extends StatefulWidget {
  final Widget child;
  const ForceUpdateWrapper({required this.child, super.key});

  @override
  State<ForceUpdateWrapper> createState() => _ForceUpdateWrapperState();
}

class _ForceUpdateWrapperState extends State<ForceUpdateWrapper> {
  final _remoteConfig = SupabaseRemoteConfigImpl();

  @override
  void initState() {
    super.initState();
    _checkUpdate();
  }

  Future<void> _checkUpdate() async {
    final shouldUpdate = await _remoteConfig.shouldForceUpdate();
    if (shouldUpdate && mounted) {
      _showDialog();
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Update Required'),
          content: const Text(
            'A new version is required to continue using the app.',
          ),
          actions: [
            TextButton(
              onPressed: _launchStore,
              child: const Text('Update Now'),
            ),
          ],
        ),
      ),
    );
  }

  void _launchStore() {
    launchUrl(
      Uri.parse(
        Platform.isAndroid
            ? 'https://play.google.com/store/apps/details?id=com.your.app'
            : 'https://apps.apple.com/app/idYOURAPPID',
      ),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
