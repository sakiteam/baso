part of "package:baso/baso.dart";

class GenericConditionsPage extends StatefulWidget {
  final bool short;
  final bool first;
  final bool critical;
  final String? title;

  GenericConditionsPage({
    this.short = true,
    this.first = true,
    this.critical = false,
    this.title,
  });

  @override
  _GenericConditionsPageState createState() => _GenericConditionsPageState();
}

class _GenericConditionsPageState extends State<GenericConditionsPage> {
  bool _short = true;
  late bool _first;

  final List<String> _terms = [
    'Vous avez naturellement tous les droits sur vos données personnelles. Cependant, vous devez être courtois et respectueux dans toutes vos publications.',
    'Vos publications ne doivent en aucun cas contenir des mensonges ou des références à la violence ou tout autre sujet pouvant choquer les autres utilisateurs.',
    'L\'entreprise éditrice ne porte en aucun cas la charge de tout désagrément pouvant résulter de l\'interaction entre vous et les autres utilisateurs de l\'application.',
    'Nous pouvons utiliser vos données à toute fin légale. Et tout manquement aux termes précités pourrait entraîner la désactivation de votre compte.'
  ];

  @override
  void initState() {
    _short = widget.short;
    _first = widget.first;
    super.initState();
  }

  _getShortTerms() {
    return SingleChildScrollView(
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 16,
            ),
            for (String term in _terms)
              Condition(
                term: term,
                index: _terms.indexOf(term),
              ),
            SizedBox(
              height: _first
                  ? 16
                  : max(MediaQuery.of(context).padding.bottom - 16, 0),
            ),
          ],
        ),
      ),
    );
  }

  _getLongTerms() {
    return SingleChildScrollView(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16,
              _first ? 16 : max(MediaQuery.of(context).padding.bottom, 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Heading(text1: 'Article 1', text2: 'Objet'),
              Text(
                  "Les présentes CGU ou Conditions Générales d'Utilisation encadrent juridiquement l'utilisation des services de l'application ${CustomApp.name} (ci-après dénommée « la plateforme » ou « l'application »)."),
              SizedBox(height: 8),
              Text(
                  "Constituant le contrat entre l'entreprise Saki et l'Utilisateur, l'accès à la page d'accueil de l'application doit être précédé de l'acceptation de ces CGU. L'accès à cette page signifie l'acceptation des présentes CGU."),
              SizedBox(height: 8),
              SizedBox(
                height: 16,
              ),
              Heading(text1: 'Article 2', text2: 'Mentions légales'),
              Text(
                  "L'édition de ${CustomApp.name} est assurée par l'entreprise Saki, dont le siège social est localisé en Côte d'Ivoire à Abidjan."),
              SizedBox(height: 8),
              SizedBox(
                height: 16,
              ),
              Heading(text1: 'Article 3', text2: 'Accès à l\'application'),
              Text(CustomApp.presentation),
              SizedBox(height: 8),
              Text(
                  "L'application est accessible gratuitement depuis n'importe où par toute personne disposant d'un accès à Internet. Tous les frais nécessaires pour l'accès aux services (matériel informatique, connexion Internet…) sont à la charge de l'Utilisateur."),
              SizedBox(height: 8),
              Text(
                  "L'accès aux services dédiés aux membres s'effectue à l'aide d'un numéro de téléphone."),
              SizedBox(height: 8),
              Text(
                  "Pour des raisons de maintenance ou autres, l'accès à la plateforme peut être interrompu ou suspendu par l'éditeur sans préavis ni justification. Ainsi, tout manquement aux termes de ce contrat pourra entraîner la désactivation du compte de l'Utilisateur sans préavis ni justification."),
              SizedBox(height: 8),
              SizedBox(
                height: 16,
              ),
              Heading(text1: 'Article 4', text2: 'Collecte des données'),
              Text(
                  "Pour la création du compte de l'Utilisateur, la collecte des informations au moment de l'inscription sur ${CustomApp.name} est nécessaire et obligatoire. La collecte et le traitement d'informations personnelles s'effectuent dans le respect de la vie privée."),
              SizedBox(height: 8),
              Text(
                  "L'Utilisateur dispose du droit d'accéder, de rectifier, de supprimer ses données personnelles. L'exercice de ce droit s'effectue par son espace membre accessible sur la plateforme."),
              SizedBox(height: 8),
              SizedBox(
                height: 16,
              ),
              Heading(text1: 'Article 5', text2: 'Propriété intellectuelle'),
              Text(
                  "Les marques, logos ainsi que les contenus de ${CustomApp.name} (illustrations graphiques, textes…) sont protégés par le Code de la propriété intellectuelle et par le droit d'auteur."),
              SizedBox(height: 8),
              Text(
                  "La reproduction et la copie des contenus par l'Utilisateur requièrent une autorisation préalable de Saki. Dans ce cas, toute utilisation à des usages commerciaux ou à des fins publicitaires est proscrite."),
              SizedBox(height: 8),
              SizedBox(
                height: 16,
              ),
              Heading(text1: 'Article 6', text2: 'Responsabilités'),
              Text(
                  "Bien que les informations publiées sur ${CustomApp.name} soient réputées fiables, la plateforme se réserve la faculté d'une non-garantie de la fiabilité des sources."),
              SizedBox(height: 8),
              Text(
                  "Les informations diffusées sur l'application sont présentées à titre purement informatif et sont sans valeur contractuelle. En dépit des mises à jour régulières, la responsabilité de ${CustomApp.name} ne peut être engagée en cas de modification des dispositions administratives et juridiques apparaissant après la publication. Il en est de même pour l'utilisation et l'interprétation des informations communiquées sur la plateforme."),
              SizedBox(height: 8),
              Text(
                  "${CustomApp.name} décline toute responsabilité concernant les éventuels virus pouvant infecter le matériel informatique de l'Utilisateur après l'utilisation ou l'accès à cette plateforme."),
              SizedBox(height: 8),
              Text(
                  "La plateforme ne peut être tenu pour responsable en cas de force majeure ou du fait imprévisible et insurmontable d'un tiers. ${CustomApp.name} ne porte en aucun cas la charge de tout désagrément (quel qu'il soit) pouvant résulter des interactions entre ses utilisateurs."),
              SizedBox(height: 8),
              Text(
                  "La garantie totale de la sécurité et la confidentialité des données n'est pas assurée par la plateforme. Cependant, Saki s'engage à mettre en œuvre toutes les méthodes requises pour le faire au mieux."),
              SizedBox(height: 8),
              SizedBox(
                height: 16,
              ),
              Heading(text1: 'Article 7', text2: 'Liens hypertextes'),
              Text(
                  "La plateforme peut être constitué de liens hypertextes. En cliquant sur ces derniers, l'Utilisateur pourrait sortir de la plateforme. Cette dernière n'a pas de contrôle et ne peut pas être tenue responsable du contenu des pages web relatives à ces liens."),
              SizedBox(height: 8),
              SizedBox(
                height: 16,
              ),
              Heading(
                  text1: 'Article 8', text2: 'Publications par l\'Utilisateur'),
              Text(
                  "${CustomApp.name} permet aux membres de publier du contenu."),
              SizedBox(height: 8),
              Text(
                  "Dans ses publications, le membre est tenu de respecter les règles de la nétiquette ainsi que les règles de droit en vigueur."),
              SizedBox(height: 8),
              Text(
                  "${CustomApp.name} dispose du droit d'exercer une modération à priori sur les publications et peut refuser leur mise en ligne sans avoir à fournir de justification."),
              SizedBox(height: 8),
              Text(
                  "Le membre garde l'intégralité de ses droits de propriété intellectuelle. Toutefois, toute publication sur ${CustomApp.name} implique la délégation du droit non exclusif et gratuit à l'entreprise éditrice de représenter, reproduire, modifier, adapter, distribuer et diffuser la publication n'importe où et sur n'importe quel support pour la durée de la propriété intellectuelle. Cela peut se faire directement ou par l'intermédiaire d'un tiers autorisé. Cela concerne notamment le droit d'utilisation de la publication sur le web et sur les réseaux de téléphonie mobile."),
              SizedBox(height: 8),
              Text(
                  "À chaque utilisation, l'éditeur s'engage à mentionner le nom du membre à proximité de la publication."),
              SizedBox(height: 8),
              Text(
                  "L'Utilisateur est tenu responsable de tout contenu qu'il met en ligne. L'Utilisateur s'engage à ne pas publier de contenus susceptibles de porter atteinte aux intérêts ou à la sensibilité de tierces personnes. Sont donc à proscrire, les publications contenant des informations mensongères et/ou des références à la violence, au sexe ou tout autre sujet choquant. Toutes procédures engagées en justice par un tiers lésé à l'encontre de ${CustomApp.name} devront être prises en charge par l'Utilisateur."),
              SizedBox(height: 8),
              Text(
                  "La suppression ou la modification par ${CustomApp.name} du contenu de l'Utilisateur peut s'effectuer à tout moment, pour n'importe quelle raison et sans préavis."),
              SizedBox(height: 8),
              SizedBox(
                height: 16,
              ),
              Heading(text1: 'Article 9', text2: 'Durée du contrat'),
              Text(
                  "Le présent contrat est valable pour une durée indéterminée. Le début de l'utilisation des services de la plateforme marque l'application du contrat à l'égard de l'Utilisateur."),
              SizedBox(height: 8),
              SizedBox(
                height: 16,
              ),
              Heading(
                  text1: 'Article 10',
                  text2: 'Droit applicable et juridiction compétente'),
              Text(
                  "Le présent contrat est soumis à la législation ivoirienne. L'absence de résolution à l'amiable des cas de litige entre les parties implique le recours aux tribunaux ivoiriens compétents pour régler le contentieux."),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    IconButton action = IconButton(
      onPressed: () {
        if (mounted)
          setState(() {
            _short = !_short;
          });
      },
      icon: Icon(Icons.swap_vert),
      // tooltip:
      //     _first ? 'Lire la version ' + (_short ? 'longue' : 'courte') : null,
    );

    return WillPopScope(
      onWillPop: () {
        return Future.value(!widget.first);
      },
      child: Theme(
        data: widget.critical
            ? ThemeData(
                primarySwatch: Colors.red,
                fontFamily: "Brandon",
                dividerColor: Colors.grey,
                scaffoldBackgroundColor: Color(0xFFEEEEEE),
              )
            : Theme.of(context),
        child: CustomScaffold(
          appBar: CustomAppBar(
            title: widget.title ?? "Conditions",
            actions: _first ? [] : [action],
            brightness: widget.critical ? Brightness.dark : null,
          ),
          body: IndexedStack(
            children: [
              _getShortTerms(),
              _getLongTerms(),
            ].map((e) => CustomSlide(child: e)).toList(),
            index: _short ? 0 : 1,
          ),
          bottomNavigationBar: _first
              ? BottomBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 120,
                        child: CustomButton(
                          label: "REFUSER",
                          // outline: true,
                          flat: true,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                  acceptanceText: "Expliquer",
                                  onAccepted: () {
                                    launch(
                                        "mailto:sakihub@gmail.com?subject=Refus%20des%20conditions%20générales%20d'utilisation%20de%20${CustomApp.name}");
                                  },
                                  image: "assets/images/connection.svg",
                                  title: "Refus des conditions",
                                  description:
                                      "Nous voulons vraiment consolider nos relations ! Pouvez-vous nous expliquer pourquoi vous refusez nos conditions ?",
                                );
                              },
                            );
                          },
                        ),
                      ),
                      action,
                      SizedBox(
                        width: 120,
                        child: CustomButton(
                          label: "Accepter",
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            GenericGlobalService.accepted = true;

                            if (!CustomApp.authenticationRequired &&
                                Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomApp.homePage(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
