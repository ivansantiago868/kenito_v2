import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kenito/Utility/CustomButton.dart';
import 'package:kenito/Utility/CustomMenu.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:kenito/pages/home_page.dart';
import 'Dart:io';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped }

const languages = const [
  const Language_t('Español', 'es_ES'),
];

class Language_t {
  final String name;
  final String code;

  const Language_t(this.name, this.code);
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  SpeechRecognition _speech;
  FlutterTts flutterTts;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  Language_t selectedLang = languages.first;
  String transcription = '';
  String respuesta = '';
  final TextEditingController _textController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  var status = true;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.8;
  String _newVoiceText;
  TtsState ttsState = TtsState.stopped;
  dynamic languages_tts;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
    cancel();
    stop();
    initTts();
    _newVoiceText = "¡Hola soy Kenito!, Como esta tu dia hoy?";
    _speak();
  }

  @override
  Widget build(BuildContext context) {
    // La aplicación esta en ejecución
    return new Scaffold(
        backgroundColor: Colors.blue,
        drawer: MenuLateral(),
        body: new Center(
          child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).copyWith().size.width,
                    height: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/pngocean.com.png"),
                          fit: BoxFit.cover),
                    )),
                new Expanded(
                    child: new Container(
                        alignment: Alignment.center,
                        child: new Text(
                          _isListening ? 'Escuchando...' : 'Procesando',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ))),
                Container(
                  child: CustomButton(
                      onPressed: () {
                        cancel();
                        stop();
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new HomePage()));
                      },
                      mensaje: "Atras"),
                )
              ],
            ),
          ),
        ));
    // return new Scaffold(
    //     backgroundColor: Colors.blue,
    //     drawer: MenuLateral(),
    //     body: new Center(
    //       child: new Column(
    //         mainAxisSize: MainAxisSize.min,
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [
    //           // new Expanded(child: new Container(child: new Text(respuesta))),
    //           // CustomButtonAction(
    //           //   onPressed: _speechRecognitionAvailable && !_isListening
    //           //       ? () => start()
    //           //       : null,
    //           //   label: _isListening
    //           //       ? 'Escuchando...'
    //           //       : 'Escuchar (${selectedLang.code})',
    //           // ),
    //           new Expanded(
    //               child: new Container(
    //                   alignment: Alignment.center,
    //                   child: new Text(
    //                     _isListening ? 'Escuchando...' : 'Procesando',
    //                     textAlign: TextAlign.center,
    //                     style: new TextStyle(
    //                         fontWeight: FontWeight.bold, fontSize: 20.0),
    //                   ))),
    //           CustomButtonAction(
    //             onPressed: () {
    //               cancel();
    //               stop();
    //               Navigator.push(
    //                   context,
    //                   new MaterialPageRoute(
    //                       builder: (context) => new HomePage()));
    //             },
    //             label: 'Atras',
    //           ),
    //         ],
    //       ),
    //     ));
  }

  void txtTospeech() => print('SpeechPage.onCurrentLocale... $transcription');

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() => _speech.stop().then((result) {
        setState(() => _isListening = result);
      });
  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('SpeechPage.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    // _speech.setErrorHandler(errorHandler);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  void start() => _speech.listen(locale: selectedLang.code).then((result) {
        print('SpeechPage.start => result $result');
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('SpeechPage.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) => setState(() => transcription = text);

  void onRecognitionComplete() {
    setState(() => _isListening = false);
    debugPrint("texto completado en escucha $transcription");
    if (status) {
      status = false;
      _handleSubmitted(transcription);
      debugPrint(respuesta);
    }
  }

  void errorHandler() {
    activateSpeechRecognizer();
  }

  void _handleSubmitted(String text) {
    if (text != "") {
      _textController.clear();
      ChatMessage message = new ChatMessage(
        text: text,
        name: "Usuario",
        type: true,
      );
      setState(() {
        _messages.insert(0, message);
      });

      Response(text);
    } else {
      ChatMessage message = new ChatMessage(
        text: "No puede estar vacio",
        name: "Error",
        type: false,
      );
      setState(() {
        _messages.insert(0, message);
      });
    }
  }

  void Response(query) async {
    if (query != "") {
      _textController.clear();
      AuthGoogle authGoogle =
          await AuthGoogle(fileJson: "assets/credentials.json").build();
      Dialogflow dialogflow =
          Dialogflow(authGoogle: authGoogle, language: Language.spanish);
      AIResponse response = await dialogflow.detectIntent(query);
      // AIResponse response = await dialogflow.detectIntent("hola");
      print(response.getMessage());
      ChatMessage message = new ChatMessage(
        text: response.getMessage() ??
            new CardDialogflow(response.getListMessage()[0]).title,
        name: "Kenito",
        type: false,
      );
      setState(() {
        _messages.insert(0, message);
        respuesta = message.text.toString();
        _newVoiceText = respuesta;
        _speak();
      });
    } else {
      print("vacio");
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        var num_Palabras = _newVoiceText.split("\\s+|\n").length;
        int pal = (num_Palabras % 2);
        if (result == 1) setState(() {});
      }
    }
  }

  Future _getLanguages() async {
    languages_tts = await flutterTts.getLanguages;
    if (languages_tts != null) setState(() => languages_tts);
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();
    flutterTts.setLanguage("es-ES");
    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        status = true;
        sleep(const Duration(seconds: 1));
        start();
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }
}

class ChatMessage {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;
}
