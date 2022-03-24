part of "package:baso/baso.dart";

class Heading extends StatefulWidget {
  final String? text1;
  final String? text2;

  Heading({this.text1, this.text2});

  @override
  _HeadingState createState() => _HeadingState();
}

class _HeadingState extends State<Heading> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: widget.text1! + ' : ',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontFamily: "Brandon",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        children: <TextSpan>[
          TextSpan(
            text: widget.text2,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
