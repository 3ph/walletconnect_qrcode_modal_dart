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

  /// Create a new session.
  Future<SessionStatus> connect(
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

  Future<void> sendCustomRequest({
    required String method,
    required List<dynamic> params,
    String? topic,
  }) async =>
      await _connector.sendCustomRequest(method: method, params: params);

  /// Kill the current session.
  Future<void> killSession({String? sessionError}) async =>
      await _connector.killSession(sessionError: sessionError);

  /// Set the default signing provider.
  void setDefaultProvider(WalletConnectProvider provider) =>
      _connector.setDefaultProvider(provider);

  /// Sign a transaction.
  Future<List<Uint8List>> signTransaction(
    Uint8List transaction, {
    Map<String, dynamic> params = const {},
    WalletConnectProvider? provider,
  }) async =>
      await _connector.signTransaction(transaction,
          params: params, provider: provider);

  /// Sign transactions.
  Future<List<Uint8List>> signTransactions(
    List<Uint8List> transactions, {
    Map<String, dynamic> params = const {},
    WalletConnectProvider? provider,
  }) async =>
      await _connector.signTransactions(transactions,
          params: params, provider: provider);

  /// Register callback listeners.
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

  Future<SessionStatus> _createSessionWithModal(
    BuildContext context, {
    int? chainId,
  }) async {
    return await _connector.createSession(
      chainId: chainId,
      onDisplayUri: (uri) async => await showDialog(
          context: context,
          useSafeArea: true,
          barrierDismissible: true,
          builder: (context) => ModalMainPage(uri: uri)),
    );
  }
}
