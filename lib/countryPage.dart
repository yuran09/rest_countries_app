import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rest_countries_app/constants/models/Country.dart';

class CountryPage extends StatelessWidget {
  final Country country;

  const CountryPage({Key? key, required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            actions: [
              IconButton(
                icon: const Icon(Icons.download_rounded),
                onPressed: () {},
              )
            ],
            title: Text(
              country.name,
              overflow: TextOverflow.ellipsis,
            )),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius:
                const BorderRadius.all(Radius.circular(15)),
                child: CachedNetworkImage(
                  fit: BoxFit.fitWidth,
                  // height: MediaQuery.of(context).size.width*0.4,
                  imageUrl: country.flagUrl,
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
          ],
        )
    );
  }
}
