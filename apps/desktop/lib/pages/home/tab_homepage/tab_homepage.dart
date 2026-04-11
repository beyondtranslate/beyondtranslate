import 'package:biyi_app/includes.dart';
import 'package:flutter/material.dart';

class TabHomepageScene extends StatefulWidget {
  const TabHomepageScene({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabHomepageSceneState();
}

class _TabHomepageSceneState extends State<TabHomepageScene> {
  Widget _buildBody(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.max,
      children: [],
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return const CustomAppBar(
      title: Text('比译'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }
}
