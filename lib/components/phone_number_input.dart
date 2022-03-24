part of "package:baso/baso.dart";

class PhoneNumberInput extends StatefulWidget {
  final Color? color;
  final String? label;
  final Function? onChanged;
  final Function? onCleared;
  final Function? onEditingComplete;
  final TextEditingController phoneController;
  final TextEditingController countryController;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final bool enabled;
  final EdgeInsets? contentPadding;
  final bool borderless;
  final BorderRadius? borderRadius;
  final bool autofocus;
  final Color? fillColor;
  final bool readOnly;

  const PhoneNumberInput({
    this.label,
    required this.phoneController,
    required this.countryController,
    this.onChanged,
    this.color,
    this.suffixIcon,
    this.onCleared,
    this.prefix,
    this.suffix,
    this.onEditingComplete,
    this.enabled = true,
    this.contentPadding,
    this.borderless = false,
    this.borderRadius,
    this.autofocus = false,
    this.fillColor,
    this.readOnly = false,
  });

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomTextField(
          // Default properties
          clear: true,
          hint: "Ex : 0123456789",
          keyboardType: TextInputType.number,
          prefixIcon: SizedBox(
            width: 40,
            height: 60,
          ),

          // Settable properties
          label: widget.label,
          controller: widget.phoneController,
          onChanged: widget.onChanged,
          color: widget.color ?? Colors.black,
          suffixIcon: widget.suffixIcon,
          onCleared: widget.onCleared,
          prefix: widget.prefix,
          suffix: widget.suffix,
          onEditingComplete: widget.onEditingComplete,
          enabled: widget.enabled,
          contentPadding: widget.contentPadding,
          borderless: widget.borderless,
          borderRadius: widget.borderRadius,
          autofocus: widget.autofocus,
          fillColor: widget.fillColor,
          readOnly: widget.readOnly,
        ),

        //
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 50,
            height: 60,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhoneNumberSelection(
                      callback: (code) {
                        if (mounted)
                          setState(() {
                            widget.countryController.text = code;
                          });
                      },
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 1.5),
                child: Text(
                  widget.countryController.text.replaceAll(" ", ""),
                  style: TextStyle(
                    fontSize:
                        widget.countryController.text.length == 5 ? 10 : 12,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
