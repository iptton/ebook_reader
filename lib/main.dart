import 'dart:async';

// import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/material.dart';
import 'package:isolate/isolate.dart';
// import 'generated/i18n.dart';
import 'utils.dart' show computeRunner;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      // localizationsDelegates: [S.delegate],
      // supportedLocales: S.delegate.supportedLocales,
      // localeResolutionCallback: S.delegate.resolution(fallback: Locale('zh', '')),
      title: "...",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }




}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


test() async {
  var r1 = await computeRunner(syncFunc,1);
  print("r1 = $r1");
  var r2 = await computeRunner(asyncFunc, 2);
  print("r2 = $r2");
}

String syncFunc(int i){
  return 'hello sync$i';
}
Future<String> asyncFunc(int i)async{
  await Future.delayed(Duration(milliseconds: 500));
  return 'helo async $i';
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {

    // test();
    test();
    // print("${Localizations.localeOf(context).toString()}");
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text('abcd'),
      ),
      body: Center(
       
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: '',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
