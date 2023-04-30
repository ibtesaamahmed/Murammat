import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:murammat_app/screens/costumer/settings/costumer_saved_places_screen.dart';
import 'package:murammat_app/screens/costumer/settings/customer_help_screen.dart';
import 'package:murammat_app/screens/costumer/settings/customer_language_screen.dart';
import 'package:murammat_app/screens/costumer/settings/customer_personal_info_screen.dart';
import 'package:murammat_app/screens/costumer/settings/customer_rate_screen.dart';
import 'package:murammat_app/screens/costumer/settings/customer_reward_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CostumerSettingsScreen extends StatefulWidget {
  @override
  State<CostumerSettingsScreen> createState() => _CostumerSettingsScreenState();
}

class _CostumerSettingsScreenState extends State<CostumerSettingsScreen> {
  File? file;
  var image;

  @override
  void initState() {
    loadImage();
    super.initState();
  }

  _openGallery() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      file = File(image!.path);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("imagePath", image.path.toString());
  }

  loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    File fi = File(prefs.getString('imagePath')!);
    setState(() {
      file = fi;
    });
  }

  deleteImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      file = null;
      prefs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                            Image.asset('assets/images/placeholder.png').image,
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: _openGallery,
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  color: Theme.of(context).errorColor,
                  onPressed: deleteImage,
                  icon: Icon(Icons.delete),
                ),
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
            ListTile(
              leading: Icon(
                Icons.location_pin,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Saved Places',
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
                    builder: (context) => CostumerAddressesPlacesScreen(),
                  ));
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
          ],
        ),
      ),
    );
  }
}
