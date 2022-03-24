part of "package:baso/baso.dart";

class EmptyPoster extends StatefulWidget {
  final bool nested;
  final title;
  final description;
  final bool search;
  final String image;
  final Widget? content;

  const EmptyPoster({
    this.nested = false,
    this.title,
    this.description,
    this.search = false,
    this.image = "assets/images/emptiness.svg",
    this.content,
  });

  @override
  _EmptyPosterState createState() => _EmptyPosterState();
}

class _EmptyPosterState extends State<EmptyPoster> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.symmetric(vertical: 16),
          child: Poster(
            content: widget.content,
            nested: widget.nested,
            image: widget.image,
            title: widget.title ?? "Aucune donnée trouvée !",
            description: widget.search
                ? "Oh, désolé ! Aucun élément n'a été trouvé ! Vérifiez bien votre saisie pour voir si vous n'avez pas fait une petite erreur sur un terme !"
                : (widget.description ??
                    "Aucune donnée n'a été trouvée. Cependant, cette section s'actualisera automatiquement lorsqu'il y aura des données à afficher !"),
          ),
        ),
      ),
    );
  }
}
