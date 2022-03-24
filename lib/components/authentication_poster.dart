part of "package:baso/baso.dart";

class AuthenticationPoster extends StatefulWidget {
  const AuthenticationPoster({Key? key}) : super(key: key);

  @override
  _AuthenticationPosterState createState() => _AuthenticationPosterState();
}

class _AuthenticationPosterState extends State<AuthenticationPoster> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Poster(
          title: "Authentification requise !",
          image: "assets/images/prohibition.svg",
          description:
              "Désolé ! Vous devez être authentifié afin d'accéder à cette section. Alors, connectez-vous ou créez rapidement un compte !",
        ),
        const SizedBox(height: 16),
        Center(
          child: SizedBox(
            width: 150,
            child: CustomButton(
              label: "Se connecter",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenericAuthenticationPage(),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: SizedBox(
            width: 150,
            child: CustomButton(
              label: "S'inscrire",
              flat: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenericAuthenticationPage(),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
