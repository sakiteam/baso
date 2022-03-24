part of "package:baso/baso.dart";

class AuthenticationScaffold extends StatefulWidget {
  final String? title;
  final Widget? leading;
  final Widget? trailing;

  const AuthenticationScaffold({
    Key? key,
    this.title,
    this.leading,
    this.trailing,
  }) : super(key: key);

  @override
  _AuthenticationScaffoldState createState() => _AuthenticationScaffoldState();
}

class _AuthenticationScaffoldState extends State<AuthenticationScaffold> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: widget.title ?? "",
        leading: widget.leading,
        actions: [if (widget.trailing != null) widget.trailing!],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: AuthenticationPoster(),
        ),
      ),
    );
  }
}
