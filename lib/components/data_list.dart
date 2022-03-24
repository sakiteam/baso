part of "package:baso/baso.dart";

class DataList extends StatefulWidget {
  final String dataKey;
  final Widget Function(Map<String, dynamic>) delegate;
  final Function? section;
  final IconData? icon;
  final String? emptyTitle;
  final String? emptyDescription;
  final bool reverse;
  final Function? sectionDelegate;
  final Map<String, dynamic>? dataValue;
  final int dataLimit;
  final bool nested;
  final String emptyImage;
  final Widget? topWidget;
  final Function? topWidgetDelegate;
  final Widget? bottomWidget;
  final ScrollController? scrollController;
  final List<dynamic>? deletedItems;
  final Function? onLengthChanged;
  final Function? container;
  final bool limitless;
  final String searchQuery;
  final Function? onLoaded;
  final Axis? scrollDirection;
  final EdgeInsets? padding;
  final bool showLoading;
  final Function? alter;
  final ScrollPhysics? physics;
  final bool realtime;
  final bool cache;
  final bool permanent;
  final bool deletion;
  final bool refresh;
  final Function? onRefreshed;
  final Function? exclusion;

  final Future Function()? reload;
  final bool Function()? loadingCompletion;
  final String? currentKey;
  final List<Map<String, dynamic>>? dataList;

  final EdgeInsets? sectionPadding;
  final Widget? emptyPosterContent;

  const DataList({
    this.topWidget,
    this.nested = false,
    this.dataKey = "",
    this.dataValue,
    this.dataLimit = GenericBackendService.snapshotLength,
    required this.delegate,
    this.icon,
    this.emptyTitle,
    this.emptyDescription,
    this.section,
    this.reverse = false,
    this.sectionDelegate,
    this.emptyImage = '',
    this.bottomWidget,
    this.scrollController,
    this.deletedItems,
    this.onLengthChanged,
    this.container,
    this.limitless = true,
    this.searchQuery = "",
    this.onLoaded,
    this.scrollDirection,
    this.padding,
    this.topWidgetDelegate,
    this.showLoading = false,
    this.alter,
    this.physics,
    this.realtime = true,
    this.cache = false,
    this.permanent = false,
    this.deletion = false,
    this.refresh = false,
    this.onRefreshed,
    //
    this.reload,
    this.loadingCompletion,
    this.currentKey,
    this.dataList,
    this.exclusion,
    //
    this.sectionPadding,
    this.emptyPosterContent,
  });

  @override
  _DataListState createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  Function? _container;

  bool _loading = true;
  bool _error = false;

  String? _trueKey;
  List<Map<String, dynamic>> _list = [];
  StreamSubscription<List<Map<String, dynamic>>?>? _streamSubscription;
  late ScrollController _scrollController;
  List<String> _keys = [];
  String _suffix = const Uuid().v4();

  String? _currentKey;

  _reload() async {
    if (widget.reload != null) {
      try {
        await widget.reload!();
        setState(() {});
      } catch (e) {
        print(e);
        _error = true;
      }
    } else {
      GenericBackendService.readCollectionSnapshots(
        widget.dataKey,
        limit: widget.dataLimit,
        value: widget.dataValue,
        cache: widget.cache,
        realtime: widget.realtime,
        suffix: !widget.deletion ? "" : _suffix,
      );
    }
  }

  bool _loadingCompletion() {
    if (widget.loadingCompletion != null) {
      return widget.loadingCompletion!();
    }

    return GenericBackendService.getLoadingCompleted(_trueKey ?? "");
  }

  _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 0.5 &&
        !_scrollController.position.outOfRange) {
      if (widget.limitless && !_loadingCompletion()) {
        _reload();
      }
    }
  }

  @override
  void initState() {
    _scrollController = widget.scrollController ?? ScrollController();

    _scrollController.addListener(_onScroll);

    super.initState();
  }

  _initCustomReload() async {
    try {
      await widget.reload!();

      setState(() {
        _loading = false;
      });
    } catch (e) {
      print(e);

      _error = true;
    }
  }

  void init() {
    if (widget.reload != null) {
      _list = widget.dataList ?? [];

      if (_currentKey == widget.currentKey) return;

      _loading = true;
      _currentKey = widget.currentKey;

      _initCustomReload();

      return;
    }

    final String trueKey = widget.dataKey +
        (widget.dataValue != null ? widget.dataValue.toString() : "") +
        (widget.realtime ? "Realtime" : "") +
        (!widget.deletion ? "" : _suffix);

    if (trueKey == _trueKey) return;

    _loading = true;

    try {
      _keys.add(trueKey);
      _trueKey = trueKey;

      if (_streamSubscription != null) {
        _streamSubscription?.cancel();
      }

      if (!widget.realtime && !widget.permanent) {
        GenericBackendService.deleteKey(trueKey);
      }

      _streamSubscription = GenericBackendService.readCollectionSnapshots(
        widget.dataKey,
        limit: widget.dataLimit,
        value: widget.dataValue,
        cache: widget.cache,
        realtime: widget.realtime,
        suffix: !widget.deletion ? "" : _suffix,
      ).listen((list) {
        final tmp = GenericBackendService.getDocs(trueKey);

        if (widget.alter != null) {
          _list = widget.alter!(tmp);
        } else {
          _list = tmp;
        }

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
      print(e);

      setState(() {
        _error = true;
      });
    }
  }

  Widget _getLoadingWidget() {
    return LoadingPoster(
      nested: widget.nested,
    );
  }

  Widget _getErrorWidget() {
    return ErrorPoster(
      nested: widget.nested,
    );
  }

  Widget _getDataWidget() {
    List<Map<String, dynamic>> dataList = [];

    Function _section = widget.section ??
        (document) {
          return "";
        };

    Function _exclusion = widget.exclusion ??
        (document) {
          return false;
        };

    if (_list.isNotEmpty) {
      dataList = _list.where((element) {
        return !(widget.deletedItems ?? []).contains(element) &&
            !_exclusion(element);
      }).toList();
    }

    if (widget.onLengthChanged != null)
      widget.onLengthChanged!(dataList.length);

    final emptyPoster = EmptyPoster(
      nested: widget.nested,
      title: widget.emptyTitle,
      search: widget.searchQuery.isNotEmpty,
      description: widget.emptyDescription,
      content: widget.emptyPosterContent,
    );

    // Concrete list
    return dataList.isEmpty
        ? emptyPoster
        : () {
            bool searchFound = false;

            final top = <Widget>[
              widget.topWidgetDelegate == null
                  ? widget.topWidget ?? const SizedBox()
                  : widget.topWidgetDelegate!(dataList),
            ];

            final middle = dataList.map<Widget>(
              (document) {
                final int index = dataList.indexOf(document);
                final section = _section(document);

                bool found = true;

                String query = removeDiacritics(
                  widget.searchQuery.trim(),
                ).toLowerCase();

                if (query.isNotEmpty) {
                  String stringifiedDocument = "";

                  document.values.forEach((element) {
                    stringifiedDocument += removeDiacritics(
                      element.toString().toLowerCase(),
                    );
                  });

                  stringifiedDocument = stringifiedDocument.trim();

                  final terms = query.split(" ");

                  for (int i = 0; i < terms.length; i++) {
                    final term = terms[i];

                    if (!stringifiedDocument.contains(term)) {
                      found = false;
                      break;
                    }
                  }
                }

                searchFound = searchFound || found;

                return ListItemWrapper(
                  init: () {
                    if ((index + 1) % GenericBackendService.snapshotLength ==
                            0 &&
                        widget.limitless) {
                      _reload();
                    }
                  },
                  child: Visibility(
                    visible: found,
                    maintainState: true,
                    child: Column(
                      crossAxisAlignment:
                          (widget.scrollDirection ?? Axis.vertical) ==
                                  Axis.horizontal
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.stretch,
                      children: [
                        section != null &&
                                section != "" &&
                                ((widget.reverse == false &&
                                        (index == 0 ||
                                            _section(dataList[index - 1]) !=
                                                section)) ||
                                    (widget.reverse == true &&
                                        ((index == dataList.length - 1) ||
                                            _section(dataList[index + 1]) !=
                                                section)))
                            ? (widget.sectionDelegate != null
                                ? widget.sectionDelegate!(section)
                                : Section(
                                    title: section,
                                    padding: widget.sectionPadding,
                                  ))
                            : const SizedBox(),
                        widget.delegate(document),
                      ],
                    ),
                  ),
                );
              },
            ).toList();

            final bottom = <Widget>[
              widget.bottomWidget ?? const SizedBox(),
            ];

            if (searchFound) {
              if (widget.container == null) {
                return _container!(top + middle + bottom);
              }

              return _container!(middle);
            }

            return emptyPoster;

            // return IndexedStack(
            //   children: [
            //     _container(top + middle + bottom),
            //     _container(middle),
            //     emptyPoster,
            //   ],
            //   index: () {
            //     if (searchFound) {
            //       if (widget.container == null) return 0;
            //       return 1;
            //     }

            //     return 2;
            //   }(),
            // );
          }();
  }

  @override
  Widget build(final BuildContext context) {
    // if (widget.container != null) {
    //   _container = widget.container;
    // }

    if (widget.container == null) {
      _container = (List<Widget> children) {
        // return ListView(
        //   controller: widget.scrollController,
        //   physics: widget.nested ? const ClampingScrollPhysics() : null,
        //   shrinkWrap: widget.nested,
        //   reverse: widget.reverse,
        //   // itemCount: children.length,
        //   addAutomaticKeepAlives: true,
        //   children: children,
        // );

        // return SingleChildScrollView(
        //   child: SafeArea(
        //     child: Column(
        //       children: children,
        //     ),
        //   ),
        //   controller: _scrollController,
        // );

        final list = ListView.builder(
          padding: widget.padding,
          controller: _scrollController,
          scrollDirection: widget.scrollDirection ?? Axis.vertical,
          physics:
              widget.nested ? const ClampingScrollPhysics() : widget.physics,
          shrinkWrap: widget.nested,
          reverse: widget.reverse,
          itemCount: children.length + (widget.showLoading ? 1 : 0),
          itemBuilder: (context, index) {
            final item = index >= children.length
                ? (_loadingCompletion() != true
                    ? ListItemWrapper(
                        init: () {
                          _reload();
                        },
                        child: Center(
                          child: widget.searchQuery.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                )
                              : null,
                        ),
                      )
                    : const SizedBox())
                : children[index];

            return CustomSlide(child: item);
          },
        );

        return widget.refresh
            ? RefreshIndicator(
                child: list,
                onRefresh: () async {
                  deleteKeys();

                  _suffix = const Uuid().v4();
                  _trueKey = "";

                  setState(() {});

                  if (widget.onRefreshed != null) {
                    widget.onRefreshed!();
                  }
                },
              )
            : list;
      };
    } else {
      _container = widget.container;
    }

    init();

    if (_error) return _getErrorWidget();
    if (_loading) return _getLoadingWidget();

    return _getDataWidget();
  }

  void deleteKeys() {
    _keys.forEach((key) {
      GenericBackendService.deleteKey(key);
    });

    _keys.clear();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();

    if (widget.scrollController == null) {
      _scrollController.dispose();
    }

    if (widget.deletion) {
      deleteKeys();
    }

    super.dispose();
  }
}
