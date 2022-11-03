import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'components/components.dart';
import 'managers/managers.dart';
import 'settings/settings.dart';
import 'utils/utils.dart';

class WalletConnectQrCodeModal {
  factory WalletConnectQrCodeModal({
    WalletConnect? connector,
    ModalSettings? modalSettings,
    QrCodeSettings? qrCodeSettings,
    QrPageBuilder? qrPageBuilder,
    LaunchWalletSettings? launchWalletSettings,
    LaunchWalletPageBuilder? launchWalletPageBuilder,
    WalletListSettings? walletListSettings,
    WalletListPageBuilder? walletListPageBuilder,
  }) {
    connector = connector ?? WalletConnect();
    SettingsManager.instance.update(
      qrCodeSettings: qrCodeSettings,
      modalSettings: modalSettings,
      launchWalletSettings: launchWalletSettings,
      walletListSettings: walletListSettings,
    );
    CustomWidgetManager.instance.update(
      qrPageBuilder: qrPageBuilder,
      launchWalletPageBuilder: launchWalletPageBuilder,
      walletListPageBuilder: walletListPageBuilder,
    );

    return WalletConnectQrCodeModal._internal(
      connector: connector,
    );
  }

  WalletConnect get connector => _connector;
  final WalletManager _walletManager = WalletManager.instance;

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
    settingsManager.init(context);

    return await _createSessionWithModal(chainId: chainId);
  }

  /// Send custom request with [method], [params] and optional [topic].
  Future<void> sendCustomRequest({
    required String method,
    required List<dynamic> params,
    String? topic,
  }) async =>
      await _connector.sendCustomRequest(method: method, params: params);

  /// Kill the current session with [sessionError].
  Future<void> killSession({String? sessionError}) async {
    await _connector.close();
    await _connector.killSession(sessionError: sessionError);
    _walletManager.clear();
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

  // PRIVATE
  final WalletConnect _connector;
  SettingsManager get settingsManager => SettingsManager.instance;

  Future<void> openWalletApp() async {
    return await _walletManager.openWalletApp();
  }

  WalletConnectQrCodeModal._internal({
    required WalletConnect connector,
  }) : _connector = connector;

  Future<SessionStatus?> _createSessionWithModal({
    int? chainId,
  }) async {
    bool isDismissed = false;
    bool isError = false;
    bool sessionCreated = false;

    _walletManager.clear();

    final CancelableCompleter cancelableCompleter = CancelableCompleter();
    final Completer<SessionStatus?> completer = Completer();

    Future<SessionStatus?> createSession() async {
      try {
        final session = await _connector.createSession(
            chainId: chainId,
            onDisplayUri: (uri) async {
              _walletManager.update(uri: uri);
              await showDialog(
                context: settingsManager.context,
                useSafeArea: true,
                barrierDismissible: true,
                builder: (context) {
                  if (Utils.isAndroid) {
                    return const QrModalAndroid();
                  }
                  if (Utils.isIOS) {
                    return const QrModalIOS();
                  }
                  return const QrModalDesktop();
                },
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
        settingsManager.context.navigator().pop();
        rethrow;
      }
    }

    cancelableCompleter.complete(createSession());

    cancelableCompleter.operation.value.then((session) {
      sessionCreated = true;
      if (!isDismissed) {
        settingsManager.context.navigator().pop();
      }
      if (!completer.isCompleted) {
        completer.complete(session);
      }
    }).catchError((error) {
      debugPrint(error);
      completer.completeError(error);
    });

    return completer.future;
  }
}
