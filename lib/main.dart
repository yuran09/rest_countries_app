import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/countryProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) => CountryProvider()),
      ],
      child:MaterialApp(
        title: 'RestCountries',
        theme: ThemeData(
            primarySwatch: Colors.cyan,
            canvasColor: Colors.white
        ),
        home: const MyHomePage(title: 'Países'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var countryList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(widget.title),
        ),
        body: ListView.builder(itemCount: 2, itemBuilder: (context, index){
          return ListTile(
            title: Text('Titulo'),
            leading: Icon(Icons.info_rounded),
            onTap: (){},
          );
        } ));
  }

  @override
  void initState() {
    super.initState();
    // countryList = RestApiServices.instance.byName('moz');
    CountryProvider.fetchAllCountries();
  }
}
