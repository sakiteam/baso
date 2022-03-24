part of "package:baso/baso.dart";

class CustomButton extends StatefulWidget {
  final bool flat;
  final IconData? icon;
  final String label;
  final bool loading;
  final Function? onPressed;
  final bool outline;
  final Color? color;
  final Widget? child;
  final EdgeInsets? padding;

  const CustomButton({
    this.flat = false,
    this.icon,
    this.label = "",
    this.loading = false,
    this.onPressed,
    this.outline = false,
    this.color,
    this.padding,
    this.child,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    final textWidget = widget.child ??
        Text(
          widget.label.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
          ),
        );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    );

    return widget.loading
        ? Stack(
            children: [
              Opacity(
                opacity: 0,
                child: TextButton(
                  child: Text(""),
                  onPressed: null,
                ),
              ),
              Positioned.fill(
                  child: Center(
                child: CircularProgressIndicator(),
              ))
            ],
          )
        : (widget.outline
            ? OutlinedButton(
                onPressed: widget.onPressed as void Function()?,
                child: textWidget,
                style: OutlinedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  primary: widget.color,
                  padding: widget.padding,
                  shape: shape,
                ),
              )
            : (widget.flat
                ? TextButton(
                    onPressed: widget.onPressed as void Function()?,
                    child: textWidget,
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      primary: widget.color,
                      padding: widget.padding,
                      shape: shape,
                    ),
                  )
                : ElevatedButton(
                    onPressed: widget.onPressed as void Function()?,
                    child: textWidget,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: widget.color,
                      shadowColor: Colors.transparent,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: widget.padding,
                      shape: shape,
                    ),
                  )));
  }
}
