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
      providers: [
        ChangeNotifierProvider(create: (_) => CountryProvider()),
      ],
      child: MaterialApp(
        title: 'RestCountries',
        theme: ThemeData(primarySwatch: Colors.cyan, canvasColor: Colors.white),
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
      body: Consumer<CountryProvider>(builder: (context, countryP, child) {
        return ListView.builder(
          //padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          itemCount: countryP.countries.length,
          itemBuilder: (BuildContext context, int index) {
            //return CategoryItem(name: 'TestName', categoryPic: Image.asset('images/3d_icon.png'));
            return ListTile(
              leading: Icon(Icons.add),
              title: Text(countryP.countries[index].name),
              subtitle: Text(''),
            );
          },
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    // countryList = RestApiServices.instance.byName('moz');
    context.read<CountryProvider>().fetchAllCountries();
  }
}
