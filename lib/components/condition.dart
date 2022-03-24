part of "package:baso/baso.dart";

class Condition extends StatefulWidget {
  final String term;
  final int index;

  const Condition({
    this.term = "",
    this.index = 0,
  });

  @override
  _ConditionState createState() => _ConditionState();
}

class _ConditionState extends State<Condition> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Center(
              child: Text(
                widget.term,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            alignment: Alignment.topCenter,
            child: Container(
              width: 120,
              height: 32,
              alignment: Alignment.center,
              child: Text(
                "CONDITION  ${widget.index + 1}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
