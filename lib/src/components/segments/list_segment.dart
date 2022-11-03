import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../managers/managers.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import 'segments.dart';

class ListSegment extends Segment {
  const ListSegment({
    required this.wallets,
    required this.onPressed,
    String title = "",
    Key? key,
  })  : _title = title,
        super(key: key);

  final String _title;
  final Future<List<Wallet>> wallets;
  final void Function(Wallet wallet) onPressed;

  @override
  Widget build(BuildContext context) {
    final settings = SettingsManager.instance.walletListSettings;
    final widgetManager = CustomWidgetManager.instance;
    final walletData = useFuture(wallets);

    itemBuilder(context, index) {
      final wallet = walletData.data![index];
      final imageUrl =
          'https://registry.walletconnect.org/logo/sm/${walletData.data![index]}.jpeg';
      return widgetManager.walletListItemBuilder?.call(
            context,
            settings,
            index,
            wallet,
            imageUrl,
          ) ??
          Padding(
            padding: settings.listPadding,
            child: GestureDetector(
              onTap: () => onPressed(wallet),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: settings.itemPadding,
                      child: Text(
                        wallet.name,
                        style: settings.itemTextStyle,
                      ),
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: settings.itemImageShadowColor ??
                              context.theme().shadow.withOpacity(0.3),
                          blurRadius: settings.itemImageShadowBlurRadius,
                          spreadRadius: settings.itemImageShadowBlurRadius,
                        ),
                      ],
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: settings.itemImageSize,
                    ),
                  ),
                  Padding(
                    padding: settings.itemIconPadding,
                    child: Icon(
                      settings.itemIconData,
                      size: settings.itemIconSize,
                      color: settings.itemIconColor,
                    ),
                  ),
                ],
              ),
            ),
          );
    }

    if (!walletData.hasData) {
      return Center(
        child: CircularProgressIndicator(
          color: context.theme().onBackground,
        ),
      );
    }

    return widgetManager.walletListPageBuilder?.call(
          context,
          settings,
          walletData.data!.length,
          itemBuilder,
        ) ??
        Column(
          children: [
            Padding(
              padding: settings.titlePadding,
              child: Text(
                settings.title,
                textAlign: settings.titleTextAlign,
                style: settings.titleTextStyle,
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: walletData.data!.length,
                  itemBuilder: itemBuilder),
            ),
          ],
        );
  }

  @override
  String title() => _title;
}
