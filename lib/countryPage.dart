import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_countries_app/constants/models/Country.dart';
import 'package:rest_countries_app/providers/countryProvider.dart';

class CountryPage extends StatefulWidget {
  final Country country;

  const CountryPage({Key? key, required this.country}) : super(key: key);

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  bool isLoaded = false;
  var formatter = NumberFormat('###,###,000');

  @override
  void initState() {
    super.initState();
    context
        .read<CountryProvider>()
        .fetchByName(widget.country.name)
        .then((value) {
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            title: Text(
              widget.country.name,
              overflow: TextOverflow.ellipsis,
            )),
        body: Visibility(
          visible: isLoaded,
          replacement: Center(
            child: CircularProgressIndicator(),
          ),
          child: Consumer<CountryProvider>(builder: (context, countryP, child) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: CustomScrollView(
                    // physics: NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate([
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fitWidth,
                                  // height: MediaQuery.of(context).size.width*0.4,
                                  imageUrl: countryP.country.flagUrl,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) => Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.black12,
                                    child: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  ),
                                  //placeholder: ,
                                ),
                              ),
                            ),
                          ])),
                      SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.0,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 3.0,
                        ),
                        delegate: SliverChildListDelegate([
                          getBox('Nome', countryP.country.name),
                          getBox('Capital', countryP.country.capital),
                          getBox('Região', countryP.country.region),
                          getBox('Sub-região', countryP.country.subRegion),
                        ]),
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: getBox(
                              'Nome Nativo', countryP.country.nativeName),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Divider(color: Colors.grey[300],height: 10,thickness: 2),
                        ),
                      ])),
                      SliverGrid(
                        gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150.0,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 1.0,
                        ),
                        delegate: SliverChildListDelegate([
                          DetailsWidget(
                              icon: Icon(Icons.zoom_out_map_rounded),
                              title: 'área',
                              content: formatter.format(double.parse(countryP.country.area))),
                          DetailsWidget(
                              icon: Icon(Icons.family_restroom),
                              title: 'população',
                              content: formatter.format(
                                  double.parse(countryP.country.population))),
                          DetailsWidget(
                              icon: Icon(Icons.access_time_rounded),
                              title: 'fuso horário',
                              content: countryP.country.timezone),
                        ]),
                      ),
                    ],
                  )),
            );
          }),
        ));
  }

  Widget getBox(String title, String content) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Colors.cyan[100],
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 13),
              ),
            ),
            FittedBox(
              fit: BoxFit.cover,
              child: Text(content,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            )
          ],
        ),
      ),
    );
  }
}

class DetailsWidget extends StatelessWidget {
  final Icon icon;
  final String content;
  final String title;

  const DetailsWidget(
      {Key? key,
      required this.icon,
      required this.content,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon.icon,
            color: Theme.of(context).primaryColor,
            size: 40,
          ),
          Expanded(
            child: Text(content,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 13),
            ),
          )
        ],
      ),
    );
  }
}
