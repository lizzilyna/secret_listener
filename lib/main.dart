import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const SecretListenerApp());
}

class SecretListenerApp extends StatelessWidget {
  //stateless = immutabile
  const SecretListenerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          brightness: Brightness.light),
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
  double playbackRate = 1; // velocità pari a 1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
              'Secret Listener'), // const = costante perché non cambierà, Text perché è un widget di testo
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Center(
        child: Column(
          children: [
            Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR64OfUmQbGPp0nmkCe0X9Y0QtBRIAjHlIh4Q&s',
              height: 300,
            ), // Mi servono i permessi per accedere al web, li imposto come <uses-permission android:name="android.permission.INTERNET" /> in C:\Users\ACER\Desktop\flutter\secret_listener\android\app\src\main\AndroidManifest.xml cioè android\secret_listener_android.iml
            result == null
                ? const Text('Scegli un vocale')
                : Text(result!
                    .files
                    .single // ! serve a comunicare che files non può essere nullo, se non lo metto mi dà errore
                    .name), // operatore ternario per gestire il costrutto condizionale: se non c'è risultato chiedi ancora, se c'è il testo cambia dinamicamente nel nome del file selezionato
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: playAudio,
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 100,
                ),
                ElevatedButton(
                  onPressed: togglePlaybackRate,
                  child: Text('x$playbackRate'),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFile,
        child: const Icon(Icons.music_note_outlined),
      ),
    );
  }

  void pickFile() async {
    result = await FilePicker.platform
        .pickFiles(); // await perché l'utente il file non lo sceglie subito, e noi sospendiamo l'esecuzione della funzione finché non lo fa. L'attesa "await" può essere usata solo in una funzione asincrona, perciò scrivo async prima delle graffe
    setState(
        () {}); //la funzione setState fa cambiare l'interfaccia, la scritta scegli audio diventa il nome del file scelto
  }

  void playAudio() async {
    //var source = DeviceFileSource(result!.files.single.path!);
    if (audioPlayer.state == PlayerState.playing) {
      await audioPlayer.pause();
    } else {
      if (result != null) {
        await audioPlayer.play(DeviceFileSource(result!.files.single
            .path!)); // metodo play di Audioplayer, che accetta la src come argomento
      }
    }
  }

  // Future<void> _play() async {
  //   await player.resume();
  //   setState(() => _playerState = PlayerState.playing);
  // }

  // Future<void> _pause() async {
  //   await player.pause();
  //   setState(() => _playerState = PlayerState.paused);
  // }

  // Future<void> _stop() async {
  //   await player.stop();
  //   setState(() {
  //     _playerState = PlayerState.stopped;
  //     _position = Duration.zero;
  //   });
  // }

  void togglePlaybackRate() {
    playbackRate = playbackRate == 1 ? 2 : 1;
    audioPlayer.setPlaybackRate(playbackRate);
    setState(() {});
  }
}
