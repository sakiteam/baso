part of "package:baso/baso.dart";

class BottomBar extends StatefulWidget {
  final Widget? child;
  final double margin;
  final Color? color;
  final bool divider;

  const BottomBar({
    this.child,
    this.margin = 16,
    this.color,
    this.divider = true,
  });

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          color: widget.color ?? Colors.white,
          child: SafeArea(
            bottom: false,
            top: false,
            minimum: EdgeInsets.symmetric(horizontal: widget.margin),
            child: CustomSlide(
              child: Container(
                height: 56,
                margin: EdgeInsets.fromLTRB(
                    0, 0, 0, MediaQuery.of(context).padding.bottom),
                child: widget.child,
              ),
            ),
          ),
        ),
        if (widget.divider)
          Divider(
            height: 0,
          ),
      ],
    );
  }
}
