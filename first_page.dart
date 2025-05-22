import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class HariPasswordPage extends StatefulWidget {
  const HariPasswordPage({super.key});

  @override
  State<HariPasswordPage> createState() => _HariPasswordPageState();
}

class _HariPasswordPageState extends State<HariPasswordPage> {

  bool darkMode = false ;
  double length = 16;
  bool  enableUppercase = true;
  bool enableLowercase = true;
  bool enableNumbers = true;
  bool enableSpecialChars = true;
  String generationCompleted = '';
  String strength = '';

    final  upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    final lower = "abcdefghijklmnopqrstuvwxyz";
    final numbers = "0123456789";
    final symbols = "!@#\$%^&*()-=+[]{}|;:,.<>?";

    void generatePassword() {
      final buffer = StringBuffer();
        String selected  = "";
    if(enableUppercase) selected += upper;
    if(enableLowercase) selected += lower;
    if(enableNumbers) selected += numbers;
    if(enableSpecialChars) selected += symbols;

    if(selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enable at least one option")),
      );
      return;
    }

    final rand = Random.secure();
    for (var i = 0; i < length; i++) {
      final index = rand.nextInt(selected.length);
      buffer.write(selected[index]);
    }
    final pass = buffer.toString();

    setState(() {
        generationCompleted = pass;
        strength = Strength_of_Password(pass);
      });
    }

  String Strength_of_Password(String pass) {
    int score = 0;
    if (pass.length >= 16) score++;
    if (pass.length >= 24) score++;
    if (RegExp(r'[A-Z]').hasMatch(pass)) score++;
    if (RegExp(r'[a-z]').hasMatch(pass)) score++;
    if (RegExp(r'[0-9]').hasMatch(pass)) score++;
    if (RegExp(r'[!@#\\$%^&*(),.?":{}|<>]').hasMatch(pass)) score++;

    if (score <= 2) return 'Weak';
    if (score <= 4) return 'Medium';
    return 'Strong';
  }

  void copyToClipboard() {
    if (generationCompleted.isEmpty) return;
    Clipboard.setData(ClipboardData(text: generationCompleted));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password copied to clipboard!')),
    );
  }

  Widget HariPasswordDisplaySection() {
    if (generationCompleted.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          generationCompleted,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                'Strength: $strength',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: copyToClipboard,
            ),
          ],
        ),
      ],
    );
  }

  Widget HariSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(
          title,
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.green[900],
      activeTrackColor: Colors.green[700],
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.black12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: darkMode ? ThemeData.dark() : ThemeData.light(),
        home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text(
              'Password Generator',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true ,
          actions: [
            Row(
              children: [
                Icon(
                    Icons.brightness_medium_sharp,
                  color: Colors.black,
                ),
                const SizedBox(width: 10),
                Switch(
                  value: darkMode,
                  onChanged: (v) => setState(() => darkMode = v),
                  activeColor: Colors.white,
                  activeTrackColor: Colors.white60,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.black12,
                ),
                const SizedBox(width: 10),
                const SizedBox(height: 20),
              ],
            ),
          ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
                children: [
                  const SizedBox(height: 10),
                  HariSwitch(
                    'Enable Uppercase',
                    enableUppercase,
                        (v) => setState(() => enableUppercase = v),
                  ),
                  const SizedBox(height: 10),
                  HariSwitch(
                    'Enable Lowercase',
                    enableLowercase,
                        (v) => setState(() => enableLowercase = v),
                  ),
                  const SizedBox(height: 10),
                  HariSwitch(
                    'Enable Numbers',
                    enableNumbers,
                        (v) => setState(() => enableNumbers = v),
                  ),
                  const SizedBox(height: 10),
                  HariSwitch(
                    'Enable Special Characters',
                    enableSpecialChars,
                        (v) => setState(() => enableSpecialChars = v),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Length: ${length.toInt()}',
                  style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black ,
                  fontWeight: FontWeight.bold,
                  ),
                  ),
                  Slider(
                    min: 8,
                    max: 32,
                    divisions: 24,
                    value: length,
                  label: length.toInt().toString(),
                  onChanged: (v) => setState(() => length = v),
                  activeColor: Colors.blue,
                     thumbColor: Colors.orangeAccent,
                  ),
                  const SizedBox(height: 10),
                      HariPasswordDisplaySection(),
                  const SizedBox(height: 10),
              ],
            ),
    ),
    bottomNavigationBar: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      const Divider(
      color: Colors.grey,
      thickness: 1.5,
      height: 0,
    ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 15),
            child: ElevatedButton(
              onPressed : generatePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[900],
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Click here to Generate Password" ,
                style: const TextStyle(color: Colors.white),
              ),
    ),
          ),
          ],// Removes extra space
    ),
    ),
    );
  }
}
