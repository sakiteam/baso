part of "package:baso/baso.dart";

enum CustomTextState {
  Bad,
  Good,
  Primary,
  Critical,
  Accent,
  Light,
  Dark,
  Default,
  Grey,
}

class CustomText extends StatefulWidget {
  final String? text;
  final TextAlign? textAlign;
  final TextStyle? style;
  final TextOverflow? overflow;
  final CustomTextState? state;

  CustomText(
    this.text, {
    this.textAlign,
    this.style,
    this.overflow,
    this.state = CustomTextState.Default,
  });

  @override
  _CustomTextState createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text!,
      overflow: widget.overflow,
      style: (widget.style ?? TextStyle()).copyWith(
          fontFamily: "Brandon",
          color: () {
            switch (widget.state) {
              case CustomTextState.Bad:
                return Colors.red;
              case CustomTextState.Good:
                return Colors.green;
              case CustomTextState.Primary:
                return Theme.of(context).primaryColor;
              case CustomTextState.Accent:
                return Theme.of(context).colorScheme.secondary;
              case CustomTextState.Critical:
                return Colors.orange;
              case CustomTextState.Dark:
                return Colors.black;
              case CustomTextState.Light:
                return Colors.white;
              case CustomTextState.Grey:
                return Colors.grey;
              case CustomTextState.Default:
                return null;
              default:
                return null;
            }
          }()),
      textAlign: widget.textAlign,
    );
  }
}
