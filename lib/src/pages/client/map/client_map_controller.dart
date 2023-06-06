import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:uber_clone/src/utils/snackbar.dart' as utils;

import '../../../models/client.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/client_provider.dart';
import '../../../providers/driver_provider.dart';
import '../../../providers/geofire_provider.dart';
import '../../../utils/my_progress_dialog.dart';

class ClientMapController {
  BuildContext? context;
  Function? refresh;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _completer = Completer();
  CameraPosition initialPosition =
      const CameraPosition(target: LatLng(-14.6594083, 17.698479), zoom: 14.0);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Position? _position;
  StreamSubscription<Position>? _positionStream;

  BitmapDescriptor? markerDriver;

  GeofireProvider? _geofireProvider;
  AuthProvider? _authProvider;
  DriverProvider? _driverProvider;
  ClientProvider? _clientProvider;

  bool isConnect = false;
  ProgressDialog? _progressDialog;

  StreamSubscription<DocumentSnapshot>? _statusSuscription;
  StreamSubscription<DocumentSnapshot>? _clientInfoSubscription;

  Client? client;

  String? from;
  LatLng? fromLatLng;

  String? to;
  LatLng? toLatLng;

  bool isFromSelected = true;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _geofireProvider = GeofireProvider();
    _authProvider = AuthProvider();
    _driverProvider = DriverProvider();
    _clientProvider = ClientProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Conectandose...');
    markerDriver = await createMarkerImageFromAsset('assets/img/taxi_icon.png');
    checkGPS();
    getClientInfo();
  }

  void getClientInfo() {
    Stream<DocumentSnapshot> clientStream =
        _clientProvider!.getByIdStream(_authProvider!.getUser().uid);
    _clientInfoSubscription = clientStream.listen((DocumentSnapshot document) {
      client = Client.fromJson(document.data() as Map<String, dynamic>);
      refresh!();
    });
  }

  void openDrawer() {
    key.currentState!.openDrawer();
  }

  void dispose() {
    _positionStream!.cancel();
    _statusSuscription!.cancel();
    _clientInfoSubscription!.cancel();
  }

  void signOut() async {
    await _authProvider!.signOut();
    Navigator.pushNamedAndRemoveUntil(context!, 'home', (route) => false);
  }

  //Setting the MapController using the completer
  void setMapController(GoogleMapController controller) {
    if (_completer.isCompleted) {
      _completer = Completer();
    }
    _completer.complete(controller);
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      centerPosition();
      getNearbyDrivers();
    } catch (error) {
      print('Error en la localizacion: $error');
    }
  }

  void changeFromTO() {
    isFromSelected = !isFromSelected;

    if (isFromSelected) {
      utils.Snackbar.showSnackbar(
          context!, key, 'Estas seleccionando el lugar de recogida');
    } else {
      utils.Snackbar.showSnackbar(
          context!, key, 'Estas seleccionando el destino');
    }
  }

  Future<void> setLocationDraggableInfo() async {
    double lat = initialPosition.target.latitude;
    double lng = initialPosition.target.longitude;

    List<Placemark> address = await placemarkFromCoordinates(lat, lng);

    if (address.isNotEmpty) {
      String direction = address[0].thoroughfare!;
      String street = address[0].subThoroughfare!;
      String city = address[0].locality!;
      String department = address[0].administrativeArea!;
      String country = address[0].country!;

      if (isFromSelected) {
        from = '$direction #$street, $city, $department';
        fromLatLng = LatLng(lat, lng);
      } else {
        to = '$direction #$street, $city, $department';
        toLatLng = LatLng(lat, lng);
      }

      refresh!();
    }
  }

  void getNearbyDrivers() {
    Stream<List<DocumentSnapshot>> stream = _geofireProvider!
        .getNearbyDrivers(_position!.latitude, _position!.longitude, 10);

    stream.listen((event) {
      MarkerId? delete;
      for (MarkerId markerId in markers.keys) {
        bool remover = true;
        for (DocumentSnapshot d in event) {
          if (markerId.value == d.id) {
            remover = false;
          }
        }
        delete = remover ? markerId : null;
      }

      if (delete != null) {
        markers.remove(delete);
        refresh!();
      }

      for (DocumentSnapshot d in event) {
        final dFormat = d.data() as Map<String, dynamic>;
        GeoPoint point = dFormat['position']['geopoint'];

        addMarker(
          d.id,
          point.latitude,
          point.longitude,
          'Available',
          'Your Content',
          markerDriver!,
        );
      }
      refresh!();
    });
  }

  void centerPosition() {
    if (_position != null) {
      animateCameraToPosition(_position!.latitude, _position!.longitude);
    } else {
      utils.Snackbar.showSnackbar(
          context!, key, 'Activa el GPS para obtener la posicion');
    }
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      print('GPS ACTIVADO');
      updateLocation();
    } else {
      print('GPS DESACTIVADO');
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
        print('ACTIVO EL GPS');
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

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

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _completer.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0, target: LatLng(latitude, longitude), zoom: 13)));
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = const ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        rotation: _position!.heading);

    markers[id] = marker;
  }
}
