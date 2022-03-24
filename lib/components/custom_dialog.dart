part of "package:baso/baso.dart";

class CustomDialog extends StatefulWidget {
  final String title;
  final String description;
  final List<Widget>? actions;
  final String? image;
  final Function? onAccepted;
  final Function? onRejected;
  final String rejectionText;
  final String acceptanceText;
  final Color? color;
  final bool simple;
  final bool outlineOnSimple;
  final bool loading;
  final List<Widget>? content;
  final IconData? icon;
  final Color? iconColor;

  final bool radioList;
  final String? radioValue;
  final List<String>? radioValues;
  final List<String>? radioTitles;
  final List<String>? radioSubtitles;
  final Function? onRadioChanged;

  final Widget? body;
  final bool popOnAccepted;

  const CustomDialog({
    this.title = "",
    this.description = "",
    this.actions,
    this.image,
    this.onAccepted,
    this.onRejected,
    this.rejectionText = "",
    this.acceptanceText = "",
    this.color,
    this.simple = false,
    this.content,
    this.radioList = false,
    this.onRadioChanged,
    this.radioTitles,
    this.radioValues,
    this.radioSubtitles,
    this.radioValue,
    this.loading = false,
    this.icon,
    this.iconColor,
    this.body,
    this.popOnAccepted = true,
    this.outlineOnSimple = true,
  });

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  String? _radioValue;

  @override
  void initState() {
    _radioValue = widget.radioValue ?? "GLOBAL";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget>? _customContent = widget.content;

    final onChanged = (value) {
      if (value != null) {
        setState(() {
          _radioValue = value;
        });

        if (widget.onRadioChanged != null) {
          widget.onRadioChanged!(_radioValue);
        }
      }

      Navigator.pop(context);
    };

    if (widget.radioList) {
      List<String> values =
          widget.radioValues ?? ["GLOBAL", "INTERNAL", "EXTERNAL"];

      _customContent = values.map((element) {
        final index = values.indexOf(element);

        return CustomSlide(
          child: RadioListTile(
            title: Text(widget.radioTitles![index]),
            subtitle: Text(
              widget.radioSubtitles![index],
              overflow: TextOverflow.ellipsis,
            ),
            value: element,
            groupValue: _radioValue,
            onChanged: onChanged,
            // toggleable: true,
            secondary: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.keyboard_arrow_right),
            ),
          ),
        );
      }).toList();
    }

    String? image = widget.image;

    if (widget.radioList) {
      image = widget.image ?? "assets/images/filtering.svg";
    }

    return AlertDialog(
      insetPadding: EdgeInsets.all(32),
      titlePadding: EdgeInsets.all(0),
      buttonPadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      content: Container(
        width: 500,
        child: SingleChildScrollView(
          child: widget.body ??
              ListBody(
                children: <Widget>[
                      Container(
                        color: Color(0xFFEEEEEE),
                        height: 180,
                        child: image != null
                            ? SvgPicture.asset(image)
                            : (widget.icon != null
                                ? Icon(widget.icon,
                                    size: 150,
                                    color: widget.iconColor ?? Colors.grey)
                                : null),
                        padding: EdgeInsets.all(8),
                      ),
                      Divider(height: 0),
                      if (_customContent == null)
                        SizedBox(
                          height: 16,
                        ),
                      if (_customContent == null)
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomSlide(
                              child: Text(
                                widget.title,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      if (_customContent == null)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomSlide(
                              child: Text(
                                widget.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_customContent == null)
                        CustomSlide(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: widget.loading
                                ? Center(
                                    child: CustomButton(
                                      loading: true,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                        SizedBox(
                                          width: 120,
                                          child: CustomButton(
                                            color: widget.color,
                                            outline: !widget.simple ||
                                                widget.outlineOnSimple,
                                            label: widget.simple
                                                ? (widget.acceptanceText.isEmpty
                                                    ? "OK"
                                                    : widget.acceptanceText
                                                        .toUpperCase())
                                                : (widget.rejectionText.isEmpty
                                                    ? "ANNULER"
                                                    : widget.rejectionText
                                                        .toUpperCase()),

                                            // (widget.rejectionText.isEmpty
                                            //     ? (widget.simple
                                            //         ? "OK"
                                            //         : "ANNULER")
                                            //     : widget.rejectionText
                                            //         .toUpperCase()),

                                            onPressed: () {
                                              if (!widget.simple ||
                                                  widget.popOnAccepted) {
                                                Navigator.of(context).pop();
                                              }

                                              if (widget.simple) {
                                                if (widget.onAccepted != null) {
                                                  widget.onAccepted!();
                                                }
                                              } else {
                                                if (widget.onRejected != null) {
                                                  widget.onRejected!();
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                        if (!widget.simple)
                                          SizedBox(
                                            width: 16,
                                          ),
                                        if (!widget.simple)
                                          SizedBox(
                                            width: 120,
                                            child: CustomButton(
                                              color: widget.color,
                                              label: widget.acceptanceText,
                                              onPressed: () async {
                                                if (widget.popOnAccepted) {
                                                  Navigator.of(context).pop();
                                                }

                                                if (widget.onAccepted != null) {
                                                  widget.onAccepted!();
                                                }
                                              },
                                            ),
                                          ),
                                      ]),
                          ),
                        ),
                    ] +
                    (_customContent ?? []),
              ),
        ),
      ),
    );
  }
}
