import 'package:biyi_app/includes.dart';
import 'package:flutter/material.dart';

class WordTagView extends StatelessWidget {
  const WordTagView(
    this.wordTag, {
    Key? key,
  }) : super(key: key);

  final WordTag wordTag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(2),
      ),
      constraints: const BoxConstraints(minHeight: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            wordTag.name,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 13,
                ),
          ),
        ],
      ),
    );
  }
}
