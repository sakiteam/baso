part of "package:baso/baso.dart";

// import 'package:livo/pages/presentation.dart';
// import 'package:livo/components/phone_number_selection.dart';

class GenericAuthenticationPage extends StatefulWidget {
  final bool deletion;
  final bool change;
  final Function? onDeletion;

  const GenericAuthenticationPage({
    this.deletion = false,
    this.change = false,
    this.onDeletion,
  });

  @override
  _GenericAuthenticationPageState createState() =>
      _GenericAuthenticationPageState();
}

class _GenericAuthenticationPageState extends State<GenericAuthenticationPage> {
  // Page view controller
  PageController _pageController = PageController();

  // Inputs
  TextEditingController _country = TextEditingController(text: "+225");
  TextEditingController _phone = TextEditingController();
  TextEditingController _code = TextEditingController();
  TextEditingController _name = TextEditingController();

  // Loading indicators
  bool _loading1 = false;
  bool _loading2 = false;
  bool _loading3 = false;

  bool get _loading => _loading1 || _loading2 || _loading3;

  late bool deletion;
  bool _confirmDeletion = false;
  bool _confirmChange = false;
  late bool change;

  late PhoneAuthCredential _phoneAuthCredential;

  // Utilities
  int _step = 1;
  int _index = 0;
  bool _new = true;
  String? _verificationId;
  late ConfirmationResult _confirmationResult;

  // Validate forms
  bool _validateForm1() {
    return !_loading1 &&
        _country.text.trim().isNotEmpty &&
        _phone.text.trim().isNotEmpty;
  }

  bool _validateForm2() {
    return !_loading2 && _code.text.trim().isNotEmpty;
  }

  bool _validateForm3() {
    return !_loading3 && _name.text.trim().isNotEmpty;
  }

  // Authentication steps
  void _confirmForm1({bool firstTime = true}) async {
    FocusScope.of(context).unfocus();

    if (deletion && _getPhoneNumber() != GenericGlobalService.phoneNumber) {
      _showError(message: "Le numéro entré est incorrect !");
      return;
    }
    if (mounted)
      setState(() {
        _loading1 = true;
        if (firstTime) {
          _step = 1;
        }
      });

    if (GenericGlobalService.web) {
      try {
        _confirmationResult = await FirebaseAuth.instance.signInWithPhoneNumber(
          _getPhoneNumber(),
        );

        _manageForm1(firstTime, null);
      } catch (e) {
        _showError();
      }
    } else {
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _getPhoneNumber(),
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          if (mounted)
            setState(() {
              _loading1 = false;
            });

          if (e.code == 'invalid-phone-number') {
            _showError(
                message: "Le numéro de téléphone entré n'est pas valide !");
          } else {
            _showError();
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          _manageForm1(firstTime, verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  void _confirmForm2() async {
    FocusScope.of(context).unfocus();

    if (change) {
      _phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _code.text.trim(),
      );
      if (mounted)
        setState(() {
          _step = 3;
        });

      _pageController.animateToPage(
        2,
        duration: Duration(milliseconds: 250),
        curve: Curves.linear,
      );

      return;
    }
    if (mounted)
      setState(() {
        _step = 2;
        _loading2 = true;
      });

    if (GenericGlobalService.web) {
      _confirmationResult
          .confirm(_code.text.trim())
          .then((value) => _manageForm2())
          .catchError((error) {
        if (mounted)
          setState(() {
            _loading2 = false;
          });

        _showError(message: "Le code entré est incorrect !");
      });
    } else {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _code.text.trim(),
      );

      FirebaseAuth.instance
          .signInWithCredential(phoneAuthCredential)
          .then((value) {
        _manageForm2();
      }).catchError((e) {
        if (mounted)
          setState(
            () {
              _loading2 = false;
            },
          );

        if (e.code == 'invalid-verification-code') {
          _showError(message: "Le code entré est incorrect !");
        } else {
          _showError();
        }
      });
    }
  }

  void _confirmForm3() async {
    FocusScope.of(context).unfocus();

    if (change) {
      if (mounted)
        setState(() {
          _step = 3;
          _loading3 = true;
        });

      User user = FirebaseAuth.instance.currentUser!;
      user.updatePhoneNumber(_phoneAuthCredential).then((value) {
        GenericBackendService.updateUser(GenericGlobalService.uid, {
          "phone": _getPhoneNumber(),
        }).then((value) {
          if (mounted)
            setState(() {
              _loading3 = false;
            });

          GenericBackendService.refreshUser();

          Navigator.pop(context);
        });
      }).catchError((e) {
        if (mounted)
          setState(() {
            _loading3 = false;
          });

        if (e.code == 'invalid-verification-code') {
          _showError(message: "Le code entré est incorrect !");

          _pageController.animateToPage(
            1,
            duration: Duration(milliseconds: 250),
            curve: Curves.linear,
          );
        } else {
          _showError();
        }
      });

      return;
    }

    if (mounted)
      setState(() {
        _step = 3;
        _loading3 = true;
      });

    User currentUser = FirebaseAuth.instance.currentUser!;
    currentUser.updateDisplayName(_name.text.trim());

    Map<String, dynamic> user = {
      "name": _name.text.trim(),
      "phone": _getPhoneNumber(),
    };

    if (_new && CustomApp.onUserCreation != null) {
      user = CustomApp.onUserCreation!(user);
    }

    (_new
            ? GenericBackendService.insertUser(currentUser.uid, user)
            : GenericBackendService.updateUser(currentUser.uid, user))
        .then((value) async {
      _manageForm3();
    }).catchError((e) {
      print(e);
      if (mounted)
        setState(() {
          _loading3 = false;
        });

      _showError();
    });
  }

  // Authentication sub steps
  void _manageForm1(bool firstTime, verificationId) {
    if (mounted)
      setState(() {
        _loading1 = false;
        _step = 2;
      });

    if (!GenericGlobalService.web) {
      this._verificationId = verificationId;
    }

    if (firstTime) {
      _pageController.animateToPage(
        1,
        duration: Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    }
  }

  void _manageForm2() {
    if (mounted)
      setState(() {
        _step = 3;
        _loading2 = false;
      });

    User user = FirebaseAuth.instance.currentUser!;
    String? name = user.displayName;

    if (name != null && name.isNotEmpty) {
      if (mounted)
        setState(() {
          _name.text = name;
        });

      _new = false;
    } else {
      _new = true;
    }

    GenericBackendService.refreshUser();

    _pageController.animateToPage(
      2,
      duration: Duration(milliseconds: 250),
      curve: Curves.linear,
    );
  }

  void _manageForm3() async {
    if (!_new) {
      GenericGlobalService.accepted = true;
    }

    await GenericMessagingService.saveToken();

    try {
      if (CustomApp.beforeAuthentication != null) {
        await CustomApp.beforeAuthentication!();
      }
    } catch (e) {
      setState(() {
        _loading3 = false;
      });

      _showError();

      return;
    }

    GenericGlobalService.authenticated = true;

    GenericBackendService.monitorAuthenticationState();

    if (CustomApp.onAuthenticated != null) {
      if (CustomApp.refresh != null) {
        CustomApp.refresh!();
      }

      await GenericMessagingService.saveToken();

      await CustomApp.onAuthenticated!(_new);
    }

    // QuerySnapshot snapshot = await FirebaseFirestore.instance
    //     .collection("reports")
    //     .where("valid", isEqualTo: true)
    //     .where("target_id", isEqualTo: GenericGlobalService.uid)
    //     .orderBy('created_at', descending: true)
    //     .get();

    if (_new && CustomApp.authenticationRequired) {
      Get.offAll(
        // snapshot.size == 0 ? (_new ? CustomApp.warningPage : CustomApp.homePage) : Blocking(),
        0 == 0 ? GenericWarningPage() : CustomApp.blockingPage(),
      );
    } else {
      if (!CustomApp.authenticationRequired && Navigator.of(context).canPop()) {
        if (_new) {
          Get.off(GenericWarningPage());
        } else {
          Navigator.of(context).pop();
        }
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                // snapshot.size == 0 ? (_new ? CustomApp.warningPage : CustomApp.homePage) : Blocking(),
                0 == 0 ? CustomApp.homePage() : CustomApp.blockingPage(),
          ),
          (route) => false,
        );
      }
    }
  }

  // Error
  void _showError({String? message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: CustomText(message ?? 'Une erreur est survenue !'),
    ));
  }

  // Get phone number with country code
  String _getPhoneNumber() {
    return _country.text.split(" ").join() + _phone.text.split(" ").join();
  }

  _getPreviousButtonState() {
    return _step > 1 && _index > 0;
  }

  _getNextButtonState() {
    return _step != 1 && _index < _step - 1;
  }

  _quit() {
    CustomApp.globalServiceReset();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => CustomApp.presentationPage(),
      ),
      (route) => false,
    );
  }

  @override
  void initState() {
    deletion = widget.deletion;
    change = widget.change;

    _pageController.addListener(() {
      final tmp = _pageController.page!.round();

      if (tmp != _index) {
        if (mounted) {
          setState(() {
            _index = tmp;
          });
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    _country.dispose();
    _phone.dispose();
    _code.dispose();
    _name.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: change
            ? "Modification du téléphone"
            : (deletion ? "Suppression du compte" : "Authentification"),
      ),
      body: Theme(
        data: ThemeData(
          // primaryColor: Colors.amber,
          primarySwatch: deletion
              ? Colors.red
              : Theme.of(context).primaryColor as MaterialColor?,
          fontFamily: "Brandon",
        ),
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Poster(
                          icon: Icons.dialpad,
                          image: change
                              ? "assets/images/change1.svg"
                              : (deletion
                                  ? "assets/images/deletion1.svg"
                                  : "assets/images/authentication1.svg"),
                          title: "Etape 1/3",
                          description: change
                              ? "Pour effectuer la modification, commencez par indiquer le nouveau numéro !"
                              : (deletion
                                  ? "Si vous voulez vraiment supprimer votre compte, entrez votre numéro de téléphone !"
                                  : "Nouveau ou déjà inscrit ? Entrez tout simplement votre numéro de téléphone !"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CustomSlide(
                            child: PhoneNumberInput(
                              enabled: !_loading,
                              onChanged: (value) {
                                if (mounted) setState(() {});
                              },
                              onEditingComplete: () {
                                if (_validateForm1()) _confirmForm1();
                              },
                              phoneController: _phone,
                              countryController: _country,
                            ),
                          ),
                        ),
                        CustomSlide(
                          child: SizedBox(
                            width: 200,
                            child: CustomButton(
                              label: "Valider",
                              loading: _loading1,
                              onPressed:
                                  _validateForm1() ? _confirmForm1 : null,
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0,
                          child: CustomButton(
                            label: "",
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Poster(
                          icon: Icons.lock,
                          image: change
                              ? "assets/images/change2.svg"
                              : (deletion
                                  ? "assets/images/deletion2.svg"
                                  : "assets/images/authentication2.svg"),
                          title: "Etape 2/3",
                          description:
                              'Un code vous a été envoyé par sms ! S\'il vous plaît, entrez-le dans le champ ci-dessous !',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CustomSlide(
                            child: CustomTextField(
                              enabled: !_loading,
                              hint: "Ex : 123456",
                              onChanged: (value) {
                                if (mounted)
                                  setState(() {
                                    //
                                  });
                              },
                              onEditingComplete: () {
                                if (_validateForm2()) _confirmForm2();
                              },
                              controller: _code,
                              prefixIcon: Icon(Icons.lock),
                              clear: true,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        CustomSlide(
                          child: SizedBox(
                            width: 200,
                            // height: 40,
                            child: CustomButton(
                              label: "Confirmer",
                              loading: _loading2,
                              onPressed: _validateForm2() && !_loading1
                                  ? _confirmForm2
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        CustomSlide(
                          child: SizedBox(
                            width: 200,
                            child: CustomButton(
                              flat: true,
                              label: "Renvoyer le code",
                              loading: _loading1,
                              onPressed: () {
                                _confirmForm1(firstTime: false);
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
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Poster(
                          icon: Icons.person,
                          image: change
                              ? "assets/images/change3.svg"
                              : (deletion
                                  ? "assets/images/deletion3.svg"
                                  : "assets/images/authentication3.svg"),
                          title: "Etape 3/3",
                          description: change
                              ? "Pour terminer, cochez la case suivante puis cliquez sur le bouton de finalisation !"
                              : (deletion
                                  ? "Pour terminer, cochez la case suivante puis cliquez sur le bouton de suppression !"
                                  : "Bien ! Entrez à présent votre nom complet ou le nom de votre entreprise !"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          // child:
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: change
                              ? Disability(
                                  condition: _loading,
                                  child: SizedBox(
                                    height: 62,
                                    child: Material(
                                      clipBehavior: Clip.antiAlias,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          // color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: CheckboxListTile(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(12, 2, 4, 0),
                                        // isThreeLine: true,
                                        // subtitle: Text("d"),
                                        title: Text(
                                          "Je veux modifier mon numéro !",
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        value: _confirmChange,
                                        onChanged: (value) {
                                          if (mounted)
                                            setState(
                                              () {
                                                _confirmChange =
                                                    !_confirmChange;
                                              },
                                            );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : (deletion
                                  ? CustomSlide(
                                      child: Disability(
                                        condition: _loading,
                                        child: SizedBox(
                                          height: 62,
                                          child: Material(
                                            clipBehavior: Clip.antiAlias,
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                // color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: CheckboxListTile(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      12, 2, 4, 0),
                                              // isThreeLine: true,
                                              // subtitle: Text("d"),
                                              title: Text(
                                                  "Je veux supprimer mon compte !"),

                                              value: _confirmDeletion,
                                              onChanged: (value) {
                                                if (mounted)
                                                  setState(
                                                    () {
                                                      _confirmDeletion =
                                                          !_confirmDeletion;
                                                    },
                                                  );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : CustomSlide(
                                      child: CustomTextField(
                                        enabled: !_loading,
                                        hint: "Ex : Martin Luther King",
                                        onChanged: (value) {
                                          if (mounted)
                                            setState(() {
                                              //
                                            });
                                        },
                                        onEditingComplete: () {
                                          if (_validateForm3()) _confirmForm3();
                                        },
                                        clear: true,
                                        prefixIcon: Icon(Icons.person),
                                        controller: _name,
                                        keyboardType: TextInputType.name,
                                      ),
                                    )),
                        ),
                        CustomSlide(
                          child: SizedBox(
                            width: 200,
                            // height: 40,
                            child: change
                                ? CustomButton(
                                    label: "Finaliser",
                                    loading: _loading3,
                                    onPressed:
                                        _confirmChange ? _confirmForm3 : null,
                                  )
                                : (deletion
                                    ? CustomButton(
                                        label: "Supprimer",
                                        color: Colors.red,
                                        onPressed: _confirmDeletion
                                            ? () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CustomDialog(
                                                      color: Colors.red,
                                                      acceptanceText:
                                                          "Supprimer",
                                                      onAccepted: () {
                                                        if (FirebaseAuth
                                                                .instance
                                                                .currentUser ==
                                                            null) {
                                                          _showError(
                                                              message:
                                                                  "Vous n'êtes plus connecté !");
                                                          return;
                                                        }

                                                        if (mounted) {
                                                          setState(() {
                                                            _loading3 = true;
                                                          });
                                                        }

                                                        if (widget.onDeletion !=
                                                            null) {
                                                          widget.onDeletion!();
                                                        }

                                                        CustomApp
                                                            .backendServiceReset();

                                                        FirebaseAuth.instance
                                                            .currentUser!
                                                            .delete()
                                                            .then((value) {
                                                          _quit();
                                                        }).catchError((error) {
                                                          if (mounted)
                                                            setState(() {
                                                              _loading3 = false;
                                                            });

                                                          print(error);

                                                          _showError();
                                                        });
                                                      },
                                                      description:
                                                          "Cela nous attriste de vous voir partir !\nVoulez-vous vraiment supprimer définitivement votre compte ?",
                                                      image:
                                                          "assets/images/leaving.svg",
                                                      title:
                                                          "Suppression du compte",
                                                    );
                                                  },
                                                );
                                              }
                                            : null,
                                      )
                                    : CustomButton(
                                        label: "Finaliser",
                                        loading: _loading3,
                                        onPressed: _validateForm3()
                                            ? _confirmForm3
                                            : null,
                                      )),
                          ),
                        ),
                        Opacity(
                          opacity: 0,
                          child: CustomButton(
                            label: "",
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Opacity(
              opacity: _getPreviousButtonState() ? 1 : 0,
              child: SizedBox(
                width: 120,
                child: CustomButton(
                  label: "Précédent",
                  flat: true,
                  onPressed: !_getPreviousButtonState()
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          if (_index != 0) {
                            await _pageController.animateToPage(
                              _index - 1,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.linear,
                            );
                          }
                        },
                ),
              ),
            ),
            PageIndicator(
              controller: _pageController,
            ),
            Opacity(
              opacity: _getNextButtonState() ? 1 : 0,
              child: SizedBox(
                width: 120,
                child: CustomButton(
                  label: "Suivant",
                  flat: true,
                  onPressed: !_getNextButtonState()
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          if (_index != 2) {
                            await _pageController.animateToPage(
                              _index + 1,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.linear,
                            );
                          }
                        },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
