import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rest_countries_app/constants/models/Country.dart';
import 'package:rest_countries_app/utils/readWriteData.dart';
import 'package:xml/xml.dart';
import 'countryPage.dart';
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
        debugShowCheckedModeBanner: false,
        title: 'RestCountries',
        theme: ThemeData(primarySwatch: Colors.cyan, canvasColor: Colors.grey[200]),
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
  bool isLoading = false;
  final ReadWriteData rwd = ReadWriteData();

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
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.download_rounded),
              onPressed: () {
                // makeXML();
                context.read<CountryProvider>().fetchToExport().then((value) {

                  List<dynamic> country = context.read<CountryProvider>().countriesToExport;

                  final builder = XmlBuilder();
                  builder.processing('xml', 'version="1.0"');

                    builder.element('País', nest: () {
                      for (var element in country) {
                        builder.element('Nome', nest: element.name);
                        builder.element('Capital', nest: element.capital);
                        builder.element('Sub_região', nest: element.subRegion);
                        builder.element('Região', nest: element.region);
                        builder.element('População', nest: element.population);
                        builder.element('Área', nest: element.area);
                        builder.element('Fuso_horário', nest: element.timezone);
                        builder.element('nome_nativo', nest: element.nativeName);
                        builder.element('bandeira', nest: element.flagUrl);
                      }
                    });

                  final document = builder.buildDocument();
                  rwd.writeXML(document.toXmlString());
                  rwd.getFilePath().then((value) => OpenFile.open(value));


                  // print(document.toXmlString());
                });
              }
            )
          ],
        ),
        body: Builder(
          builder: (context){
            return Visibility(
              visible: isLoading,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: GestureDetector(
                onTap: (){FocusScope.of(context).unfocus();},
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(16),
                      height: MediaQuery.of(context).size.height * 0.07,
                      // color: Colors.green,
                      child: Card(
                        elevation: 15,
                        color: Colors.grey[100],
                        shadowColor: Theme.of(context).primaryColor.withOpacity(0.2),
                        child: TextField(
                          controller: txtController,
                          onChanged: searchCountry,
                          decoration: InputDecoration(
                            label: const Text('Nome do país'),
                            floatingLabelBehavior:
                            FloatingLabelBehavior.never,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Color(0xffeaeaea)),),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.primary)),
                          ),
                        ),
                      ),

                    ),
                    Expanded(
                      child: Consumer<CountryProvider>(
                          builder: (context, countryP, child) {
                            return ListView.builder(
                              addAutomaticKeepAlives: false,
                              scrollDirection: Axis.vertical,
                              itemCount: countryP.floatingCountries.length,
                              itemBuilder: (BuildContext context, int index) {
                                //return CategoryItem(name: 'TestName', categoryPic: Image.asset('images/3d_icon.png'));
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CountryPage(
                                                country:
                                                countryP.floatingCountries[index])));
                                  },
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
                ),
              ),
            );
          },
        )
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // countryList = RestApiServices.instance.byName('moz');
    context.read<CountryProvider>().fetchAllCountries().then((value) {
      context.read<CountryProvider>().initializeFloatingCountries();
      setState(() {
        isLoading = true;
      });
    }
      );
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
