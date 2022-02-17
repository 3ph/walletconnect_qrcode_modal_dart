import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

abstract class TestConnector {
  Future<SessionStatus?> connect(BuildContext context);

  Future<String> sendTestingAmount(SessionStatus session);

  void registerListeners(
    OnConnectRequest? onConnect,
    OnSessionUpdate? onSessionUpdate,
    OnDisconnect? onDisconnect,
  );
}
