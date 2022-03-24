part of "package:baso/baso.dart";

class GenericHomePage extends StatefulWidget {
  final int index;
  // final bool unblocking;
  final Function? onIndexChanged;
  final List<Map<String, dynamic>> content;
  final bool curved;

  GenericHomePage({
    this.index = 0,
    required this.content,
    this.onIndexChanged,
    // this.unblocking = false,
    this.curved = false,
  });

  @override
  _GenericHomePageState createState() => _GenericHomePageState();
}

class _GenericHomePageState extends State<GenericHomePage> {
  int _index = 0;

  @override
  void initState() {
    // BackendService.monitorUserReports(context, "HOME");

    _index = widget.index;

    // MessagingService.requestPermission().then((notificationSettings) {
    //   if (notificationSettings.authorizationStatus ==
    //       AuthorizationStatus.authorized) {
    //     MessagingService.subscribe("default");
    //     if (GlobalService.tasksNotifications)
    //       MessagingService.subscribe("tasks");
    //     if (GlobalService.servicesNotifications)
    //       MessagingService.subscribe("services");
    //     if (GlobalService.jobsNotifications) MessagingService.subscribe("jobs");
    //     MessagingService.saveToken();
    //   }
    // });

    super.initState();

    // if (widget.unblocking) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) async {
    //     showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return CustomDialog(
    //           simple: true,
    //           description:
    //               "Votre compte a été débloqué avec succès. Vous pouvez maintenant l'utiliser comme vous en aviez déjà l'habitude !",
    //           image: "assets/images/unblocking.svg",
    //           title: "Félicitations",
    //         );
    //       },
    //     );
    //   });
    // }
  }

  final double _notchMargin = 8;

  _displayPart(List<Map<String, dynamic>> list) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: list.map(
          (e) {
            final index = widget.content.indexOf(e);

            return IconButton(
              padding: EdgeInsets.zero,
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(e["icon"]),
                  Text(
                    e["title"],
                    style: TextStyle(
                      fontSize: 12,
                      color: index == _index
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
                  ),
                ],
              ),
              color: index == _index ? Theme.of(context).primaryColor : null,
              onPressed: () {
                if (mounted)
                  setState(() {
                    _index = index;
                  });

                if (widget.onIndexChanged != null) {
                  widget.onIndexChanged!(_index);
                }
              },
            );
          },
        ).toList());
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.content;

    final firstPart = content.sublist(0, 2);
    final lastPart = content.sublist(2);

    return CustomScaffold(
      extendBody: widget.curved,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
      ),
      body: IndexedStack(
        children: content.map<Widget>((e) => e["widget"]).toList(),
        index: _index,
      ),
      bottomNavigationBar: widget.curved && content.length == 4
          ? BottomAppBar(
              elevation: 0,
              shape: CircularNotchedRectangle(),
              notchMargin: _notchMargin,
              color: Colors.white,
              child: BottomAppBar(
                elevation: 0,
                shape: CircularNotchedRectangle(),
                notchMargin: _notchMargin,
                color: Colors.grey,
                child: SizedBox(
                  height: 56,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.5),
                    child: BottomAppBar(
                      elevation: 0,
                      shape: CircularNotchedRectangle(),
                      notchMargin: _notchMargin + 0.2,
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 0.25),
                        child: Row(children: [
                          Expanded(child: _displayPart(firstPart)),
                          SizedBox(width: _notchMargin * 2 + 56),
                          Expanded(child: _displayPart(lastPart)),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Stack(
              children: [
                BottomNavigationBar(
                  elevation: 0,
                  currentIndex: _index,
                  backgroundColor: Colors.white,
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  selectedFontSize: 0.0,
                  unselectedFontSize: 0.0,
                  items: content
                      .map<BottomNavigationBarItem>(
                        (e) => BottomNavigationBarItem(
                          icon: Icon(e["icon"]),
                          label: e["title"],
                        ),
                      )
                      .toList(),
                  onTap: (index) {
                    if (mounted)
                      setState(() {
                        _index = index;
                      });

                    if (widget.onIndexChanged != null) {
                      widget.onIndexChanged!(_index);
                    }
                  },
                ),
                Divider(height: 0)
              ],
            ),
    );
  }
}
