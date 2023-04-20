import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
    if (fi == null) {
      return;
    }
    setState(() {
      file = fi;
    });
  }

  deleteImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
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
              leading: Icon(Icons.verified_user),
              title: Text(
                'Personal Information',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: Icon(Icons.location_pin),
              title: Text(
                'Place and Addresses',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              trailing: Icon(Icons.chevron_right),
            ),
            Text(
              'Benefits',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text(
                'Rewards',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              trailing: Icon(Icons.chevron_right),
            ),
            Text(
              'Support',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text(
                'Help',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text(
                'Rate the App',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              trailing: Icon(Icons.chevron_right),
            ),
            Text(
              'Preferences',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text(
                'Language',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              trailing: Icon(Icons.chevron_right),
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
                  onPressed: () {},
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
