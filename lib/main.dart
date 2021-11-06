import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'DH Key Exchange Playground'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();

  // the following controller have a default value
  TextEditingController plaintextController = TextEditingController(
      text: 'The quick brown fox jumps over the lazy dog');
  TextEditingController publicKeyController = TextEditingController();
  TextEditingController outputController = TextEditingController();

  String txtDescription =
      'Diffie Hellman Key Exchange.'
      ' Library: Libsodium';


  @override
  void initState() {
    super.initState();
    // initialize sodium (one-time)
    Sodium.init();
    descriptionController.text = txtDescription;
  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //SizedBox(height: 20),
                // form description
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  enabled: false,
                  // false = disabled, true = enabled
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Beschreibung',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 20),
                // plaintext
                TextFormField(
                  controller: plaintextController,
                  maxLines: 3,
                  maxLength: 214,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Klartext (maximal 214 Zeichen)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte Daten eingeben';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          plaintextController.text = '';
                        },
                        child: Text('Feld löschen'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                          await Clipboard.getData(Clipboard.kTextPlain);
                          plaintextController.text = data!.text!;
                        },
                        child: Text('aus Zwischenablage einfügen'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                // public key
                TextFormField(
                  controller: publicKeyController,
                  maxLines: 4,
                  maxLength: 600,
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                  // enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Öffentlicher Schlüssel',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte den Schlüssel laden oder erzeugen';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                          await Clipboard.getData(Clipboard.kTextPlain);
                          publicKeyController.text = data!.text!;
                        },
                        child: Text('Schlüssel aus Zwischenablage einfügen'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          publicKeyController.text = '';
                        },
                        child: Text('Feld löschen'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          /*
                          bool pubKeyFileExists =
                          await _fileExistsPublicKey() as bool;
                          if (pubKeyFileExists) {
                            await _readDataPublicKey();

                           */
                          print('start');
                          // BEGIN kx1: Usage: Compute a set of shared keys.
                          // generate key pairs
                          final c = await KeyExchange.randomKeys();
                          final s = await KeyExchange.randomKeys();

                          // compute session keys
                          final ck = await KeyExchange.computeClientSessionKeys(c, s.pk);
                          final sk = await KeyExchange.computeServerSessionKeys(s, c.pk);

                          // assert keys do match
                          //assert(Sodium.memcmp(ck.rx, sk.tx));
                          //assert(Sodium.memcmp(ck.tx, sk.rx));

                          print('client rx: ${Sodium.bin2hex(ck.rx)}');
                          print('client tx: ${Sodium.bin2hex(ck.tx)}');

                          print('client key: ${Sodium.bin2hex(ck.tx)}');
                          print('server key: ${Sodium.bin2hex(sk.rx)}');

                          // now use pre defined keys
                          print('now use pre defined keys');
                          final String aPrivateKeyBase64 = "yJIzp7IueQOu8l202fwI21/aNXUxXBcg3jJoLFJATlU=";
                          final String bPublicKeyBase64 =  "jVSuHjVH47PMbMaAxL5ziBS9/Z0HQK6TJLw9X3Jw6yg=";

                          final String aPublicKeyBase64 =  "b+Z6ajj7wI6pKAK5N28Hzp0Lyhv2PvHofwGY3WSm7W0=";
                          // own private key
                          String bPrivateKeyBase64 = "yNmXR5tfBXA/uZjanND+IYgGXlrFnrdUiUXesI4fOlM=";

                          final aKeypair = await KeyExchange.seedKeys(base64Decode(aPrivateKeyBase64));
                          final bKeypair = await KeyExchange.seedKeys(base64Decode(bPrivateKeyBase64));

                          // compute session keys
                          final aPrivateKey = base64Decode(aPrivateKeyBase64);
                          final aPublicKey = base64Decode(aPublicKeyBase64);
                          final bPublicKey = base64Decode(bPublicKeyBase64);
                          //final aSharedKey = await KeyExchange.computeClientSessionKeys(aKeypair, bPublicKey);

                          final aSharedKey = await Sodium.cryptoKxClientSessionKeys(aPublicKey, aPrivateKey, bPublicKey);

                          final bPrivateKey = base64Decode(bPrivateKeyBase64);
                          //final bSharedKey = await KeyExchange.computeServerSessionKeys(bKeypair, aPublicKey);
                          final bSharedKey = await Sodium.cryptoKxServerSessionKeys(bPublicKey, bPrivateKey, aPublicKey);

                          print('client key: ${Sodium.bin2hex(aSharedKey.tx)}');
                          print('server key: ${Sodium.bin2hex(bSharedKey.rx)}');

                          print('client key: ${base64Encode(aSharedKey.tx)}');
                          print('server key: ${base64Encode(bSharedKey.rx)}');



                        },
                        child: Text('Key exchange'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          // reset() setzt alle Felder wieder auf den Initalwert zurück.
                          _formKey.currentState!.reset();
                        },
                        child: Text('Formulardaten löschen'),
                      ),
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          print('start');
                          // BEGIN kx1: Usage: Compute a set of shared keys.
                          // generate key pairs
                          final c = await KeyExchange.randomKeys();
                          final s = await KeyExchange.randomKeys();

                          // compute session keys
                          final ck = await KeyExchange.computeClientSessionKeys(c, s.pk);
                          final sk = await KeyExchange.computeServerSessionKeys(s, c.pk);

                          // assert keys do match
                          //assert(Sodium.memcmp(ck.rx, sk.tx));
                          //assert(Sodium.memcmp(ck.tx, sk.rx));

                          print('client rx: ${Sodium.bin2hex(ck.rx)}');
                          print('client tx: ${Sodium.bin2hex(ck.tx)}');




                          // Wenn alle Validatoren der Felder des Formulars gültig sind.
                          if (_formKey.currentState!.validate()) {
                            String plaintext = plaintextController.text;
                            String publicKemPem = publicKeyController.text;
/*
                            String ciphertextBase64 = '';
                            try {
                              final publicKey =
                              RSAPublicKey.fromPEM(publicKemPem);
                              ciphertextBase64 =
                                  publicKey.encryptOaepToBase64(plaintext);
                            } catch (error) {
                              outputController.text =
                              'Fehler beim Verschlüsseln';
                              return;
                            }
                            // build output string
                            String _formdata =
                                'RSA-2048 OAEP SHA-1' + ':' + ciphertextBase64;
                            String jsonOutput = _returnJson(_formdata);
                            outputController.text = jsonOutput;
                            */
                          } else {
                            print("Formular ist nicht gültig");
                          }
                        },
                        child: Text('verschlüsseln'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: outputController,
                  maxLines: 15,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: 'Ausgabe',
                    hintText: 'Ausgabe',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          outputController.text = '';
                        },
                        child: Text('Feld löschen'),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final data =
                          ClipboardData(text: outputController.text);
                          await Clipboard.setData(data);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Daten in die Zwischenablage kopiert'),
                            ),
                          );
                        },
                        child: Text('in Zwischenablage kopieren'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
