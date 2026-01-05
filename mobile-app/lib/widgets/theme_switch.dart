import 'package:flutter/material.dart';

import 'package:mentalhealthapp/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({super.key});

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('Change Theme'),
        Row(
          children: [
            Switch(
                value: themeProvider.isDarkModeChecked,
                onChanged: (value) {
                  themeProvider.updateMode(darkMode: value);
                }),
            SizedBox(
              width: 10,
            ),
            Text('Dark Theme'),
          ],
        )
      ],
    );
  }
}
