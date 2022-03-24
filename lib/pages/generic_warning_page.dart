part of "package:baso/baso.dart";

class GenericWarningPage extends StatefulWidget {
  final bool first;

  GenericWarningPage({
    this.first = true,
  });

  @override
  _GenericWarningPageState createState() => _GenericWarningPageState();
}

class _GenericWarningPageState extends State<GenericWarningPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: CustomScaffold(
        appBar: CustomAppBar(
          title: "Conditions",
        ),
        bottomNavigationBar: BottomBar(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text("www.sakihub.com"),
                // CustomButton(
                //   label: "Plus d'informations sur www.sakihub.com !",
                //   flat: true,
                //   // onPressed: () {},
                // ),
                // Text(
                //   "L'accès à la page d'accueil de Livo requiert l'acceptation de ses conditions générales d'utilisation !",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //       // color: Colors.grey,
                //       ),
                // ),

                IconButton(
                  onPressed: () {
                    launch("https://sakihub.com");
                  },
                  icon: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                ),

                // CustomButton(
                //   flat: true,
                //   // label: "PLUS D'INFORMATIONS SUR SAKI",
                //   // icon: Icon(Icons.ac_unit),
                // ),
              ],
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Poster(
                      image: "assets/images/conditions.svg",
                      title: widget.first
                          ? "Oh ... Encore un détail !"
                          : "Un petit moment !",
                      description:
                          "Vous devez accepter les conditions générales d'utilisation de ${CustomApp.name}. Ces conditions étant ennuyeuses, nous les avons résumées !",
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 200,
                      // height: 40,
                      child: CustomSlide(
                        child: CustomButton(
                          label: "Lire le résumé",
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            final route = MaterialPageRoute(
                              builder: (context) => GenericConditionsPage(
                                short: true,
                                first: true,
                              ),
                            );

                            if (CustomApp.authenticationRequired) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                route,
                                (route) => false,
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                route,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 200,
                      // height: 40,
                      child: CustomSlide(
                        child: CustomButton(
                          flat: true,
                          label: "Lire le document entier",
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            final route = MaterialPageRoute(
                              builder: (context) => GenericConditionsPage(
                                short: false,
                                first: true,
                              ),
                            );

                            if (CustomApp.authenticationRequired) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                route,
                                (route) => false,
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                route,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
