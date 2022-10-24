import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'components/modal_main_page.dart';
import 'models/wallet.dart';
import 'utils/utils.dart';

class WalletConnectQrCodeModal {
  // PRIVATE
  final WalletConnect _connector;

  Wallet? _wallet;

  String? _uri;

  factory WalletConnectQrCodeModal({
    WalletConnect? connector,
  }) {
    connector = connector ?? WalletConnect();

    return WalletConnectQrCodeModal._internal(connector: connector);
  }

  WalletConnectQrCodeModal._internal({
    required WalletConnect connector,
  }) : _connector = connector;

  WalletConnect get connector => _connector;

  /// Connect to a new session.
  /// [context] is needed to show the QR code dialog.
  Future<SessionStatus?> connect(
    BuildContext context, {
    int? chainId,
  }) async {
    if (_connector.connected) {
      return SessionStatus(
        chainId: _connector.session.chainId,
        accounts: _connector.session.accounts,
      );
    }

    return await _createSessionWithModal(context, chainId: chainId);
  }

  /// Kill the current session with [sessionError].
  Future<void> killSession({String? sessionError}) async =>
      await _connector.killSession(sessionError: sessionError);

  /// Try to open Wallet selected during session creation.
  /// For iOS will try to open previously selected Wallet
  /// For Android will open system dialog
  Future<void> openWalletApp() async {
    if (_uri == null) return;

    if (Utils.isIOS) {
      if (_wallet == null) return;

      await Utils.iosLaunch(wallet: _wallet!, uri: _uri!);
    } else {
      await launchUrl(Uri.parse(_uri!));
    }
  }

  /// Register callback listeners.
  /// [onConnect] is triggered when session is connected.
  /// [onSessionUpdate] is triggered when session is updated.
  /// [onDisconnect] is triggered when session is disconnected.
  void registerListeners({
    OnConnectRequest? onConnect,
    OnSessionUpdate? onSessionUpdate,
    OnDisconnect? onDisconnect,
  }) =>
      _connector.registerListeners(
        onConnect: onConnect,
        onSessionUpdate: onSessionUpdate,
        onDisconnect: onDisconnect,
      );

  /// Send custom request with [method], [params] and optional [topic].
  Future<void> sendCustomRequest({
    required String method,
    required List<dynamic> params,
    String? topic,
  }) async =>
      await _connector.sendCustomRequest(method: method, params: params);

  Future<SessionStatus?> _createSessionWithModal(
    BuildContext context, {
    int? chainId,
  }) async {
    bool isDismissed = false;
    bool isError = false;
    bool sessionCreated = false;

    // clear previous selected wallet data
    _wallet = null;
    _uri = null;

    final CancelableCompleter cancelableCompleter = CancelableCompleter();
    final Completer<SessionStatus?> completer = Completer();

    Future<SessionStatus?> createSession() async {
      try {
        final session = await _connector.createSession(
            chainId: chainId,
            onDisplayUri: (uri) async {
              _uri = uri;
              await showDialog(
                context: context,
                useSafeArea: true,
                barrierDismissible: true,
                builder: (context) => ModalMainPage(
                  uri: uri,
                  walletCallback: (wallet) => _wallet = wallet,
                ),
              );

              isDismissed = true;
              if (!sessionCreated && !isError) {
                // dialog dismissed without connecting, cancel session creation
                cancelableCompleter.operation.cancel();
                completer.complete(null);
              }
            });
        return session;
      } catch (e) {
        isError = true;
        Navigator.of(context).pop();
        rethrow;
      }
    }

    cancelableCompleter.complete(createSession());

    cancelableCompleter.operation.value.then((session) {
      sessionCreated = true;
      if (!isDismissed) {
        Navigator.of(context).pop();
      }
      if (!completer.isCompleted) {
        completer.complete(session);
      }
    }).catchError((error) {
      print(error);
      completer.completeError(error);
    });

    return completer.future;
  }

  _zinit() {
    WalletConnectStyle cc = WalletConnectStyle();
    cc.backgroundColor = Colors.red;
  }
}

class WalletConnectStyle {
  static final WalletConnectStyle _walletConnectStyle =
      WalletConnectStyle._internal();

  Color? backgroundColor;
  Color? textColor;
  Color? secondaryTextColor;
  Color? qrCodeColor;
  Color? tabBackgroundColor;
  Color? tabThumbColor;

  factory WalletConnectStyle() {
    return _walletConnectStyle;
  }

  WalletConnectStyle._internal();
}
