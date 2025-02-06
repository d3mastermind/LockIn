import 'package:flutter/material.dart';
import 'package:lock_in/crypt_service.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const LockIn());
}

class LockIn extends StatefulWidget {
  const LockIn({super.key});

  @override
  State<LockIn> createState() => _LockInState();
}

class _LockInState extends State<LockIn> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Encryption App',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: HomePage(
        isDarkMode: _isDarkMode,
        onThemeToggle: toggleTheme,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

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
          title: const Text('Welcome to Lock In Encryption App'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                  'This app uses AES encryption with a 32-byte key and CBC mode.'),
              SizedBox(height: 10),
              Text('⚠️ Warnings:'),
              Text('- Do not use this for highly sensitive data.'),
              Text('- Keep your secret key secure.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
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
      _encryptedText = CryptService.encryptText(plaintext, key);
    });
  }

  void _decrypt() {
    String encrypted = _decryptTextController.text;
    String key = _keyController.text;
    setState(() {
      _decryptedText = CryptService.decryptText(encrypted, key);
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onClear,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: onClear,
        ),
      ),
    );
  }

  Widget _buildOutputContainer(String text) {
    return GestureDetector(
      onTap: () => _copyToClipboard(text),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.copy, size: 16),
                SizedBox(width: 4),
                Text('Tap to copy', style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Lock In',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onThemeToggle,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Encrypt"),
                  SizedBox(width: 10),
                  Icon(Icons.lock_outline_rounded),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Decrypt"),
                  SizedBox(width: 10),
                  Icon(Icons.lock_open_outlined),
                ],
              ),
            ),
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
                _buildTextField(
                  controller: _encryptTextController,
                  label: 'Plaintext',
                  onClear: () => setState(() => _encryptTextController.clear()),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _keyController,
                  label: 'Secret Key',
                  onClear: () => setState(() => _keyController.clear()),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _encrypt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Encrypt'),
                ),
                const SizedBox(height: 16),
                if (_encryptedText.isNotEmpty)
                  _buildOutputContainer(_encryptedText),
              ],
            ),
          ),
          // Decryption Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTextField(
                  controller: _decryptTextController,
                  label: 'Encrypted Text',
                  onClear: () => setState(() => _decryptTextController.clear()),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _keyController,
                  label: 'Secret Key',
                  onClear: () => setState(() => _keyController.clear()),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _decrypt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Decrypt'),
                ),
                const SizedBox(height: 16),
                if (_decryptedText.isNotEmpty)
                  _buildOutputContainer(_decryptedText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
