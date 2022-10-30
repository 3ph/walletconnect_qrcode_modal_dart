import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../modal_main_page.dart';
import '../models/wallet.dart';

typedef ModalWalletListRowBuilder = Widget Function(
  BuildContext context,
  Wallet wallet,
  String imageUrl,
  ModalWalletListRowWidget defaultListRowWidget,
);

class ModalWalletListWidget extends StatelessWidget {
  const ModalWalletListWidget({
    required this.url,
    required this.wallets,
    this.walletCallback,
    this.title = 'Choose your preferred wallet',
    this.titlePadding,
    this.titleTextStyle,
    this.titleTextAlign,
    this.onWalletTap,
    this.rowBuilder,
    this.loadingWidget,
    Key? key,
  }) : super(key: key);

  final String url;
  final Future<List<Wallet>> wallets;
  final WalletCallback? walletCallback;

  final String title;
  final EdgeInsets? titlePadding;
  final TextStyle? titleTextStyle;
  final TextAlign? titleTextAlign;

  final Function(Wallet wallet, String url)? onWalletTap;
  final ModalWalletListRowBuilder? rowBuilder;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: wallets,
      builder: (context, AsyncSnapshot<List<Wallet>> walletData) {
        if (walletData.hasData) {
          return Column(
            children: [
              Padding(
                padding:
                    titlePadding ?? const EdgeInsets.only(top: 16, bottom: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    title,
                    textAlign: titleTextAlign ?? TextAlign.center,
                    style: titleTextStyle ??
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey,
                            ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: walletData.data!.length,
                    itemBuilder: (context, index) {
                      final wallet = walletData.data![index];
                      final defaultRow = ModalWalletListRowWidget(
                          wallet: wallet,
                          onWalletTap: (wallet) {
                            walletCallback?.call(wallet);
                            onWalletTap?.call(wallet, url);
                          });
                      if (rowBuilder != null) {
                        return rowBuilder!.call(
                          context,
                          wallet,
                          defaultRow.imageUrl,
                          defaultRow,
                        );
                      }

                      return defaultRow;
                    }),
              ),
            ],
          );
        } else {
          return loadingWidget ??
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              );
        }
      },
    );
  }

  ModalWalletListWidget copyWith({
    EdgeInsets? titlePadding,
    TextStyle? titleTextStyle,
    TextAlign? titleTextAlign,
    ModalWalletListRowBuilder? rowBuilder,
    Widget? loadingWidget,
  }) =>
      ModalWalletListWidget(
        url: url,
        wallets: wallets,
        walletCallback: walletCallback,
        onWalletTap: onWalletTap,
        title: title,
        titlePadding: titlePadding ?? this.titlePadding,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
        titleTextAlign: titleTextAlign ?? this.titleTextAlign,
        rowBuilder: rowBuilder ?? this.rowBuilder,
        loadingWidget: loadingWidget ?? this.loadingWidget,
      );
}

class ModalWalletListRowWidget extends StatelessWidget {
  ModalWalletListRowWidget({
    required this.wallet,
    this.onWalletTap,
    this.nameWidget,
    this.namePadding,
    this.nameTextStyle,
    this.nameTextAlign,
    this.imageWidget,
    this.imageBorderRadius,
    this.imageBoxShadow,
    this.imageHeight,
    this.trailingWidget,
    Key? key,
  })  : imageUrl =
            'https://registry.walletconnect.org/logo/sm/${wallet.id}.jpeg',
        super(key: key);

  final Wallet wallet;
  final String imageUrl;
  final Function(Wallet wallet)? onWalletTap;

  final Widget? nameWidget;
  final EdgeInsets? namePadding;
  final TextStyle? nameTextStyle;
  final TextAlign? nameTextAlign;

  final Widget? imageWidget;
  final double? imageBorderRadius;
  final BoxShadow? imageBoxShadow;
  final double? imageHeight;

  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () async {
          onWalletTap?.call(wallet);
        },
        child: Row(
          children: [
            nameWidget ??
                Expanded(
                  child: Padding(
                    padding:
                        namePadding ?? const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      wallet.name,
                      style: nameTextStyle ??
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.black,
                              ),
                      textAlign: nameTextAlign,
                    ),
                  ),
                ),
            imageWidget ??
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(imageBorderRadius ?? 8),
                    boxShadow: [
                      imageBoxShadow ??
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                    ],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: imageHeight ?? 30,
                  ),
                ),
            trailingWidget ??
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  ModalWalletListRowWidget copyWith({
    Widget? nameWidget,
    EdgeInsets? namePadding,
    TextStyle? nameTextStyle,
    TextAlign? nameTextAlign,
    Widget? imageWidget,
    double? imageBorderRadius,
    BoxShadow? imageBoxShadow,
    double? imageHeight,
    Widget? trailingWidget,
    Key? key,
  }) =>
      ModalWalletListRowWidget(
        wallet: wallet,
        onWalletTap: onWalletTap,
        nameWidget: nameWidget ?? this.nameWidget,
        namePadding: namePadding ?? this.namePadding,
        nameTextStyle: nameTextStyle ?? this.nameTextStyle,
        nameTextAlign: nameTextAlign ?? this.nameTextAlign,
        imageWidget: imageWidget ?? this.imageWidget,
        imageBorderRadius: imageBorderRadius ?? this.imageBorderRadius,
        imageBoxShadow: imageBoxShadow ?? this.imageBoxShadow,
        imageHeight: imageHeight ?? this.imageHeight,
        trailingWidget: trailingWidget ?? this.trailingWidget,
        key: this.key ?? key,
      );
}
