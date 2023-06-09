import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:murammat_app/screens/costumer/settings/customer_about_us.dart';
import 'package:murammat_app/screens/costumer/settings/customer_help_screen.dart';
import 'package:murammat_app/screens/costumer/settings/customer_language_screen.dart';
import 'package:murammat_app/screens/costumer/settings/customer_personal_info_screen.dart';
import 'package:murammat_app/screens/costumer/settings/customer_rate_screen.dart';
import 'package:murammat_app/screens/costumer/settings/customer_reward_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CostumerSettingsScreen extends StatefulWidget {
  @override
  State<CostumerSettingsScreen> createState() => _CostumerSettingsScreenState();
}

class _CostumerSettingsScreenState extends State<CostumerSettingsScreen> {
  File? file;
  var image;
  String _appVersion = 'v1.0.0';
  @override
  void initState() {
    loadImage();
    Future.delayed(Duration.zero).then((_) => getAppVersion());
    super.initState();
  }

  _openGallery() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      file = File(image!.path);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("customerImagePath", image.path.toString());
  }

  loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('customerImagePath') == null) {
      return;
    }
    File fi = File(prefs.getString('customerImagePath')!);
    setState(() {
      file = fi;
    });
  }

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: file != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white70,
                          backgroundImage: Image.file(file!).image,
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white70,
                          backgroundImage:
                              Image.asset('assets/images/placeholder.png')
                                  .image,
                        ),
                ),
              ),
              Positioned(
                left: 190,
                top: 80,
                child: GestureDetector(
                  onTap: _openGallery,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            width: 2, color: Theme.of(context).primaryColor)),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // ElevatedButton.icon(
                //   label: Text('Edit'),
                //   onPressed: _openGallery,
                //   icon: Icon(
                //     Icons.edit_rounded,
                //     size: 18,
                //   ),
                // ),
              ],
            ),
            Text(
              'Your Account',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            ListTile(
              leading: Icon(
                Icons.verified_user,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Personal Information',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => CustomerPersonalInfo()),
                  );
                },
              ),
            ),
            Text(
              'Benefits',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            ListTile(
              leading: Icon(
                Icons.card_giftcard,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Rewards',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CustomerRewardScreen(),
                  ));
                },
              ),
            ),
            Text(
              'Support',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            ListTile(
              leading: Icon(
                Icons.help,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Help',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CustomerHelpScreen(),
                  ));
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.star,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Rate the App',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CustomerRateScreen(),
                  ));
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'About Us',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CustomerAboutUs(),
                  ));
                },
              ),
            ),
            Text(
              'Preferences',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            ListTile(
              leading: Icon(
                Icons.language,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Language',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CustomerLanguageScreen(),
                  ));
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sign out',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false);
                  },
                  icon: Icon(Icons.logout),
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
            Center(
              child: Container(
                color: Colors.grey,
                height: 1,
                width: 250,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
                child: Text(
              _appVersion,
              style: TextStyle(color: Colors.grey),
            )),
            Container(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
