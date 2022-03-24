part of "package:baso/baso.dart";

class DataCounter extends StatefulWidget {
  final String? dataKey;
  final Map<String, dynamic>? dataValue;
  final Function delegate;
  final Function? onLoaded;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final int dataLimit;
  final bool realtime;
  final bool cache;
  final bool permanent;
  final bool deletion;
  final DataCounterController? controller;

  DataCounter({
    this.dataKey,
    this.dataValue,
    required this.delegate,
    this.onLoaded,
    this.errorWidget,
    this.loadingWidget,
    this.dataLimit = 0,
    this.realtime = true,
    this.cache = false,
    this.permanent = false,
    this.deletion = false,
    this.controller,
  });

  @override
  _DataCounterState createState() => _DataCounterState();
}

class _DataCounterState extends State<DataCounter> {
  String? _trueKey;
  bool _error = false;
  bool _loading = true;
  List<Map<String, dynamic>> _list = [];
  StreamSubscription<List<Map<String, dynamic>>?>? _streamSubscription;
  List<String> _keys = [];

  String _suffix = Uuid().v4();
  DataCounterController? _controller;

  @override
  Widget build(BuildContext context) {
    _controller = widget.controller;

    if (_controller != null) {
      _controller!.refresh = refresh;
    }

    init();

    return _error
        ? (widget.errorWidget ?? SizedBox())
        : (_loading
            ? (widget.loadingWidget ?? SizedBox())
            : widget.delegate(_list));
  }

  init() {
    final String trueKey = widget.dataKey! +
        (widget.dataValue != null ? widget.dataValue.toString() : "") +
        (widget.realtime ? "Realtime" : "") +
        (!widget.deletion ? "" : _suffix);

    if (trueKey == _trueKey) return;

    try {
      _keys.add(trueKey);
      _trueKey = trueKey;

      _loading = true;

      if (_streamSubscription != null) {
        _streamSubscription?.cancel();
      }

      if (!widget.realtime && !widget.permanent) {
        GenericBackendService.deleteKey(trueKey);
      }

      _streamSubscription = GenericBackendService.readCollectionSnapshots(
        widget.dataKey!,
        limit: widget.dataLimit,
        value: widget.dataValue,
        cache: widget.cache,
        realtime: widget.realtime,
        suffix: (!widget.deletion ? "" : _suffix),
      ).listen((list) {
        _list = GenericBackendService.getDocs(trueKey);

        if (GenericBackendService.getDocsExistence(trueKey)) {
          _loading = false;

          if (widget.onLoaded != null) widget.onLoaded!();
        }

        if (mounted) {
          setState(() {});
        }
      });

      GenericBackendService.getStreamController(trueKey).add(null);
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void refresh() {
    deleteKeys();

    _suffix = const Uuid().v4();
    _trueKey = "";

    setState(() {});
  }

  void deleteKeys() {
    _keys.forEach((key) {
      GenericBackendService.deleteKey(key);
    });

    _keys.clear();
  }

  @override
  void dispose() {
    if (_streamSubscription != null) {
      _streamSubscription?.cancel();
      _streamSubscription = null;
    }

    if (widget.deletion) {
      _keys.forEach((key) {
        GenericBackendService.deleteKey(key);
      });

      _keys.clear();
    }

    super.dispose();
  }
}

class DataCounterController {
  late void Function() refresh;
}
