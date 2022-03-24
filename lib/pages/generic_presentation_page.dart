part of "package:baso/baso.dart";

class GenericPresentationPage extends StatefulWidget {
  final String? title;
  final List<Map<String, String>>? content;
  final bool authentication;

  const GenericPresentationPage({
    this.title,
    this.content,
    this.authentication = true,
  });

  @override
  _GenericPresentationPageState createState() =>
      _GenericPresentationPageState();
}

class _GenericPresentationPageState extends State<GenericPresentationPage> {
  PageController? _pageController;

  int _step = 1;
  int _maxStep = 3;

  @override
  void initState() {
    _pageController = PageController();

    _pageController!.addListener(() {
      final tmp = _pageController!.page!.round() + 1;

      if (tmp != _step) {
        if (mounted) {
          setState(() {
            _step = tmp;
          });
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.title ?? "",
      ),
      body: PageView(
        controller: _pageController,
        children: widget.content!
            .map<Widget>(
              (e) => SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Poster(
                          image: e["image"],
                          title: e["title"],
                          description: e["description"]),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
      bottomNavigationBar: BottomBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 120,
              child: _step == 1
                  ? null
                  : CustomButton(
                      label: "Précédent",
                      flat: true,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_step > 0) {
                          _pageController!.animateToPage(_step - 2,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.linear);
                        }
                      },
                    ),
            ),
            PageIndicator(
              controller: _pageController,
            ),
            SizedBox(
              width: 120,
              child: _step == _maxStep
                  ? CustomButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        GenericGlobalService.welcomed = true;

                        if (widget.authentication) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenericAuthenticationPage(),
                            ),
                            (route) => false,
                          );
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomApp.homePage(),
                            ),
                            (route) => false,
                          );

                          // Navigator.pushAndRemoveUntil(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         // snapshot.size == 0 ? (_new ? CustomApp.warningPage : CustomApp.homePage) : Blocking(),
                          //         GenericWarningPage(),
                          //   ),
                          //   (route) => false,
                          // );
                        }
                      },
                      label: "Commencer",
                    )
                  : CustomButton(
                      label: "Suivant",
                      flat: true,
                      onPressed: () {
                        if (_step < _maxStep) {
                          _pageController!.animateToPage(
                            _step,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.linear,
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
