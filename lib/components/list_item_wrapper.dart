part of "package:baso/baso.dart";

class ListItemWrapper extends StatefulWidget {
  final Function? init;
  final Widget? child;

  ListItemWrapper({this.init, this.child});

  @override
  _ListItemWrapperState createState() => _ListItemWrapperState();
}

class _ListItemWrapperState extends State<ListItemWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    if (widget.init != null) {
      widget.init!();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(child: widget.child);
  }

  @override
  bool get wantKeepAlive => true;
}
