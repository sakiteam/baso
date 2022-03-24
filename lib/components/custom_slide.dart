part of "package:baso/baso.dart";

class CustomSlide extends StatefulWidget {
  final Widget child;
  final bool vertical;
  final bool once;
  final bool enabled;

  const CustomSlide({
    Key? key,
    required this.child,
    this.vertical = false,
    this.once = true,
    this.enabled = true,
  }) : super(key: key);

  @override
  _CustomSlideState createState() => _CustomSlideState();
}

class _CustomSlideState extends State<CustomSlide> {
  // bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    // return widget.child;

    // if (_initialized || !widget.enabled) {
    //   return widget.child;
    // }

    // _initialized = widget.once;

    return DelayedDisplay(
      child: widget.child,
      fadingDuration: const Duration(milliseconds: 500),
      slidingBeginOffset:
          widget.vertical ? const Offset(0, 0.25) : const Offset(0.25, 0),
    );
  }
}
