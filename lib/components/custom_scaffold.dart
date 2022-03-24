part of "package:baso/baso.dart";

class CustomScaffold extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final Function? onTap;
  final bool authenticationRequired;
  final String? authenticationTitle;
  final Widget? authenticationLeading;
  final Widget? authenticationTrailing;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  const CustomScaffold({
    Key? key,
    this.appBar,
    this.backgroundColor,
    this.body,
    this.bottomNavigationBar,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.onTap,
    this.authenticationRequired = false,
    this.authenticationTitle,
    this.authenticationLeading,
    this.authenticationTrailing,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
  }) : super(key: key);

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    final content = Scaffold(
      body: widget.body,
      appBar: widget.appBar,
      backgroundColor: widget.backgroundColor,
      bottomNavigationBar: widget.bottomNavigationBar,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();

        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: widget.authenticationRequired
          ? ValueListenableBuilder(
              valueListenable: GenericGlobalService.authenticationNotifier,
              builder: (_, __, ___) {
                return GenericGlobalService.authenticated
                    ? content
                    : AuthenticationScaffold(
                        title: widget.authenticationTitle,
                        leading: widget.authenticationLeading,
                        trailing: widget.authenticationTrailing,
                      );
              },
            )
          : content,
    );
  }
}
