import 'package:cached_network_image/cached_network_image.dart';
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
  TextEditingController txtController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    txtController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              // color: Colors.green,
              child: TextField(
                onChanged: searchCountry,
                controller: txtController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Nome País',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor))),
              ),
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Expanded(
              child: Consumer<CountryProvider>(
                  builder: (context, countryP, child) {
                return ListView.builder(
                  //padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  itemCount: countryP.floatingCountries.length,
                  itemBuilder: (BuildContext context, int index) {
                    //return CategoryItem(name: 'TestName', categoryPic: Image.asset('images/3d_icon.png'));
                    return ListTile(
                      onTap: () {},
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      leading: Container(
                        height: 40,
                        width: 60,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(const Radius.circular(8)),
                          child: CachedNetworkImage(
                            imageUrl: countryP.floatingCountries[index].flagUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // child: SvgPicture.network(countryP.countries[index].flagUrl, fit: BoxFit.fitHeight,),
                      ),
                      title: Text(countryP.floatingCountries[index].name),
                      subtitle: Text(countryP.floatingCountries[index].capital),
                    );
                  },
                );
              }),
            ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    // countryList = RestApiServices.instance.byName('moz');
    context.read<CountryProvider>().fetchAllCountries().then((value) =>
        context.read<CountryProvider>().initializeFloatingCountries());
  }

  void searchCountry(String query) {
    final suggestions =
        context.read<CountryProvider>().countries.where((country) {
      final finalCountry = country.name.toLowerCase();
      final input = query.toLowerCase();

      return finalCountry.contains(input);
    }).toList();

    context.read<CountryProvider>().updateFloatingCountries(suggestions);
  }
}
