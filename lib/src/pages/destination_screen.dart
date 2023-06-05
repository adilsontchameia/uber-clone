import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../api/search_api.dart';
import '../models/places.dart';
import '../utils/debounce.dart';
import '../utils/input_widget.dart';
import 'client/map/client_map_controller.dart';

class DestinationPage extends StatefulWidget {
  final Place? origin, destination;
  final List<Place>? history;
  final void Function(Place origin)? onOrignChanged;
  final bool hasOriginFocus;
  final void Function(bool isOrigin)? onMapPick;

  const DestinationPage({
    Key? key,
    this.origin,
    this.destination,
    this.history,
    this.onOrignChanged,
    this.hasOriginFocus = false,
    this.onMapPick,
  }) : super(key: key);

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  final FocusNode _originFocus = FocusNode();
  final FocusNode _destinationFocus = FocusNode();
  //
  bool _searching = false;
  bool _originHasFocus = false;

  //
  TextEditingController? _originController, _destinationController;

  final ClientMapController _con = ClientMapController();
  //
  final SearchApi _searchApi = SearchApi.instance;
  final Debounce _debounce = Debounce(const Duration(milliseconds: 300));
  //
  StreamSubscription? _subscription;
  //
  List<Place> _results = [];
  final ValueNotifier<String> _query = ValueNotifier('');
  @override
  void initState() {
    _originHasFocus = widget.hasOriginFocus;

    _originController = TextEditingController(text: _con.from);
    if (widget.destination != null) {
      _destinationController = TextEditingController(text: _con.to);
    } else {
      _destinationController = TextEditingController();
    }

    _originFocus.addListener(() {
      setState(() {
        _originHasFocus = true;
      });
    });

    _destinationFocus.addListener(() {
      setState(() {
        _originHasFocus = false;
      });
    });
    if (_originHasFocus) {
      _originFocus.requestFocus();
    } else {
      _destinationFocus.requestFocus();
    }

    super.initState();
  }

  @override
  void dispose() {
    _originController?.dispose();
    _destinationController?.dispose();
    _originFocus.dispose();
    _destinationFocus.dispose();
    _searchApi.cancel();
    _debounce.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  _onInputChanged(String query) {
    _query.value = query;
    if (_subscription != null) {
      _subscription!.cancel();
    }
    _debounce.cancel();

    if (query.trim().length >= 3) {
      setState(() {
        _searching = true;
      });
      //Consumir API
      _debounce.create(() => _search(query));
    } else {
      if (_searching || _results.isNotEmpty) {
        setState(() {
          _searching = false;
          _results = [];
        });
      }
      _searchApi.cancel();
    }
  }

  void _search(String query) {
    _subscription = _searchApi
        .search(query, widget.origin!.position!)
        .asStream()
        .listen((List<Place> results) {
      setState(() {
        _searching = false;
        _results = results;
      });
    });
  }

  Widget _buildList(bool isHistory) {
    List<Place> items = isHistory ? widget.history! : _results;
    if (isHistory) {
      items = items.where((e) {
        if (e.title!.toLowerCase().contains(_query.value)) {
          return true;
        }
        if (e.label!.toLowerCase().contains(_query.value)) {
          return true;
        }
        return false;
      }).toList();
    }
    return ListView.builder(
      itemBuilder: (_, index) {
        final Place item = items[index];
        return ListTile(
            leading: isHistory ? const Icon(Icons.history) : null,
            onTap: () {
              if (_originHasFocus) {
                _originController!.text = item.title!;
                widget.onOrignChanged!(item);
                _destinationFocus.requestFocus();
              } else {
                Navigator.pop(context, item);
              }
            },
            title: Text(item.title!,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item.label!));
      },
      itemCount: items.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Let\'s Ride 🚗',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () => Navigator.pop(context)),
          systemOverlayStyle: SystemUiOverlayStyle.dark),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Input(
                        onChanged: _onInputChanged,
                        icon: Icons.gps_fixed,
                        hintText: 'Choose Your Place',
                        focusNode: _originFocus,
                        controller: _originController,
                        hasFocus: _originHasFocus,
                        onClear: () {
                          _query.value = '';
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Input(
                        onChanged: _onInputChanged,
                        icon: Icons.pin_drop,
                        hintText: 'Choose Your Destination',
                        hasFocus: !_originHasFocus,
                        controller: _destinationController,
                        focusNode: _destinationFocus,
                        onClear: () {
                          _query.value = '';
                        },
                      ),
                      Row(
                        children: [
                          Icon(
                              _originHasFocus
                                  ? Icons.gps_fixed
                                  : Icons.pin_drop,
                              color: Colors.blue),
                          CupertinoButton(
                            child: Text(
                              'Pick ${_originHasFocus ? 'Origin' : 'Destination'} on Map',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              widget.onMapPick!(_originHasFocus);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
              if (_searching)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              /*
              else
                Expanded(
                  child: ValueListenableBuilder<String>(
                    valueListenable: _query,
                    builder: (_, query, __) =>
                        _buildList(query.trim().length >= 3 ? false : true),
                  ),
                ),
                */
            ],
          ),
        ),
      ),
    );
  }
}
