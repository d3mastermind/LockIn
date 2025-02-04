import 'package:flutter/material.dart';

import 'package:lock_in/crypt_service.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const LockIn());
}

class LockIn extends StatelessWidget {
  const LockIn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _encryptTextController = TextEditingController();
  final TextEditingController _decryptTextController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  String _encryptedText = '';
  String _decryptedText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _showWelcomeDialog();
  }

  void _showWelcomeDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Welcome to Encryption App'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('This app uses a custom XOR-based encryption algorithm.'),
              SizedBox(height: 10),
              Text('Warnings:'),
              Text('- Do not use this for highly sensitive data.'),
              Text('- Keep your secret key secure.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  void _encrypt() {
    String plaintext = _encryptTextController.text;
    String key = _keyController.text;
    setState(() {
      _encryptedText = CryptService.encrypt(plaintext, key);
    });
  }

  void _decrypt() {
    String encrypted = _decryptTextController.text;
    String key = _keyController.text;
    setState(() {
      _decryptedText = CryptService.decrypt(encrypted, key);
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encryption App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Encrypt'),
            Tab(text: 'Decrypt'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Encryption Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _encryptTextController,
                  decoration: InputDecoration(
                    labelText: 'Plaintext',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _keyController,
                  decoration: InputDecoration(
                    labelText: 'Secret Key',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _encrypt,
                  child: Text('Encrypt'),
                ),
                SizedBox(height: 16),
                if (_encryptedText.isNotEmpty)
                  GestureDetector(
                    onTap: () => _copyToClipboard(_encryptedText),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _encryptedText,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Decryption Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _decryptTextController,
                  decoration: InputDecoration(
                    labelText: 'Encrypted Text',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _keyController,
                  decoration: InputDecoration(
                    labelText: 'Secret Key',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _decrypt,
                  child: Text('Decrypt'),
                ),
                SizedBox(height: 16),
                if (_decryptedText.isNotEmpty)
                  GestureDetector(
                    onTap: () => _copyToClipboard(_decryptedText),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _decryptedText,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
