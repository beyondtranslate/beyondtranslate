// import 'package:biyi_app/includes.dart';

import 'package:biyi_app/pages/home/tab_homepage/tab_homepage.dart';
import 'package:biyi_app/pages/home/tab_settings/tab_settings.dart';
import 'package:biyi_app/pages/home/tab_vocabulary/tab_vocabulary.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _kHomeTabHomepage = 0;
// const _kHomeTabVocabulary = 1;
// const _kHomeTabSettings = 2;

class _TabBarItem extends BottomNavigationBarItem {
  _TabBarItem({
    required Widget icon,
    required String label,
    required Widget activeIcon,
  }) : super(icon: icon, label: label, activeIcon: activeIcon);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = _kHomeTabHomepage;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildBody(BuildContext context) {
    return IndexedStack(
      index: _selectedIndex,
      children: const [
        TabHomepageScene(),
        TabVocabularyScene(),
        TabSettingsScene(),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 16,
                ),
              ]
            : null,
      ),
      child: CupertinoTabBar(
        items: [
          _TabBarItem(
            icon: const Icon(FluentIcons.home_20_regular),
            activeIcon: const Icon(FluentIcons.home_20_filled),
            label: 'Home',
          ),
          _TabBarItem(
            icon: const Icon(FluentIcons.book_20_regular),
            activeIcon: const Icon(FluentIcons.book_20_filled),
            label: 'Vocabulary',
          ),
          _TabBarItem(
            icon: const Icon(FluentIcons.settings_20_regular),
            activeIcon: const Icon(FluentIcons.settings_20_filled),
            label: 'Settings',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        iconSize: 24,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}
