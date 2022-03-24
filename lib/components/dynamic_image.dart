part of "package:baso/baso.dart";

class DynamicImage extends StatefulWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const DynamicImage({
    Key? key,
    required this.path,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  @override
  _DynamicImageState createState() => _DynamicImageState();
}

class _DynamicImageState extends State<DynamicImage> {
  @override
  Widget build(BuildContext context) {
    final double circleSize = min(40,
        (min(widget.width ?? 40, widget.height ?? 40) * 24 / 40).toDouble());

    return (widget.path.contains("http")
        ? CachedNetworkImage(
            imageUrl: widget.path,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            progressIndicatorBuilder: (_, __, ___) {
              return Center(
                child: SizedBox(
                  width: circleSize,
                  height: circleSize,
                  child: CircularProgressIndicator(),
                ),
              );
            },
            errorWidget: (_, __, ___) {
              return const Icon(Icons.image_not_supported);
            },
          )
        : (widget.path.contains("assets/images/")
            ? (widget.path.endsWith("svg")
                ? SvgPicture.asset(
                    widget.path,
                    width: widget.width,
                    height: widget.height,
                    fit: widget.fit ?? BoxFit.contain,
                  )
                : Image.asset(
                    widget.path,
                    width: widget.width,
                    height: widget.height,
                    fit: widget.fit,
                  ))
            : Image.file(
                IO.File(widget.path),
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
              )));
  }
}
