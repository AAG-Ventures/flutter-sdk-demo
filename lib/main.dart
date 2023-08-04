import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:metaone_wallet_sdk/metaone_wallet_sdk.dart';
import 'package:metaone_wallet_sdk_example/sso_login.dart';
import 'package:metaone_wallet_sdk_example/utils.dart';
import 'package:metaone_wallet_sdk_example/widgets.dart';

void main() async {
  await dotenv.load();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  bool _isAuthorized = false;

  Future<void> _initializeSDK() async {
    final sdkConfig = <String, String>{
      'sdk.realm': dotenv.env['SDK_REALM'].toString(),
      'sdk.environment': dotenv.env['SDK_ENVIRONMENT'].toString(),
      'sdk.api.client.reference': dotenv.env['SDK_API_CLIENT_REFERENCE'].toString(),
      'sdk.config.url': dotenv.env['SDK_CONFIG_URL'].toString(),
      'sdk.key': dotenv.env['SDK_KEY'].toString(),
    };
    try {
      setState(() {
        _isLoading = true;
      });
      await initialize(sdkConfig);
      final sessionStatus = await getSessionActivityStatus();
      setState(() {
        _isAuthorized = sessionStatus.isActive;
        _isLoading = false;
      });
      if (!mounted) return;
      Utils.showSuccessSnackBar(context, message: 'SDK initialized.');
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  Future<void> _onLogInTapped() async {
    try {
      await Navigator.of(context).push(SSOLoginPage.route());
      setState(() {
        _isLoading = true;
      });
      final sessionStatus = await getSessionActivityStatus();
      setState(() {
        _isAuthorized = sessionStatus.isActive;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  Future<void> _onRefreshSessionTapped() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await refreshSession();
      final sessionStatus = await getSessionActivityStatus();
      setState(() {
        _isAuthorized = sessionStatus.isActive;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  Future<void> _onLogOutTapped() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await logOut();
      final sessionStatus = await getSessionActivityStatus();
      setState(() {
        _isAuthorized = sessionStatus.isActive;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  Future<void> _onOpenWalletTapped() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await openWallet();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.showErrorSnackBar(context, message: '$error');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeSDK();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MetaoneWalletSdk Example')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isAuthorized)
                      _AuthorizedView(
                        onOpenWalletTapped: _onOpenWalletTapped,
                        onRefreshSessionTapped: _onRefreshSessionTapped,
                        onLogOutTapped: _onLogOutTapped,
                      )
                    else
                      _UnauthorizedView(onLogInTapped: _onLogInTapped),
                  ],
                ),
        ),
      ),
    );
  }
}

class _UnauthorizedView extends StatelessWidget {
  const _UnauthorizedView({
    required this.onLogInTapped,
  });

  final void Function() onLogInTapped;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onPressed: onLogInTapped,
        text: 'SSO Login',
      ),
    );
  }
}

class _AuthorizedView extends StatelessWidget {
  const _AuthorizedView({
    required this.onOpenWalletTapped,
    required this.onRefreshSessionTapped,
    required this.onLogOutTapped,
  });

  final void Function() onOpenWalletTapped;
  final void Function() onRefreshSessionTapped;
  final void Function() onLogOutTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onOpenWalletTapped,
            child: const Text('Open wallet'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onRefreshSessionTapped,
            child: const Text('Refresh session'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onLogOutTapped,
            child: const Text('Log out'),
          ),
        ),
      ],
    );
  }
}
