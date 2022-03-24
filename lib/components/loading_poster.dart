part of "package:baso/baso.dart";

class LoadingPoster extends StatefulWidget {
  final bool nested;

  const LoadingPoster({
    this.nested = false,
  });

  @override
  _LoadingPosterState createState() => _LoadingPosterState();
}

class _LoadingPosterState extends State<LoadingPoster> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.nested ? 16 : 0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
