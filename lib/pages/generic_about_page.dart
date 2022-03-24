part of "package:baso/baso.dart";

class GenericAboutPage extends StatefulWidget {
  const GenericAboutPage();

  @override
  _GenericAboutPageState createState() => _GenericAboutPageState();
}

class _GenericAboutPageState extends State<GenericAboutPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: "A propos de ${CustomApp.name}",
      ),
      bottomNavigationBar: BottomBar(
        child: Center(
          child: Text(
            "Les images vectorielles de cette application sont la propriété de Storyset !",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Poster(
                        image: "assets/images/logo.png",
                        title: "Saki",
                        description:
                            "L'application ${CustomApp.name} a été réalisée par l'entreprise Saki et constitue sa propriété.\nVersion actuelle : ${CustomApp.version}",
                      ),
                      SizedBox(height: 16),
                      CustomSlide(
                        child: SizedBox(
                          width: 220,
                          child: CustomButton(
                            label: "Noter l'application",
                            onPressed: () {
                              StoreRedirect.redirect();
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      CustomSlide(
                        child: SizedBox(
                          width: 220,
                          child: CustomButton(
                            flat: true,
                            label: "Autres applications de Saki",
                            onPressed: () {
                              if (Platform.isAndroid) {
                                launch(
                                    "https://play.google.com/store/apps/dev?id=8434106479316779165");
                              } else {
                                launch(
                                    "itms-apps://itunes.apple.com/developer/id1565628615");
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
