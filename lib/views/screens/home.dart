import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

enum TextOptions { wordNumbers, encodeMessage, investWord }

class _HomeViewState extends State<HomeView> {
  static final _textController = TextEditingController();
  static final _textFormKey = GlobalKey<FormState>();

  TextOptions? _textOptions = TextOptions.wordNumbers;

  bool _isEncodeText = false;
  bool _isUpperCase = false;

  void _onItemSelected(TextOptions? value) {
    setState(() {
      _textOptions = value;
    });
  }

  void _onEncodeText() {
    setState(() {
      _isEncodeText = !_isEncodeText;
    });
  }

  void _onUpperText() {
    setState(() {
      _isUpperCase = !_isUpperCase;
    });
  }

  void _onContinuePressed() {
    if (_textFormKey.currentState!.validate()) {
      String textValue = _textController.value.text;

      switch (_textOptions) {
        case TextOptions.encodeMessage:
          String textValue = _textController.value.text;
          if (_isEncodeText) {
            textValue = textValue.replaceAll('@', 'A');
            textValue = textValue.replaceAll('3', 'E');
            textValue = textValue.replaceAll('L', 'i');
            textValue = textValue.replaceAll('0', 'O');
            textValue = textValue.replaceAll('&', 'U');
            textValue = textValue.replaceAll('_', ' ');
          } else {
            textValue = textValue.replaceAll('A', '@');
            textValue = textValue.replaceAll('E', '3');
            textValue = textValue.replaceAll('i', 'L');
            textValue = textValue.replaceAll('O', '0');
            textValue = textValue.replaceAll('U', '&');
            textValue = textValue.replaceAll(' ', '_');
          }
          _onEncodeText();
          _textController.text = textValue;

          break;
        case TextOptions.investWord:
          List<String> text = textValue.split("");
          Iterable<String> reversedTextIterable = text.reversed;
          List<String> reversedTextList = reversedTextIterable.toList();
          _textController.text = reversedTextList.join();
          break;
        case TextOptions.wordNumbers:
          List<String> words = textValue.split(" ");
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Resultado"),
                    content: Text("Numero de palabras: ${words.length}"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context, "Ok");
                          },
                          child: const Text("Ok"))
                    ],
                  ));
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mensaje"),
        elevation: 0,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return <PopupMenuItem>[
                PopupMenuItem(
                  child: const Text("Eliminar Vocales"),
                  onTap: () {
                    String textValue = _textController.value.text;
                    textValue = textValue.replaceAll('a', '');
                    textValue = textValue.replaceAll('A', '');
                    textValue = textValue.replaceAll('e', '');
                    textValue = textValue.replaceAll('E', '');
                    textValue = textValue.replaceAll('i', '');
                    textValue = textValue.replaceAll('I', '');
                    textValue = textValue.replaceAll('o', '');
                    textValue = textValue.replaceAll('O', '');
                    textValue = textValue.replaceAll('u', '');
                    textValue = textValue.replaceAll('U', '');
                    _textController.text = textValue;
                  },
                ),
                PopupMenuItem(
                  child: const Text("Mayuscula / Minúscula"),
                  onTap: () {
                    String textValue = _textController.value.text;
                    if (_isUpperCase) {
                      _textController.text = textValue.toLowerCase();
                    } else {
                      _textController.text = textValue.toUpperCase();
                    }
                    _onUpperText();
                  },
                ),
              ];
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _textFormKey,
          child: Column(children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Ingresa el texto a transformar"),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: TextFormField(
                  controller: _textController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor ingresa un texto";
                    }
                    return null;
                  },
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                      hintText: "Escribe algo aqui...", filled: true)),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Selecciona una opcion"),
            ),
            RadioListTile<TextOptions>(
                title: const Text("Numero de palabras"),
                value: TextOptions.wordNumbers,
                groupValue: _textOptions,
                onChanged: _onItemSelected),
            RadioListTile<TextOptions>(
                title: const Text("Codificar mensaje"),
                value: TextOptions.encodeMessage,
                groupValue: _textOptions,
                onChanged: _onItemSelected),
            RadioListTile<TextOptions>(
                title: const Text("Invertir mensaje"),
                value: TextOptions.investWord,
                groupValue: _textOptions,
                onChanged: _onItemSelected),
            TextButton(
                onPressed: _onContinuePressed, child: const Text("Continuar"))
          ]),
        ),
      ),
    );
  }
}
