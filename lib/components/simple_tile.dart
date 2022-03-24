part of "package:baso/baso.dart";

class SimpleTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final Icon? leading;
  final Icon? trailing;
  final void Function()? onPressed;

  const SimpleTile({
    this.title = "",
    this.subtitle = "",
    this.leading,
    this.trailing,
    this.onPressed,
  });

  @override
  _SimpleTileState createState() => _SimpleTileState();
}

class _SimpleTileState extends State<SimpleTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        widget.subtitle,
        overflow: TextOverflow.ellipsis,
      ),
      leading: widget.leading == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.leading,
            ),
      trailing: widget.trailing == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.trailing,
            ),
      onTap: widget.onPressed,
    );
  }
}
