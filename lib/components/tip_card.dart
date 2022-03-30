part of "package:baso/baso.dart";

class TipCard extends StatefulWidget {
  final String title;
  final String description;
  final String action;
  final Function? onPressed;
  final String id;
  final EdgeInsets? margin;
  final bool condition;
  final Color? color;

  const TipCard({
    Key? key,
    this.title = "",
    required this.description,
    this.action = "J'AI COMPRIS",
    this.onPressed,
    this.id = "default",
    this.condition = true,
    this.margin,
    this.color,
  }) : super(key: key);

  @override
  _TipCardState createState() => _TipCardState();
}

class _TipCardState extends State<TipCard> {
  bool getCondition() {
    return GenericGlobalService.getBool(widget.id) ?? true;
  }

  void setCondition() {
    GenericGlobalService.setBool(widget.id, false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: !(getCondition() && widget.condition) ? 0 : 225,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 250),
        opacity: !(getCondition() && widget.condition) ? 0 : 1,
        child: Card(
          elevation: 0,
          margin: widget.margin ?? EdgeInsets.all(16),
          color: widget.color ?? lighten(Theme.of(context).primaryColorLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Text(
                  //   widget.title,
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  // ),
                  Center(
                    child: Icon(Icons.info_outline),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 57,
                    child: AutoSizeText(
                      widget.description,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      minFontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      child: Text(widget.action),
                      onPressed: () {
                        if (widget.id != "default") {
                          setState(() {
                            setCondition();
                          });
                        }

                        if (widget.onPressed != null) {
                          widget.onPressed!();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color lighten(Color color, [double amount = .05]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
