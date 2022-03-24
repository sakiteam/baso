part of "package:baso/baso.dart";

class CustomApp extends StatefulWidget {
  // static final GlobalKey<NavigatorState> navigatorKey =
  //     GlobalKey<NavigatorState>();

  final Function? firstInit;
  final Function? lastInit;
  final Function? dispose;
  final Function? mainInit;
  final Function(BuildContext)? didChangeDependencies;
  final Color? primarySwatch;

  // Basics
  static String name = "";
  static String presentation = "";
  static String version = "";

  // Pages
  static late Widget Function([Map<String, dynamic>]) blockingPage;
  static late Widget Function([Map<String, dynamic>]) presentationPage;
  static late Widget Function([Map<String, dynamic>]) homePage;

  // Calling
  static Widget Function()? callingPage;

  // Services
  static late Function globalServiceReset;
  static late Function backendServiceReset;

  // Links
  static String androidLink = "";
  static String iOSLink = "";

  static bool authenticationRequired = true;
  static bool calling = false;

  // Callbacks
  static Future<void> Function(bool)? onAuthenticated;
  static Future<void> Function()? beforeAuthentication;

  // Refresh function
  static void Function()? refresh;

  // User creation
  static Map<String, dynamic> Function(Map<String, dynamic>)? onUserCreation;

  CustomApp({
    this.firstInit,
    this.lastInit,
    this.primarySwatch,
    this.mainInit,
    this.didChangeDependencies,
    this.dispose,
    String name = "",
    String presentation = "",
    String androidLink = "",
    String iOSLink = "",
    bool authenticationRequired = true,
    Function? globalServiceReset,
    Function? backendServiceReset,
    Widget Function([Map<String, dynamic>])? blockingPage,
    Widget Function([Map<String, dynamic>])? presentationPage,
    Widget Function([Map<String, dynamic>])? homePage,
    Map<String, dynamic> Function(Map<String, dynamic>)? onUserCreation,
  }) {
    // Basics
    CustomApp.name = name;
    CustomApp.presentation = presentation;

    // Links
    CustomApp.iOSLink = iOSLink;
    CustomApp.androidLink = androidLink;

    // User creation
    CustomApp.onUserCreation = onUserCreation;

    // Services
    if (globalServiceReset != null) {
      CustomApp.globalServiceReset = globalServiceReset;
    }
    if (backendServiceReset != null) {
      CustomApp.backendServiceReset = backendServiceReset;
    }

    // Pages
    CustomApp.blockingPage = blockingPage ??
        ([Map<String, dynamic> mappingObject = const {}]) =>
            const CustomScaffold();
    CustomApp.presentationPage = presentationPage ??
        ([Map<String, dynamic> mappingObject = const {}]) =>
            const CustomScaffold();
    CustomApp.homePage = homePage ??
        ([Map<String, dynamic> mappingObject = const {}]) =>
            const CustomScaffold();

    // Authentication
    CustomApp.authenticationRequired = authenticationRequired;
  }

  void run() async {
    // Ensure widgets are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Remove status bar color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    // Init Firebase
    await Firebase.initializeApp();

    // Import initializations
    await GenericGlobalService.init();

    try {
      CountriesService.getCountries();
      GenericMessagingService.saveToken();
    } catch (e) {}

    // Save app version
    CustomApp.version = (await PackageInfo.fromPlatform()).version;

    // Init app
    if (mainInit != null) {
      await mainInit!();
    }

    // Run
    runApp(this);
  }

  static void logout(BuildContext context) async {
    CustomApp.backendServiceReset();

    await GenericBackendService.signOut();

    if (CustomApp.authenticationRequired) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => GenericAuthenticationPage(),
        ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => CustomApp.homePage(),
        ),
        (route) => false,
      );
    }
  }

  @override
  _CustomAppState createState() => _CustomAppState();
}

class _CustomAppState extends State<CustomApp> with WidgetsBindingObserver {
  @override
  void initState() {
    CustomApp.refresh = () {
      // if (mounted) {
      //   setState(() {});
      // }
    };

    if (widget.firstInit != null) widget.firstInit!();
    super.initState();
    if (widget.lastInit != null) widget.lastInit!();

    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: GetMaterialApp(
        title: CustomApp.name,
        // navigatorKey: CustomApp.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Brandon",
          primarySwatch: widget.primarySwatch as MaterialColor?,
          scaffoldBackgroundColor: Color(0xFFEEEEEE),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            brightness: Brightness.dark,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          dividerTheme: const DividerThemeData(
            color: Colors.grey,
            space: 0,
          ),
        ),
        builder: (context, widget) {
          return ScrollConfiguration(
            behavior: const CustomScrollBehavior(),
            child: widget ?? const SizedBox(),
          );
        },
        supportedLocales: [
          const Locale("fr"),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: () {
          final page = () {
            bool welcomed = GenericGlobalService.welcomed;
            bool authenticated = GenericGlobalService.authenticated;
            bool accepted = GenericGlobalService.accepted;
            bool blocked = GenericGlobalService.blocked;

            if (authenticated) {
              GenericBackendService.monitorAuthenticationState();
            }

            if (blocked) {
              return CustomApp.blockingPage();
            }

            if (!welcomed) {
              return CustomApp.presentationPage();
            }

            if (authenticated) {
              if (!accepted) {
                return GenericWarningPage(
                  first: false,
                );
              }
            } else {
              if (CustomApp.authenticationRequired) {
                return GenericAuthenticationPage();
              }
            }

            if (CustomApp.calling && CustomApp.callingPage != null) {
              final callingPage = CustomApp.callingPage!();

              CustomApp.calling = false;
              CustomApp.callingPage = null;

              return callingPage;
            }

            return CustomApp.homePage();
          }();

          GenericGlobalService.state = "RESUMED";

          return page;
        }(),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        GenericGlobalService.state = "RESUMED";
        break;
      case AppLifecycleState.inactive:
        GenericGlobalService.state = "INACTIVE";
        break;
      case AppLifecycleState.paused:
        GenericGlobalService.state = "PAUSED";
        break;
      case AppLifecycleState.detached:
        GenericGlobalService.state = "DETACHED";
        break;
    }
  }

  @override
  void didChangeDependencies() {
    if (widget.didChangeDependencies != null) {
      widget.didChangeDependencies!(context);
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    if (widget.dispose != null) widget.dispose!();

    super.dispose();
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  const CustomScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
