part of "package:baso/baso.dart";

class PhoneNumberSelection extends StatefulWidget {
  final Function? callback;

  const PhoneNumberSelection({
    this.callback,
  });

  @override
  _PhoneNumberSelectionState createState() => _PhoneNumberSelectionState();
}

class _PhoneNumberSelectionState extends State<PhoneNumberSelection> {
  List _countries = [];
  List _filteredCountries = [];

  bool _loading = true;
  TextEditingController _query = TextEditingController();

  @override
  void initState() {
    CountriesService.getCountries().then((countries) {
      if (mounted) {
        setState(() {
          _countries = countries;
          _filteredCountries = countries;
          _loading = false;
        });
      }
    });

    super.initState();
  }

  _filterCountries() {
    var q = removeDiacritics(_query.text.trim()).toLowerCase();

    _filteredCountries = _countries.where((country) {
      if (q.isNotEmpty) {
        String stringifiedDocument = "";

        country.values.forEach((element) {
          stringifiedDocument +=
              removeDiacritics(element.toString().toLowerCase());
        });

        stringifiedDocument = stringifiedDocument.trim();

        final terms = q.split(" ");

        for (int i = 0; i < terms.length; i++) {
          final term = terms[i];

          if (!stringifiedDocument.contains(term)) {
            return false;
          }
        }
      }

      return true;
    }).toList();
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        appBar: CustomAppBar(
          leading: SizedBox(),
          leadingWidth: 0,
          content: SearchBar(
            controller: _query,
            hint: "Rechercher un pays ou un code",
            onChanged: (value) {
              _filterCountries();
              if (mounted) setState(() {});
            },
            prefixIcon: BackButton(
              color: Theme.of(context).primaryColor,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                _query.clear();

                _filterCountries();
                if (mounted) setState(() {});
              },
            ),
          ),
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _filteredCountries.isEmpty
                ? Poster(
                    image: "assets/images/empty.svg",
                    title: "Aucun pays trouvé !",
                    description:
                        "Oh, désolé ! Aucun élément n'a été trouvé ! Vérifiez bien votre saisie pour voir si vous n'avez pas fait une petite erreur sur un terme !",
                  )
                : ListView(
                    children: _filteredCountries.map(
                      (country) {
                        final index = _countries.indexOf(country);

                        final sectionVisible = _query.text.trim().isEmpty &&
                            (index == 0 ||
                                (_countries[index - 1]["section"] !=
                                    country["section"]));

                        return country["code"].isEmpty
                            ? SizedBox()
                            : Column(
                                children: [
                                  if (sectionVisible)
                                    Section(
                                      title: country["section"],
                                    ),
                                  ListTile(
                                    leading: CircleImage(
                                      url: country["flag"],
                                    ),

                                    // CircleAvatar(
                                    //   backgroundColor: Colors.transparent,
                                    //   backgroundImage: Image.network(
                                    //     country["flag"],
                                    //   ).image,
                                    // ),

                                    // leading: Container(
                                    //   height: 40,
                                    //   width: 40,
                                    //   // color: Colors.red,
                                    //   // clipBehavior: Clip.antiAlias,
                                    //   child: country["flag"].isNotEmpty
                                    //       ? SvgPicture.network(
                                    //           country["flag"],
                                    //           // height: 40,
                                    //           // width: 40,
                                    //           // fit: BoxFit.fill,
                                    //         )
                                    //       : Container(),

                                    trailing: Icon(Icons.keyboard_arrow_right),
                                    title: Text(country["name"]),
                                    subtitle: Text(country["code"]),
                                    onTap: () {
                                      if (widget.callback != null) {
                                        widget.callback!(country["code"]);
                                      }

                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                      },
                    ).toList(),
                  ),
      ),
    );
  }
}
