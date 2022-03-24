part of "package:baso/baso.dart";

class CustomTextField extends StatefulWidget {
  final Color color;
  final String? hint;
  final String? label;
  final int minLines;
  final int maxLines;
  final Function? onChanged;
  final Function? onCleared;
  final Function? onEditingComplete;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final bool clear;
  final bool enabled;
  final EdgeInsets? contentPadding;
  final bool borderless;
  final BorderRadius? borderRadius;
  final bool autofocus;
  final Color? fillColor;
  final bool readOnly;
  final TextAlign? textAlign;
  final EdgeInsets? margin;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    Key? key,
    this.hint,
    this.label,
    this.minLines = 1,
    this.maxLines = 1,
    this.controller,
    this.onChanged,
    this.color = Colors.black,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.clear = false,
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
    this.textAlign,
    this.onTap,
    this.margin,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final defaultBorder = OutlineInputBorder(
      borderSide:
          widget.borderless ? BorderSide.none : BorderSide(color: Colors.grey),
      borderRadius:
          widget.borderRadius ?? const BorderRadius.all(Radius.circular(8)),
    );

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: AbsorbPointer(
        absorbing: !widget.enabled,
        child: Opacity(
          opacity: widget.enabled ? 1 : 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.label != null)
                CustomLabel(
                  widget.label,
                  color: widget.color,
                ),
              TextField(
                textCapitalization: widget.textCapitalization,
                onTap: widget.onTap,
                inputFormatters: widget.inputFormatters,
                readOnly: widget.readOnly,
                autofocus: widget.autofocus,
                controller: widget.controller,
                textAlign: widget.textAlign ?? TextAlign.start,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                onChanged: widget.onChanged as void Function(String)?,
                keyboardType: widget.keyboardType,
                onEditingComplete: widget.onEditingComplete as void Function()?,
                decoration: InputDecoration(
                  contentPadding: widget.contentPadding,
                  focusedBorder: OutlineInputBorder(
                    borderSide: widget.borderless
                        ? BorderSide.none
                        : BorderSide(
                            width: 1,
                            color: widget.color,
                            // ?? Theme.of(context).primaryColor,
                          ),
                    borderRadius: widget.borderRadius ??
                        const BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: defaultBorder,
                  border: defaultBorder,
                  prefixIcon: widget.prefixIcon,
                  prefix: widget.prefix,
                  suffix: widget.suffix,
                  fillColor: widget.fillColor ?? Colors.white,
                  filled: true,
                  hintText: widget.hint,
                  suffixIcon: widget.clear &&
                          widget.controller != null &&
                          widget.controller!.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            if (widget.controller != null) {
                              widget.controller!.clear();
                            }

                            if (widget.onCleared != null) {
                              widget.onCleared!();
                            }

                            if (widget.onChanged != null) {
                              widget.onChanged!(widget.controller!.text);
                            }

                            setState(() {});
                          },
                        )
                      : widget.suffixIcon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
