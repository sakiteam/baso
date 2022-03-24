part of "package:baso/baso.dart";

class DataItem extends StatefulWidget {
  final Widget Function(Map<String, dynamic>) delegate;
  final String collection;
  final String id;

  final Widget? errorWidget;
  final Widget? loadingWidget;
  final bool loadingCondition;

  final void Function(Map<String, dynamic>)? onLoaded;
  final bool realtime;
  final bool cache;
  final bool permanent;
  final bool deletion;

  const DataItem({
    Key? key,
    required this.id,
    required this.delegate,
    required this.collection,
    this.errorWidget,
    this.loadingWidget,
    this.onLoaded,
    this.loadingCondition = false,
    this.realtime = true,
    this.cache = false,
    this.permanent = false,
    this.deletion = false,
  }) : super(key: key);

  @override
  _DataItemState createState() => _DataItemState();
}

class _DataItemState extends State<DataItem> {
  String? _trueKey;
  bool _error = false;
  bool _loading = true;
  List<Map<String, dynamic>> _list = [];
  StreamSubscription<List<Map<String, dynamic>>?>? _streamSubscription;
  List<String> _keys = [];

  final String _suffix = Uuid().v4();

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
    }

    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    init();

    return _error
        ? (widget.errorWidget ?? SizedBox())
        : ((_loading || widget.loadingCondition)
            ? (widget.loadingWidget ?? SizedBox())
            : widget.delegate(_list.first));
  }

  init() {
    final String trueKey = widget.collection +
        widget.id +
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

      _streamSubscription = GenericBackendService.readDocumentSnapshots(
        widget.collection,
        widget.id,
        widget.realtime,
        widget.cache,
        (!widget.deletion ? "" : _suffix),
      ).listen((list) {
        _list = GenericBackendService.getDocs(trueKey);

        if (GenericBackendService.getDocsExistence(trueKey)) {
          _loading = false;

          if (widget.onLoaded != null) widget.onLoaded!(_list.first);
        }

        if (mounted) {
          setState(() {});
        }
      });

      GenericBackendService.getStreamController(trueKey).add(null);
    } catch (e) {
      print(e);

      setState(() {
        _error = true;
      });
    }
  }
}
