part of "package:baso/baso.dart";

class CustomFloatingActionButton extends StatefulWidget {
  final Function? onPressed;
  final IconData? icon;
  final String? heroTag;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool outline;
  final bool mini;
  final Color? outlineColor;

  CustomFloatingActionButton({
    this.onPressed,
    this.icon,
    this.heroTag,
    this.backgroundColor,
    this.foregroundColor,
    this.outline = false,
    this.mini = false,
    this.outlineColor,
  });

  @override
  _CustomFloatingActionButtonState createState() =>
      _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState
    extends State<CustomFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      disabledElevation: 0,
      highlightElevation: 0,
      mini: widget.mini,
      backgroundColor:
          widget.backgroundColor ?? (widget.outline ? Colors.white : null),
      foregroundColor: widget.foregroundColor ??
          (widget.outline ? Theme.of(context).primaryColor : null),
      heroTag: widget.heroTag,
      child: Icon(widget.icon),
      onPressed: widget.onPressed as void Function()?,
      shape: widget.outline
          ? CircleBorder(
              side: BorderSide(
                color: widget.outlineColor ?? Theme.of(context).primaryColor,
              ),
            )
          : null,
    );
  }
}
