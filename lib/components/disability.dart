part of "package:baso/baso.dart";

class Disability extends StatefulWidget {
  final Widget? child;
  final bool condition;
  final double opacity;

  const Disability({
    this.child,
    this.condition = true,
    this.opacity = 0.5,
  });

  @override
  _DisabilityState createState() => _DisabilityState();
}

class _DisabilityState extends State<Disability> {
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.condition,
      child: Opacity(
        opacity: widget.condition ? widget.opacity : 1,
        child: widget.child,
      ),
    );
  }
}
