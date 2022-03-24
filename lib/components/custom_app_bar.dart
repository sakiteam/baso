part of "package:baso/baso.dart";

class CustomAppBar extends PreferredSize {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final double? leadingWidth;
  final Brightness? brightness;
  final Widget? content;
  final bool enabled;
  final bool animated;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;
  final Size preferredSize;

  CustomAppBar({
    this.title = "",
    this.subtitle,
    this.actions,
    this.content,
    this.leading,
    this.leadingWidth,
    this.brightness,
    this.enabled = true,
    this.animated = true,
    this.backgroundColor,
    this.foregroundColor,
    this.preferredSize = const Size.fromHeight(56),
    this.bottom,
  }) : super(child: SizedBox(), preferredSize: preferredSize);

  // @override
  // final Size preferredSize = Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: AppBar(
        bottom: bottom,
        elevation: 0,
        leading: leading,
        actions: actions,
        centerTitle: true,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        brightness: brightness,
        leadingWidth: leadingWidth,
        title: CustomSlide(
          enabled: animated,
          child: content ??
              (subtitle == null
                  ? Text(title)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          subtitle!,
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
        ),
      ),
    );
  }
}
