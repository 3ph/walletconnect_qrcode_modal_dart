import 'package:json_annotation/json_annotation.dart';

part 'wallet.g.dart';

@JsonSerializable()
class Wallet {
  final String id;
  final String name;
  final String? description;
  final String? homepage;
  final List<String> chains;

  final WalletAppLinks app;
  final WalletLinks mobile;
  final WalletLinks desktop;
  final WalletMetadata metadata;

  Wallet({
    required this.id,
    required this.name,
    required this.description,
    required this.homepage,
    required this.chains,
    required this.app,
    required this.mobile,
    required this.desktop,
    required this.metadata,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
  Map<String, dynamic> toJson() => _$WalletToJson(this);
}

@JsonSerializable()
class WalletLinks {
  final String? native;
  final String? universal;

  WalletLinks({
    required this.native,
    required this.universal,
  });

  factory WalletLinks.fromJson(Map<String, dynamic> json) =>
      _$WalletLinksFromJson(json);
  Map<String, dynamic> toJson() => _$WalletLinksToJson(this);
}

@JsonSerializable()
class WalletAppLinks {
  final String? browser;
  final String? ios;
  final String? android;

  WalletAppLinks({
    required this.browser,
    required this.ios,
    required this.android,
  });

  factory WalletAppLinks.fromJson(Map<String, dynamic> json) =>
      _$WalletAppLinksFromJson(json);
  Map<String, dynamic> toJson() => _$WalletAppLinksToJson(this);
}

@JsonSerializable()
class WalletMetadata {
  final String? shortName;

  WalletMetadata({
    required this.shortName,
  });

  factory WalletMetadata.fromJson(Map<String, dynamic> json) =>
      _$WalletMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$WalletMetadataToJson(this);
}
