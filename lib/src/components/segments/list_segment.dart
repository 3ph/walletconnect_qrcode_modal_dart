import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../models/models.dart';
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
    final walletData = useFuture(wallets);

    if (!walletData.hasData) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            'Choose your preferred wallet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: walletData.data!.length,
            itemBuilder: (context, index) {
              final wallet = walletData.data![index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () => onPressed(wallet),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            wallet.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .shadow
                                  .withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://registry.walletconnect.org/logo/sm/${wallet.id}.jpeg',
                          height: 30,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  String title() => _title;
}
