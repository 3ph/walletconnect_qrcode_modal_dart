// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      homepage: json['homepage'] as String?,
      chains:
          (json['chains'] as List<dynamic>).map((e) => e as String).toList(),
      app: WalletAppLinks.fromJson(json['app'] as Map<String, dynamic>),
      mobile: WalletLinks.fromJson(json['mobile'] as Map<String, dynamic>),
      desktop: WalletLinks.fromJson(json['desktop'] as Map<String, dynamic>),
      metadata:
          WalletMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'homepage': instance.homepage,
      'chains': instance.chains,
      'app': instance.app,
      'mobile': instance.mobile,
      'desktop': instance.desktop,
      'metadata': instance.metadata,
    };

WalletLinks _$WalletLinksFromJson(Map<String, dynamic> json) => WalletLinks(
      native: json['native'] as String?,
      universal: json['universal'] as String?,
    );

Map<String, dynamic> _$WalletLinksToJson(WalletLinks instance) =>
    <String, dynamic>{
      'native': instance.native,
      'universal': instance.universal,
    };

WalletAppLinks _$WalletAppLinksFromJson(Map<String, dynamic> json) =>
    WalletAppLinks(
      browser: json['browser'] as String?,
      ios: json['ios'] as String?,
      android: json['android'] as String?,
    );

Map<String, dynamic> _$WalletAppLinksToJson(WalletAppLinks instance) =>
    <String, dynamic>{
      'browser': instance.browser,
      'ios': instance.ios,
      'android': instance.android,
    };

WalletMetadata _$WalletMetadataFromJson(Map<String, dynamic> json) =>
    WalletMetadata(
      shortName: json['shortName'] as String?,
    );

Map<String, dynamic> _$WalletMetadataToJson(WalletMetadata instance) =>
    <String, dynamic>{
      'shortName': instance.shortName,
    };
