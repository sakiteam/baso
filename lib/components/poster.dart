part of "package:baso/baso.dart";

class Poster extends StatefulWidget {
  final IconData? icon;
  final String? title;
  final String? description;
  final String? image;
  final bool nested;
  final bool dark;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final Widget? content;

  const Poster({
    Key? key,
    this.icon,
    this.title = "",
    this.description = "",
    this.image = "",
    this.nested = false,
    this.dark = false,
    this.titleStyle,
    this.descriptionStyle,
    this.content,
  }) : super(key: key);

  @override
  _PosterState createState() => _PosterState();
}

class _PosterState extends State<Poster> {
  @override
  void initState() {
    super.initState();
    // _init();
  }

  // void _init() async {
  //   Compress
  //   List<int> image = await testCompressFile(file);
  //   ImageProvider provider = MemoryImage(Uint8List.fromList(image));
  // }

  @override
  Widget build(BuildContext context) {
// Image(
//   image: provider ?? AssetImage("img/img.jpg"),
// ),
//

    final imageHeight = 150.0;
    final double w = min(750, MediaQuery.of(context).size.width);

    return CustomSlide(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: widget.image!.isNotEmpty
                  ? (widget.image!.contains("https")
                      ? Image.network(
                          widget.image!,
                          height: imageHeight,
                        )
                      : (widget.image!.contains("assets/images/")
                          ? (widget.image!.endsWith("svg")
                              ? SvgPicture.asset(
                                  widget.image!,
                                  height: imageHeight,
                                )
                              : Image.asset(
                                  widget.image!,
                                  height: imageHeight,
                                ))
                          : Image.file(
                              IO.File(widget.image!),
                              height: imageHeight,
                            )))
                  : Container(
                      width: widget.nested ? 100 : 120,
                      height: widget.nested ? 100 : 120,
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withAlpha(25),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 2),
                          borderRadius: BorderRadius.circular(60)),
                      child: widget.icon != null
                          ? Icon(widget.icon, size: widget.nested ? 40 : 48)
                          : null),
            ),
            if (widget.title!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: CustomText(widget.title,
                    style: widget.titleStyle ??
                        TextStyle(
                          fontSize: widget.nested ? 20 : 24,
                          // fontFamily: "Brandon",
                          color: widget.dark ? Colors.white : null,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center),
              ),
            SizedBox(height: 16),
            if (widget.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: CustomText(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: widget.descriptionStyle ??
                      TextStyle(
                        fontSize: widget.nested ? 16 : 18,
                        color: Colors.grey,
                        // fontFamily: "Brandon",
                      ),
                ),
              ),
            Container(child: widget.content),
          ],
        ),
      ),
    );
  }
}
