part of "package:baso/baso.dart";

class SearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final Function? onChanged;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool button;
  final void Function()? onTap;
  final bool autofocus;
  final void Function()? onEditingComplete;
  final bool prefixIconAlwaysVisible;
  final bool suffixIconAlwaysVisible;
  final Color borderColor;
  final double borderWidth;
  final Color backgroundColor;

  SearchBar({
    this.controller,
    this.onChanged,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.button = false,
    this.autofocus = false,
    this.onTap,
    this.onEditingComplete,
    this.prefixIconAlwaysVisible = false,
    this.suffixIconAlwaysVisible = false,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.backgroundColor = Colors.white,
  });

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    final searchBarBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: widget.borderColor,
        width: widget.borderWidth,

        // color: Colors.red,
      ),
    );

    final defaultSuffixIcon = IconButton(
      icon: Icon(
        Icons.clear,
        color: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        widget.controller!.clear();

        if (widget.onChanged != null) {
          widget.onChanged!("");
        }
      },
    );

    final defaultPrefixIcon = Padding(
      padding: const EdgeInsets.all(12.0),
      child: Icon(
        Icons.search,
        color: Theme.of(context).primaryColor,
      ),
    );

    return IconTheme(
      data: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      child: Stack(
        children: [
          if (!widget.button)
            IgnorePointer(
              ignoring: widget.button,
              child: TextField(
                autofocus: widget.autofocus,
                controller: widget.controller,
                onChanged: widget.onChanged as void Function(String)?,
                textAlign: TextAlign.center,
                onTap: widget.onTap,
                onEditingComplete: widget.onEditingComplete,
                decoration: InputDecoration(
                  fillColor: widget.backgroundColor,
                  filled: true,
                  hintText: widget.hint,
                  border: searchBarBorder,
                  errorBorder: searchBarBorder,
                  enabledBorder: searchBarBorder,
                  focusedBorder: searchBarBorder,
                  disabledBorder: searchBarBorder,
                  focusedErrorBorder: searchBarBorder,
                  contentPadding: EdgeInsets.zero,
                  suffixIcon: AbsorbPointer(
                      child: Opacity(opacity: 0, child: defaultSuffixIcon)),
                  prefixIcon: AbsorbPointer(
                      child: Opacity(opacity: 0, child: defaultPrefixIcon)),
                ),
              ),
            ),
          if (widget.button)
            Positioned.fill(
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: widget.onTap,
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: IgnorePointer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: TextField(
                          readOnly: true,
                          onEditingComplete: widget.onEditingComplete,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: widget.hint,

                            fillColor: widget.backgroundColor,
                            filled: true,
                            // hintText: widget.hint,
                            border: searchBarBorder,
                            errorBorder: searchBarBorder,
                            enabledBorder: searchBarBorder,
                            focusedBorder: searchBarBorder,
                            disabledBorder: searchBarBorder,
                            focusedErrorBorder: searchBarBorder,
                            contentPadding: EdgeInsets.zero,

                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(8),
                            //   borderSide: BorderSide(
                            //     color: Colors.transparent,
                            //     width: 0,
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: widget.prefixIconAlwaysVisible ||
                    (widget.controller != null &&
                        // widget.controller.text.isEmpty &&
                        widget.prefixIcon != null)
                ? widget.prefixIcon
                : defaultPrefixIcon,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: widget.suffixIconAlwaysVisible ||
                    (widget.controller != null &&
                        widget.controller!.text.isEmpty &&
                        widget.suffixIcon != null)
                ? widget.suffixIcon
                : defaultSuffixIcon,
          )
        ],
      ),
    );
  }
}
