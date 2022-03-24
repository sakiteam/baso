part of "package:baso/baso.dart";

class GenericSettingsPage extends StatefulWidget {
  final List<Widget>? content;
  final String? shareLink;
  final bool loadingLink;
  final String Function(String)? shareTextBuilder;

  const GenericSettingsPage({
    this.content,
    this.shareLink,
    this.loadingLink = false,
    this.shareTextBuilder,
  });

  @override
  _GenericSettingsPageState createState() => _GenericSettingsPageState();
}

class _GenericSettingsPageState extends State<GenericSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: "Paramètres",
        actions: [
          Disability(
            condition: widget.loadingLink,
            child: IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                String link = "";

                if (widget.shareLink == null ||
                    !GenericGlobalService.authenticated) {
                  if (Platform.isAndroid) {
                    link = CustomApp.androidLink;
                  } else {
                    link = CustomApp.iOSLink;
                  }
                } else {
                  link = widget.shareLink!;
                }

                final String shareText = widget.shareTextBuilder == null
                    ? "J'ai découvert une superbe application ! Téléchargez-la gratuitement sur $link !"
                    : widget.shareTextBuilder!(link);

                Share.share(
                  shareText,
                  subject: "Téléchargement de ${CustomApp.name}",
                );
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          top: false,
          left: false,
          right: false,
          child: Column(
            children:
                widget.content!.map((e) => CustomSlide(child: e)).toList(),
          ),
        ),
      ),
    );
  }
}
