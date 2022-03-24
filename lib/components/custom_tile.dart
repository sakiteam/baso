part of "package:baso/baso.dart";

class CustomTile extends StatefulWidget {
  // Expandable
  final bool expandable;

  // Classic
  final Widget? title;
  final Widget? leading;
  final Widget? subtitle;
  final Widget? trailing;

  // Texts
  final String? titleText;
  final String? subtitleText;
  final String? leadingText;
  final String? trailingText;

  final String? subtitleText1;
  final String? subtitleText2;
  final String? trailingText1;
  final String? trailingText2;

  // States
  final CustomTextState? titleTextState;
  final CustomTextState? subtitleTextState;
  final CustomTextState? leadingTextState;
  final CustomTextState? trailingTextState;

  final CustomTextState? subtitleText1State;
  final CustomTextState? subtitleText2State;
  final CustomTextState? trailingText1State;
  final CustomTextState? trailingText2State;

  // Expansion colors
  final Color? expandedBackgroundColor;
  final Color? collapsedBackgroundColor;

  // Miscelleanous
  final bool? dense;
  final bool selected;
  final Function? onTap;
  final Color? tileColor;
  final bool isThreeLine;
  final List<Widget>? children;
  final Color? selectedTileColor;

  final EdgeInsets? padding;

  final double? minLeadingWidth;

  CustomTile({
    this.expandable = false,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.expandedBackgroundColor,
    this.collapsedBackgroundColor,
    this.children,
    this.dense,
    this.onTap,
    this.titleText,
    this.subtitleText,
    this.leadingText,
    this.trailingText,
    this.subtitleText1,
    this.subtitleText2,
    this.trailingText1,
    this.trailingText2,
    this.tileColor,
    this.selected = false,
    this.selectedTileColor,
    this.padding,
    this.isThreeLine = false,
    this.minLeadingWidth,
    this.titleTextState,
    this.subtitleTextState,
    this.leadingTextState,
    this.trailingTextState,
    this.subtitleText1State,
    this.subtitleText2State,
    this.trailingText1State,
    this.trailingText2State,
  });

  @override
  _CustomTileState createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  @override
  Widget build(BuildContext context) {
    Widget? title = widget.title;
    Widget? subtitle = widget.subtitle;
    Widget? trailing = widget.trailing;
    Widget? leading = widget.leading;

    if (widget.titleText != null) {
      title = CustomText(
        widget.titleText,
        overflow: TextOverflow.ellipsis,
        state: widget.titleTextState,
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    }

    if (widget.subtitleText != null) {
      //
    } else {
      if (widget.subtitleText1 != null && widget.subtitleText2 != null) {
        //
      }
    }

    if (widget.trailingText != null) {
      //
    } else {
      if (widget.trailingText1 != null && widget.trailingText2 != null) {
        //
      }
    }

    if (widget.leadingText != null) {
      title = CustomText(
        widget.leadingText,
        overflow: TextOverflow.ellipsis,
      );
    }

    return widget.expandable
        ? Container(
            color: widget.collapsedBackgroundColor,
            child: ExpansionTile(
              title: title!,
              subtitle: subtitle,
              trailing: trailing,
              leading: leading,
              backgroundColor: widget.expandedBackgroundColor,
              children: widget.children!,
              tilePadding: widget.padding,
            ),
          )
        : ListTile(
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            leading: leading,
            dense: widget.dense,
            minLeadingWidth: widget.minLeadingWidth,
            isThreeLine: widget.isThreeLine ||
                widget.trailingText1 != null ||
                widget.trailingText2 != null,
            onTap: widget.onTap as void Function()?,
            tileColor: widget.tileColor,
            selected: widget.selected,
            selectedTileColor: widget.selectedTileColor,
            contentPadding: widget.padding,
          );
  }
}
