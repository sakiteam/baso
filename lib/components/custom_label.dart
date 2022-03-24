part of "package:baso/baso.dart";

class CustomLabel extends StatefulWidget {
  final String? text;
  final Color color;
  final TextAlign? textAlign;

  const CustomLabel(this.text, {this.color = Colors.black, this.textAlign});

  @override
  _CustomLabelState createState() => _CustomLabelState();
}

class _CustomLabelState extends State<CustomLabel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        widget.text!.toUpperCase(),
        textAlign: widget.textAlign,
        style: TextStyle(
          fontSize: 14,
          color: widget.color, // ?? Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
