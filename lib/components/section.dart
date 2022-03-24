part of "package:baso/baso.dart";

class Section extends StatefulWidget {
  final String? title;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool centerTile;
  final Widget? trailing;
  final EdgeInsets? padding;

  Section({
    this.title,
    this.backgroundColor,
    this.titleColor,
    this.centerTile = false,
    this.trailing,
    this.padding,
  });

  @override
  _SectionState createState() => _SectionState();
}

class _SectionState extends State<Section> {
  @override
  Widget build(BuildContext context) {
    final title = CustomText(
      widget.title!.toUpperCase(),
      overflow: TextOverflow.ellipsis,
      // state: CustomTextState.Accent,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: widget.titleColor ?? Theme.of(context).colorScheme.secondary,
      ),
    );

    return Material(
      color:
          widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: CustomTile(
        // titleText: widget.title.toUpperCase(),
        title: widget.centerTile ? Center(child: title) : title,
        // titleTextState: CustomTextState.Accent,
        trailing: widget.trailing,
        padding: widget.padding,
      ),
    );
  }
}
