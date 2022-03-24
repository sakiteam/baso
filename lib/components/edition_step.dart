part of "package:baso/baso.dart";

class EditionStep extends StatefulWidget {
  final title;
  final description;
  final child;
  final padding;

  const EditionStep({
    this.child,
    this.description,
    this.title,
    this.padding,
  });

  @override
  _EditionStepState createState() => _EditionStepState();
}

class _EditionStepState extends State<EditionStep> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EditionTip(
          title: widget.title,
          description: widget.description,
        ),
        Expanded(
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: widget.padding ?? const EdgeInsets.all(16),
                child: widget.child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
