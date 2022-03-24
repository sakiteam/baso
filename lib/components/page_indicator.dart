part of "package:baso/baso.dart";

class PageIndicator extends StatefulWidget {
  final PageController? controller;
  final bool top;
  final int count;
  final Color? color;
  final double margin;

  PageIndicator({
    this.controller,
    this.top = false,
    this.count = 3,
    this.color,
    this.margin = 0,
  });

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).primaryColor;

    return Container(
      transform: Matrix4.translationValues(-4, 0, 0),
      child: SmoothPageIndicator(
        controller: widget.controller!,
        count: widget.count,
        effect: SwapEffect(
          dotColor: color.withAlpha(100),
          dotHeight: 8,
          dotWidth: 8,
          activeDotColor: color,
        ),
      ),
    );
  }
}
