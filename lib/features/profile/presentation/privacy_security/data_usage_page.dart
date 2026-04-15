import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';

class DataUsagePage extends StatefulWidget {
  const DataUsagePage({super.key});

  @override
  State<DataUsagePage> createState() => _DataUsagePageState();
}

class _DataUsagePageState extends State<DataUsagePage> {
  bool _analytics = true;
  bool _crash = true;
  bool _personalization = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      _analytics = sp.getBool('ps.analytics') ?? true;
      _crash = sp.getBool('ps.crash') ?? true;
      _personalization = sp.getBool('ps.personalization') ?? true;
    });
  }

  Future<void> _set(String key, bool value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Usage')),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          SwitchListTile(
            key: const Key('ps.data.analytics'),
            title: const Text('Analytics'),
            value: _analytics,
            onChanged: (bool v) {
              setState(() => _analytics = v);
              _set('ps.analytics', v);
            },
          ),
          SwitchListTile(
            key: const Key('ps.data.crash'),
            title: const Text('Crash Reports'),
            value: _crash,
            onChanged: (bool v) {
              setState(() => _crash = v);
              _set('ps.crash', v);
            },
          ),
          SwitchListTile(
            key: const Key('ps.data.personalization'),
            title: const Text('Learning Personalization'),
            value: _personalization,
            onChanged: (bool v) {
              setState(() => _personalization = v);
              _set('ps.personalization', v);
            },
          ),
        ],
      ),
    );
  }
}
