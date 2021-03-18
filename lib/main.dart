import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid-19 Vaccine Survey',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: MyHomePage(title: 'Covid-19 Vaccine Survey'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();

  int _radioGenderValue = -1;
  bool _observedSideEffect = false;
  bool _isButtonVisible = false;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioGenderValue = value;
      _isButtonVisible = isValid();
    });
  }

  bool isValid() {
    return !containDigits(_controller1.text) &&
        !containDigits(_controller3.text) &&
        _controller1.text.trim().contains(' ') &&
        _controller1.text.isNotEmpty &&
        _controller2.text.isNotEmpty &&
        _controller3.text.isNotEmpty &&
        _controller4.text.isNotEmpty &&
        !(_observedSideEffect && _controller5.text.isEmpty) &&
        _radioGenderValue > -1;
  }

  bool containDigits(String text) {
    bool result = false;
    for (int i = 0; i < text.length; i++) {
      if (text[i].codeUnitAt(0) >= 48 && text[i].codeUnitAt(0) <= 57) {
        result = true;
      }
    }
    return result;
  }

  void _handleTextChange(text) {
    setState(() {
      _isButtonVisible = isValid();
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1880),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _controller2.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
  }

  Future<void> _showMyDialog() async {
    _radioGenderValue = -1;
    setState(() {
      _radioGenderValue = -1;
      _observedSideEffect = false;
    });
    _controller1.text = '';
    _controller2.text = '';
    _controller3.text = '';
    _controller4.text = '';
    _controller5.text = '';
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thank you'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('We received your response!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Please fill the survey',
                    ),
                    SizedBox(height: 15),
                    TextField(
                      key: Key('textFieldName'),
                      controller: _controller1,
                      onChanged: _handleTextChange,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name Surname',
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      key: Key('textFieldBirthday'),
                      controller: _controller2,
                      onChanged: _handleTextChange,
                      onTap: () => _selectDate(context),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Birthday',
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      key: Key('textFieldCity'),
                      controller: _controller3,
                      onChanged: _handleTextChange,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'City',
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      key: Key('textFieldVaccineType'),
                      controller: _controller4,
                      onChanged: _handleTextChange,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Vaccine type',
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Radio(
                          key: Key('radioFemale'),
                          value: 0,
                          groupValue: _radioGenderValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text(
                          'Female',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Radio(
                          key: Key('radioMale'),
                          value: 1,
                          groupValue: _radioGenderValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text(
                          'Male',
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        new Radio(
                          key: Key('radioOther'),
                          value: 2,
                          groupValue: _radioGenderValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text(
                          'Other',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    CheckboxListTile(
                      title: const Text('I observed side effects'),
                      value: _observedSideEffect,
                      onChanged: (bool value) {
                        setState(() {
                          _observedSideEffect = value;
                          _isButtonVisible = isValid();
                        });
                      },
                      secondary: const Icon(Icons.coronavirus),
                    ),
                    Visibility(
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          TextField(
                            key: Key('textFieldSideEffects'),
                            onChanged: _handleTextChange,
                            controller: _controller5,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Side effects',
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                      maintainSize: false,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: _observedSideEffect,
                    ),
                    Visibility(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              key: Key('buttonSend'),
                              label: Text('Send'),
                              icon: Icon(Icons.send),
                              onPressed: () {
                                _showMyDialog();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color(0XFF1D1D35),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                      maintainSize: false,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: _isButtonVisible,
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
