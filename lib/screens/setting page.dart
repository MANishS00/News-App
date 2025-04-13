import 'package:flutter/material.dart';

import '../main.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey)),
                child: SwitchListTile(
                  activeColor: Colors.white30,
                  title: Text('Dark Theme'),
                  value: themeNotifier.value == ThemeMode.dark,
                  onChanged: (value) {
                    themeNotifier.value =
                    value ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => About()));
                },
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "About News App",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Column(
        children: [
          Center(
            child: Text(
              "About News App",
              style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text("Stay informed and connected with the world around you through our all-in-one News App. Designed for speed, simplicity, and accuracy, our app delivers the latest headlines, breaking news alerts, and in-depth articles from reliable and trusted sources across the globe. Whether you’re tracking world events, following financial markets, or catching up on entertainment and lifestyle trends, we’ve got you covered. \n\n Our smart algorithm curates news based on your preferences, ensuring a personalized feed that reflects what matters most to you. With categories ranging from politics, sports, technology, and health, to science, travel, and more, you can explore stories from multiple perspectives all in one place. \n\n Enjoy features like offline reading, dark mode, bookmarking, and push notifications so you never miss a major update. The intuitive interface is designed for smooth browsing and quick access, making your news experience seamless and enjoyable. \n\n Download the app today and take control of how you stay informed—anytime, anywhere."),
          ),
        ],
      ),
    );
  }
}
