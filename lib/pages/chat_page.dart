import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:kenito/controller/bd.dart';
import 'package:kenito/controller/modulos.dart';
import 'package:kenito/models/Config.dart';
import 'package:kenito/models/Respuestas.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kenito/Utility/CustomButton.dart';
import 'package:kenito/Utility/CustomMenu.dart';
import 'package:flutter_speech/flutter_speech.dart';
// import 'package:speech_recognition/speech_recognition.dart';
import 'package:kenito/pages/home_page.dart';
import 'Dart:io';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kenito/controller/arbol.dart';

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
  final ArbolConfig serialStatus;

  ChatPage({Key key, @required this.serialStatus}) : super(key: key);

  @override
  _ChatPageState createState() => new _ChatPageState(this.serialStatus);
}

//******************************************************************* */
//****Controlador para charla del bot *** */
//******************************************************************* */
class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  ArbolConfig serialStatus;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String image;
  double tamano = 300;
  FlutterTts flutterTts;
  String _newVoiceText;

  ModuloController ArbolResponce;
  //VARIABLES tts
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.8;
  dynamic languages_tts;
  TtsState ttsState = TtsState.stopped;

  _ChatPageState(this.serialStatus);

  //VARIABLES stt
  SpeechRecognition _speech;
  Language_t selectedLang = languages.first;
  String transcription = '';
  String respuesta = '';
  final TextEditingController _textController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  var status = true;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  GifController controller;
  @override
  initState() {
    controller = GifController(vsync: this);
    GlobalConfiguration cfg = new GlobalConfiguration();
    super.initState();
    initTts();
    activateSpeechRecognizer();
    stop();
    Random random = new Random();
    this.ArbolResponce = new ModuloController(
        config: serialStatus, modulo: serialStatus.page.orden[0].modulo);
    this.ArbolResponce.mensaje_bk.page.pedir_nombre = true;
    _newVoiceText = this.ArbolResponce.mensaje_bk.page.bienvenida;
    _speak();
  }

  @override
  Widget build(BuildContext context) {
    // La aplicación esta en ejecución
    return new Scaffold(
        backgroundColor: Colors.white,
        drawer: MenuLateral(),
        body: new Center(
          child: Container(
            margin: const EdgeInsets.only(
                top: 70.0, right: 30, left: 30, bottom: 30),
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SetImagenDatos(),
                new Expanded(
                    child: new Container(
                        alignment: Alignment.center,
                        child: new Text(
                          _speechRecognitionAvailable && !_isListening
                              ? ''
                              : 'Escuchando...',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ))),
                Container(
                  child: CustomButton(
                      onPressed: () {
                        stop();
                        _speech.stop();
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new HomePage(
                                    serialStatus: this.serialStatus)));
                      },
                      mensaje: "Atras"),
                ),
              ],
            ),
          ),
        ));
  }

//******************************************************************* */
//****Identifica si en la visual debe pintar una imagen o solo la imagen de kenito *** */
//******************************************************************* */
  SetImagenDatos() {
    if (image != "" && image != null) {
      return new Column(
        children: <Widget>[
          GifImage(
            width: MediaQuery.of(context).copyWith().size.width,
            height: 200,
            controller: controller,
            image: AssetImage("assets/Kenito.gif"),
          ),
          Container(
              width: MediaQuery.of(context).copyWith().size.width, height: 50),
          new Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).copyWith().size.width,
              height: tamano,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.cover),
              )),
          Container(
              width: MediaQuery.of(context).copyWith().size.width, height: 10)
        ],
      );
    } else {
      return new Column(
        children: <Widget>[
          GifImage(
            width: MediaQuery.of(context).copyWith().size.width,
            height: 400,
            controller: controller,
            image: AssetImage("assets/Kenito.gif"),
          ),
          Container(
              width: MediaQuery.of(context).copyWith().size.width, height: 50),
          Container(
              width: MediaQuery.of(context).copyWith().size.width, height: 10)
        ],
      );
    }
  }

  void pedirNombre() {}

  /****Modulo de Speech To Text sobre los campos  */
  void activateSpeechRecognizer() {
    ////////////////speech_recognition//////////////////////////////
    print('SpeechPage.activateSpeechRecognizer... ');
    print('SpeechPage.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);
    _speech.activate('es_ES').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  // void txtTospeech() => print('SpeechPage.onCurrentLocale... $transcription');

  // void cancel() =>
  //     _speech.cancel().then((result) => setState(() => _isListening = result));

  // void stop() => _speech.stop().then((result) {
  //       setState(() => _isListening = result);
  //     });
  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });
  // void start() => _speech.listen(locale: selectedLang.code).then((result) {
  //       print('SpeechPage.start => result $result');
  //     });
  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_MyAppState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  // void onCurrentLocale(String locale) {
  //   print('SpeechPage.onCurrentLocale... $locale');
  //   setState(() => selectedLang = languages.first);
  // }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) {
    print('_MyAppState.onRecognitionResult... $text');
    setState(() => transcription = text);
  }

  void onRecognitionComplete(String text) {
    print('_MyAppState.onRecognitionComplete... $text');
    tamano = 350;
    setState(() => _isListening = false);
    debugPrint("texto completado en escucha : $text");
    if (status && text != "") {
      this.image = "";
      status = false;
      if (_newVoiceText
                  .indexOf(this.ArbolResponce.mensaje_bk.page.bienvenida) >=
              0 &&
          this.ArbolResponce.mensaje_bk.page.pedir_nombre) {
        Random random = new Random();
        this.ArbolResponce.mensaje_bk.page.nombre = text;
        this.ArbolResponce.mensaje_bk.page.pedir_nombre = false;
        this.ArbolResponce.asignacionModuloInicial(
            this.ArbolResponce.mensaje_bk.page.orden[0].modulo);
        switch (this.ArbolResponce.mensaje_ini.type) {
          case "boolmulti":
            var splitPregunta =
                this.ArbolResponce.mensaje_ini.der.pregunta.split(",");
            int randomNumber = random.nextInt(
                this.ArbolResponce.mensaje_ini.der.pregunta.split(",").length);
            this.ArbolResponce.mensaje_ini.der.pregunta =
                splitPregunta[randomNumber];
            break;
          case "image":
            this.image = this.ArbolResponce.mensaje_ini.image;
            if (this.ArbolResponce.mensaje_ini.image.indexOf("Large") >= 0) {
              tamano = 150;
            }
            _newVoiceText = this.ArbolResponce.mensaje_ini.pregunta;
            break;
          case "bool":
            _newVoiceText = this.ArbolResponce.mensaje_ini.pregunta;
            break;
          default:
            _newVoiceText = this.ArbolResponce.mensaje_ini.pregunta;
        }
        this.image = this.ArbolResponce.mensaje_ini.image;
        _speak();
      } else {
        switch (this.ArbolResponce.mensaje_ini.type) {
          case "image":
            this.ArbolResponce.GetResponseBool(text);
            _newVoiceText =
                ArbolResponce.error + ArbolResponce.mensaje_ini.pregunta;
            this.image = "";
            if (ArbolResponce.mensaje_ini.type == "respuesta") {
              status = true;
              onRecognitionComplete(text);
            } else if (ArbolResponce.mensaje_ini.type == "image") {
              if (this.ArbolResponce.mensaje_ini.image.indexOf("Large") >= 0) {
                tamano = 150;
              }
              this.image = ArbolResponce.mensaje_ini.image;
              _speak();
            } else {
              _speak();
            }
            break;
          case "bool":
            this.ArbolResponce.GetResponseBool(text);
            _newVoiceText =
                ArbolResponce.error + ArbolResponce.mensaje_ini.pregunta;
            if (ArbolResponce.mensaje_ini.type == "respuesta") {
              status = true;
              onRecognitionComplete(text);
            } else if (ArbolResponce.mensaje_ini.type == "image") {
              if (this.ArbolResponce.mensaje_ini.image.indexOf("Large") >= 0) {
                tamano = 150;
              }
              this.image = ArbolResponce.mensaje_ini.image;
              _speak();
            } else {
              _speak();
            }
            break;
          case "pregunta":
            break;
          case "boolmulti":
            this.ArbolResponce.GetResponseBool(text);
            _newVoiceText =
                ArbolResponce.error + ArbolResponce.mensaje_ini.pregunta;
            _speak();
            break;
          case "respuesta":
            switch (this.ArbolResponce.mensaje_ini.pregunta) {
              case "@Gracias":
                _newVoiceText = "Gracias por todo";
                _speak();
                this.ArbolResponce.mensaje_bk.page.pedir_nombre = true;
                this.serialStatus.page.pedir_nombre = true;
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            new HomePage(serialStatus: this.serialStatus)));
                break;
              case "@Dolor":
                break;
              case "@Charla":
                var pre = new Pregunta(
                    key: 0,
                    type: "dialogflow",
                    pregunta: "preguntame lo que quieras",
                    respuesta: "",
                    image: "",
                    izq: new Pregunta(),
                    der: new Pregunta());
                ArbolResponce.mensaje_ini = pre;
                _newVoiceText = pre.pregunta;
                text = "";
                _speak();
                break;
              default:
            }
            break;
          case "dialogflow":
            _handleSubmitted(text);
            debugPrint("respuesta" + respuesta);
            text = "";
            break;
          default:
        }
      }
    }
    if (text == "") {
      debugPrint("texto completado en escucha esta en limpio : $text");
    }
  }

  void errorHandler() {
    debugPrint("Error");
    GlobalConfiguration cfg = new GlobalConfiguration();
    var serial = cfg.getValue("serial");
    if (this.ArbolResponce.mensaje_bk.page.pedir_nombre) {
      _newVoiceText = this.ArbolResponce.mensaje_bk.page.exepcion +
          this.ArbolResponce.mensaje_bk.page.bienvenida;
    } else {
      _newVoiceText = this.ArbolResponce.mensaje_bk.page.exepcion +
          this.ArbolResponce.mensaje_ini.pregunta;
    }
    activateSpeechRecognizer();
    _speak();
  }

  /****Modulo de DialogFlow sobre los campos  */
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

  /****Modulo de TTS sobre los campos  */
  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _getLanguages() async {
    languages_tts = await flutterTts.getLanguages;
    if (languages_tts != null) setState(() => languages_tts);
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();
    flutterTts.setLanguage(languages.first.code);
    flutterTts.setStartHandler(() {
      setState(() {
        controller.repeat(min: 0, max: 10, period: Duration(milliseconds: 300));
        print("playing " + _newVoiceText);
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete tts");
        controller.stop();
        ttsState = TtsState.stopped;
        _isListening = false;
        status = true;
        if (_speechRecognitionAvailable && !_isListening) {
          // () =>
          start();
        }
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
