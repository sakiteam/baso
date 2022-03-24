part of "package:baso/baso.dart";

class EditionTip extends StatefulWidget {
  final String? title;
  final String? description;
  final Color? color;

  const EditionTip({
    required this.title,
    required this.description,
    this.color,
  });

  @override
  _EditionTipState createState() => _EditionTipState();
}

class _EditionTipState extends State<EditionTip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color ?? Theme.of(context).primaryColorLight,
      padding: EdgeInsets.all(16),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomLabel(
              widget.title,
              color: Colors.black,
              textAlign: TextAlign.center,
            ),
            Text(
              widget.description!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  // fontSize: 12,
                  // color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
