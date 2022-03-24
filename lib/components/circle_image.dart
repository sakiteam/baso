part of "package:baso/baso.dart";

class CircleImage extends StatefulWidget {
  final String url;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double size;
  final IconData icon;
  final bool loading;

  const CircleImage({
    Key? key,
    this.url = "",
    this.backgroundColor,
    this.foregroundColor,
    this.size = 40,
    this.icon = Icons.person,
    this.loading = false,
  }) : super(key: key);

  @override
  _CircleImageState createState() => _CircleImageState();
}

class _CircleImageState extends State<CircleImage> {
  @override
  Widget build(BuildContext context) {
    return widget.url.isEmpty || widget.loading
        ? CircleAvatar(
            child: widget.loading
                ? SizedBox(
                    child: CircularProgressIndicator(
                      color: widget.foregroundColor ?? Colors.white,
                    ),
                    width: min(40, widget.size * 24 / 40).toDouble(),
                    height: min(40, widget.size * 24 / 40).toDouble(),
                  )
                : Icon(
                    widget.icon,
                    size: widget.size * 24 / 40,
                  ),
            backgroundColor:
                widget.backgroundColor ?? Theme.of(context).primaryColor,
            foregroundColor: widget.foregroundColor ?? Colors.white,
            radius: widget.size / 2,
          )
        : Container(
            height: widget.size,
            width: widget.size,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.size / 2),
              // border: Border.all(color: Colors.grey),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                DynamicImage(
                  path: widget.url,
                  fit: BoxFit.cover,
                  width: widget.size,
                  height: widget.size,
                ),
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(widget.size / 2),
                  ),
                )
              ],
            ),
          );
  }
}
