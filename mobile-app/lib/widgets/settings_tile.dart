import 'package:flutter/material.dart';
import 'package:mentalhealthapp/widgets/theme_switch.dart';

class SettingsTile extends StatefulWidget {
  const SettingsTile({super.key});

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  void showBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text('Settings',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              ThemeSwitch(),
              SizedBox(height: 30),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
   // var userProvider = Provider.of<UserProvider>(context);
    return ListTile(
      title: Text('Settings'),
      trailing: Icon(Icons.arrow_forward,color:Colors.deepPurple ,),
      
      
      onTap: () {
        showBottomSheet();
      },
    );
  }
}
