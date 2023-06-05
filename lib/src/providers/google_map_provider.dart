import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/src/models/places.dart';
import '../../api/reverse_geocode_api.dart';
import '../models/reverse_geocode_task.dart';
import '../pages/destination_screen.dart';
import '../utils/extras.dart';

enum MapPick { none, origin, destination }

class GoogleMapProvider with ChangeNotifier {
  GoogleMapProvider() {
    init();
  }

  void init() async {
    goToMyPosition();
  }

  bool hasValue = false;
  //Markers
  Map<MarkerId, Marker> markers = {};
  Map<String, Place> history = {};
  final Completer<Marker> _myPositionMarker = Completer();
  //Polylines
  Polyline myRoute = const Polyline(
      polylineId: PolylineId('my_route'), width: 3, color: Colors.red);
  Map<PolylineId, Polyline> polylines = {};
  //Places Model

  Position? _position;
  Place? origin, destination;
  MapPick mapPick = MapPick.none;
  ReverseGeoCodeTask reverseGeocodeTask = ReverseGeoCodeTask(
      isOrigin: false, place: Place(title: 'Current Position'));

  bool reverseLoading = false;
  final LocationSettings locationSettings =
      const LocationSettings(accuracy: LocationAccuracy.high);
  String? from;
  LatLng? fromLatLng;
  bool isFromSelected = true;
  String? to;
  LatLng? toLatLng;
  //Completers
  Completer<GoogleMapController> _completer = Completer();
  int travelDuration = 0;
  final ReverseGeocodeAPI _reverseGeocodeAPI = ReverseGeocodeAPI.instance;
  //GetCurrent Location
  LatLng myLocation = const LatLng(0.0, 0.0);
  StreamSubscription<Position>? positionStream;
  //Getter for Map controller
  Future<GoogleMapController> get _mapController async {
    return await _completer.future;
  }

  //Setting the MapController using the completer
  void setMapController(GoogleMapController controller) {
    if (_completer.isCompleted) {
      _completer = Completer();
    }
    _completer.complete(controller);
  }

  //Responsible for updating the location
  void onMyLocationUpdate({LatLng? latLng}) {
    // _loadCarPin(latLng);
    List<LatLng> points = List<LatLng>.from(myRoute.points);
    Map<PolylineId, Polyline> polylines = {};
    polylines[myRoute.polylineId] = myRoute.copyWith(pointsParam: points);

    this.polylines = polylines;
    notifyListeners();
  }

  onMapPick(MapPick mapPick) {
    this.mapPick = mapPick;
    notifyListeners();
  }

  //Method to center map
  void goToMyPosition() async {
    _goTo(myLocation);
    notifyListeners();
  }

  Future<void> setLocationDraggableInfo() async {
    double lat = myLocation.latitude;
    double lng = myLocation.longitude;
    List<Placemark> address = await placemarkFromCoordinates(lat, lng);
    if (address.isNotEmpty) {
      String? direction = address[0].thoroughfare;
      String? street = address[0].subThoroughfare;
      String? city = address[0].locality;
      String? department = address[0].administrativeArea;
      String? country = address[0].country;

      if (isFromSelected) {
        from = '$direction #$street, $city, $department';
        fromLatLng = LatLng(lat, lng);
        debugPrint('FROM: $from');
      } else {
        to = '$direction #$street, $city, $department';
        toLatLng = LatLng(lat, lng);
        debugPrint('FROM: $from');
      }

      notifyListeners();
    }
  }

  void _goTo(LatLng position) async {
    final CameraUpdate camperaUpdate = CameraUpdate.newLatLng(position);

    await (await _mapController).animateCamera(camperaUpdate);
    notifyListeners();
  }

  void reset() {
    origin = origin;
    mapPick = MapPick.none;
    myLocation = myLocation;
    markers = {};
    polylines = {};
    history = history;
    destination;
    reverseLoading = false;

    notifyListeners();
  }

  void _onOriginTap() {
    whereYouGoing(hasOriginFocus: true);
  }

  void _onDestination() {
    whereYouGoing(hasOriginFocus: false);
  }

  //Method to confirm origin and destination and stores the search history
  Future<void> confirmPoint(
    Place place,
    bool isOrigin,
  ) async {
    Place origin = isOrigin ? place : this.origin!;
    Place destination = !isOrigin ? place : this.destination!;

    final markers2 = Map<MarkerId, Marker>.from(markers);
    final historyPlace = Map<String, Place>.from(history);
    historyPlace[place.id!] = place;

    CameraUpdate cameraUpdate;

    history = historyPlace;

    Uint8List bytes = await placeToMarker(place, duration: null);

    final Marker originMarker = await createMarker(
      id: 'origin',
      position: origin.position!,
      bytes: bytes,
      onTap: _onOriginTap,
    );
    markers[originMarker.markerId] = originMarker;

    MapPick mapPick;
    // ignore: unnecessary_null_comparison
    if (origin != null && destination != null) {
      mapPick = MapPick.none;
      this.destination = destination;
      origin = origin;
      cameraUpdate =
          centerMap(origin.position!, destination.position!, padding: 100);
      final routeData = await createRoute(
          polylines: polylines,
          destination: destination.position!,
          origin: origin.position!);

      travelDuration = routeData.route.duration;
      polylines = routeData.polylines;
      bytes = await placeToMarker(
        destination,
        duration: routeData.route.duration ~/ 60,
      );
      final Marker destionationMarker = await createMarker(
        id: 'destination',
        position: destination.position!,
        bytes: bytes,
        onTap: _onDestination,
      );
      markers[destionationMarker.markerId] = destionationMarker;
    }

    notifyListeners();
  }

  //Method which guide to the searching screen
  void whereYouGoing({bool hasOriginFocus = false}) async {
    final List<Place> history = this.history.values.toList();

    final Place itemSelected = await Get.to(
        DestinationPage(
          origin: origin,
          destination: destination,
          hasOriginFocus: hasOriginFocus,
          history: history,
          onOrignChanged: (Place origin) {
            confirmPoint(origin, false);
          },
          onMapPick: (bool isOrigin) {
            onMapPick(isOrigin ? MapPick.origin : MapPick.destination);
          },
        ),
        fullscreenDialog: true);

    confirmPoint(itemSelected, false);
  }

  Future<void> reverseGeocode(LatLng at) async {
    final p = await _reverseGeocodeAPI.reverse(at);
    reverseGeocodeTask.place = p;
    reverseLoading = false;
    notifyListeners();
  }

  void onCameraMoveStated() {
    reverseLoading = true;
    notifyListeners();
    bool isOrigin = mapPick == MapPick.origin;

    ReverseGeoCodeTask task =
        ReverseGeoCodeTask(place: Place(), isOrigin: isOrigin);
    reverseGeocodeTask = task;
  }

  //Get device current location
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    _position = await Geolocator.getLastKnownPosition();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  //Get device current location
  void getCurrentLocation() {
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position position) async {
      final newPosition = LatLng(position.latitude, position.longitude);

      myLocation = newPosition;

      final CameraUpdate camperaUpdate = CameraUpdate.newLatLng(newPosition);
      onMyLocationUpdate(latLng: myLocation);
      await (await _mapController).animateCamera(camperaUpdate);
      hasValue = true;
      notifyListeners();
    }, onDone: () {});
  }
}
