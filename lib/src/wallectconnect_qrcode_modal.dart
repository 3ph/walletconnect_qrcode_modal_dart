import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'components/modal_main_page.dart';

class WalletConnectQrCodeModal {
  factory WalletConnectQrCodeModal({
    WalletConnect? connector,
  }) {
    connector = connector ?? WalletConnect();

    return WalletConnectQrCodeModal._internal(connector: connector);
  }

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

  /// Send custom request with [method], [params] and optional [topic].
  Future<void> sendCustomRequest({
    required String method,
    required List<dynamic> params,
    String? topic,
  }) async =>
      await _connector.sendCustomRequest(method: method, params: params);

  /// Kill the current session with [sessionError].
  Future<void> killSession({String? sessionError}) async =>
      await _connector.killSession(sessionError: sessionError);

  /// Set the default signing [provider].
  void setDefaultProvider(WalletConnectProvider provider) =>
      _connector.setDefaultProvider(provider);

  /// Sign an unsigned [transaction] with [params] by sending a request to the wallet.
  /// Default provider is used unless [provider] is specified.
  /// Returns the signed transaction bytes.
  /// Throws [WalletConnectException] if unable to sign the transaction.
  Future<List<Uint8List>> signTransaction(
    Uint8List transaction, {
    Map<String, dynamic> params = const {},
    WalletConnectProvider? provider,
  }) async =>
      await _connector.signTransaction(transaction,
          params: params, provider: provider);

  /// Sign an unsigned [transactions] with [params] by sending a request to the wallet.
  /// Default provider is used unless [provider] is specified.
  /// Returns the signed transaction bytes.
  /// Throws [WalletConnectException] if unable to sign the transactions.
  Future<List<Uint8List>> signTransactions(
    List<Uint8List> transactions, {
    Map<String, dynamic> params = const {},
    WalletConnectProvider? provider,
  }) async =>
      await _connector.signTransactions(transactions,
          params: params, provider: provider);

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

  WalletConnectQrCodeModal._internal({
    required WalletConnect connector,
  }) : _connector = connector;

  Future<SessionStatus?> _createSessionWithModal(
    BuildContext context, {
    int? chainId,
  }) async {
    try {
      bool isDismissed = false;

      final session = await _connector.createSession(
          chainId: chainId,
          onDisplayUri: (uri) async {
            await showDialog(
                context: context,
                useSafeArea: true,
                barrierDismissible: true,
                builder: (context) => ModalMainPage(uri: uri));

            // dialog dismissed
            isDismissed = true;
          });

      if (!isDismissed) {
        Navigator.of(context).pop();
      }

      return session;
    } catch (e) {
      print('Error connecting to session: $e');
    }
    return null;
  }
}
