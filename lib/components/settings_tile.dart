part of "package:baso/baso.dart";

class SettingsTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final void Function()? onPressed;

  const SettingsTile({
    this.title = "",
    this.subtitle = "",
    this.icon,
    this.onPressed,
  });

  @override
  _SettingsTileState createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  @override
  Widget build(BuildContext context) {
    return SimpleTile(
      title: widget.title,
      subtitle: widget.subtitle,
      leading: widget.icon == null ? null : Icon(widget.icon),
      trailing: Icon(Icons.keyboard_arrow_right),
      onPressed: widget.onPressed,
    );
  }
}
