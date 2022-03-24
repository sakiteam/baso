part of "package:baso/baso.dart";

class ErrorPoster extends StatefulWidget {
  final bool nested;

  const ErrorPoster({
    this.nested = false,
  });

  @override
  _ErrorPosterState createState() => _ErrorPosterState();
}

class _ErrorPosterState extends State<ErrorPoster> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.symmetric(vertical: 16),
          child: Poster(
            nested: widget.nested,
            image: "assets/images/error.svg",
            title: "Une erreur est survenue !",
            description:
                "Si l'erreur est dûe à la connexion internet, cette page s'actualisera automatiquement lorsque vous aurez rétabli la connexion !",
          ),
        ),
      ),
    );
  }
}
