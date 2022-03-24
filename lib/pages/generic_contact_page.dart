part of "package:baso/baso.dart";

class GenericContactPage extends StatefulWidget {
  final bool critical;

  const GenericContactPage({
    this.critical = false,
  });

  @override
  _GenericContactPageState createState() => _GenericContactPageState();
}

class _GenericContactPageState extends State<GenericContactPage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.critical
          ? ThemeData(
              primarySwatch: Colors.red,
              fontFamily: "Brandon",
              dividerColor: Colors.grey,
              scaffoldBackgroundColor: Color(0xFFEEEEEE),
            )
          : Theme.of(context),
      child: CustomScaffold(
        appBar: CustomAppBar(
          title: "Contact",
          brightness:
              widget.critical == true ? Brightness.dark : Brightness.light,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              minimum: EdgeInsets.only(bottom: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  Poster(
                    image: widget.critical
                        ? "assets/images/revocation.svg"
                        : "assets/images/contact.svg",
                    title: "Contactez Saki !",
                    description:
                        "Avez-vous des questions, des critiques et/ou des suggestions. Alors, n'hésitez-pas à nous contacter à n'importe quel moment !",
                  ),
                  SizedBox(height: 16),
                  CustomSlide(
                    child: SizedBox(
                      width: 200,
                      child: CustomButton(
                        onPressed: () {
                          launch("tel:+2250544825758");
                        },
                        label: "Appeler Saki",
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  CustomSlide(
                    child: SizedBox(
                      width: 200,
                      child: CustomButton(
                        flat: true,
                        onPressed: () {
                          launch("mailto:sakihub@gmail.com");
                        },
                        label: "Envoyer un mail",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
