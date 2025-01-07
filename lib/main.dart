import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

class Pino {
  static const TextStyle pino = TextStyle(
      fontSize: 20,
      color: Colors.white,
      backgroundColor: Colors.pink,
      fontWeight: FontWeight.w400);
}

class Gino {
  static const TextStyle gino = TextStyle(
      fontSize: 18,
      color: Colors.pink,
      backgroundColor: Colors.white,
      fontWeight: FontWeight.w500);
}

void main() {
  runApp(const SecretListenerApp());
}

class SecretListenerApp extends StatelessWidget {
  //stateless = immutabile
  const SecretListenerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SecretListenerHomepage(),
    );
  }
}

class SecretListenerHomepage extends StatefulWidget {
  const SecretListenerHomepage({super.key});

  @override
  State<SecretListenerHomepage> createState() => _SecretListenerHomepageState();
}

class _SecretListenerHomepageState extends State<SecretListenerHomepage> {
  FilePickerResult? result; //metodi definiti sotto coi plugin Flutter
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double playbackRate = 1; // velocità pari a 1

  // void requestPermission() async {
  //   var status = await Permission.storage.request();
  //   if (status.isGranted) {
  //     debugPrint("Permessi concessi!");
  //   } else {
  //     debugPrint("Permessi negati.");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text('Secret Listener', style: Pino.pino),
        ), // const = costante perché non cambierà, Text perché è un widget di testo
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 70),
            Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR64OfUmQbGPp0nmkCe0X9Y0QtBRIAjHlIh4Q&s',
              height: 300,
            ), // Mi servono i permessi per accedere al web, li imposto come <uses-permission android:name="android.permission.INTERNET" /> in C:\Users\ACER\Desktop\flutter\secret_listener\android\app\src\main\AndroidManifest.xml cioè android\secret_listener_android.iml

            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                result == null
                    ? const Text(
                        'Scegli un vocale ',
                        style: Gino.gino,
                      )
                    : Text(result!
                        .files
                        .single // ! serve a comunicare che files non può essere nullo, se non lo metto mi dà errore
                        .name), // operatore ternario per gestire il costrutto condizionale: se non c'è risultato chiedi ancora, se c'è il testo cambia dinamicamente nel nome del file selezionato
                const SizedBox(
                  width: 20,
                ),
                FloatingActionButton(
                  onPressed: pickFile,
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.music_note),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: playAudio,
                  backgroundColor: Colors.pink,
                  child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40, color: Colors.white),
                ),
                const SizedBox(
                  width: 30,
                ),
                FloatingActionButton(
                  onPressed: togglePlaybackRate,
                  backgroundColor: Colors.pink,
                  child: Text(
                    'x$playbackRate',
                    style: Pino.pino,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void pickFile() async {
    String directoryWhatsApp =
        '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media';

    ///WhatsApp Voice Notes';

    result = await FilePicker.platform.pickFiles(
        initialDirectory: directoryWhatsApp,
        type: FileType.custom,
        allowedExtensions: [
          'opus',
          'm4a'
        ]); // await perché l'utente il file non lo sceglie subito, e noi sospendiamo l'esecuzione della funzione finché non lo fa. L'attesa "await" può essere usata solo in una funzione asincrona, perciò scrivo async prima delle graffe
    setState(
        () {}); //la funzione setState fa cambiare l'interfaccia, la scritta scegli audio diventa il nome del file scelto
  }

  void playAudio() async {
    //var source = DeviceFileSource(result!.files.single.path!);
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      if (result != null) {
        await audioPlayer.play(DeviceFileSource(result!.files.single
            .path!)); // metodo play di Audioplayer, che accetta la src come argomento
      }
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void togglePlaybackRate() {
    playbackRate = playbackRate == 1 ? 2 : 1;
    audioPlayer.setPlaybackRate(playbackRate);
    setState(() {});
  }
}
