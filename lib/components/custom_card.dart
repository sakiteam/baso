part of "package:baso/baso.dart";

class CustomCard extends StatefulWidget {
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final Widget? child;
  final Color? color;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final EdgeInsets? padding;
  final double elevation;

  const CustomCard({
    Key? key,
    this.width,
    this.height,
    this.margin,
    this.child,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.padding,
    this.elevation = 0,
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin ?? EdgeInsets.zero,
      child: Card(
        elevation: widget.elevation,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        color: widget.color ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          side: BorderSide(
            color: widget.borderColor ?? Colors.grey,
            width: widget.borderWidth ?? 1,
          ),
        ),
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: widget.child,
        ),
      ),
    );
  }
}
