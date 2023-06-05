import 'dart:ui' as ui;
import 'dart:math' as math;
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../api/routing_api.dart';
import '../models/places.dart';
import '../models/routing_model.dart';
import 'my_custom_marker.dart';

Future<Uint8List> loadAsset(String path,
    {int width = 50, int height = 50}) async {
  ByteData data = await rootBundle.load(path);
  final Uint8List bytes = data.buffer.asUint8List();
  final ui.Codec codec = await ui.instantiateImageCodec(bytes,
      targetWidth: width, targetHeight: height);

  final ui.FrameInfo frame = await codec.getNextFrame();

  data = (await frame.image.toByteData(format: ui.ImageByteFormat.png))!;
  return data.buffer.asUint8List();
}

//GetNetwork Image
Future<Uint8List> loadImageFromNetwork(String url,
    {int width = 50, int height = 50}) async {
  final http.Response response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Uint8List bytes = response.bodyBytes;
    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: width,
      targetHeight: height,
    );
    final ui.FrameInfo frame = await codec.getNextFrame();
    final data =
        (await frame.image.toByteData(format: ui.ImageByteFormat.png))!;

    return data.buffer.asUint8List();
  }
  throw Exception('Downloaded Failed');
}

double getCoordRotation(LatLng currentPosition, LatLng lastPosition) {
  final dx = math.cos(math.pi / 180 * lastPosition.latitude) *
      (currentPosition.longitude - lastPosition.longitude);

  final dy = currentPosition.latitude - lastPosition.latitude;

  final angle = math.atan2(dy, dx);

  return 90 - angle * 180 / math.pi;
}

Future<Uint8List> placeToMarker(Place place, {int? duration}) async {
  ui.PictureRecorder recorder = ui.PictureRecorder();
  ui.Canvas canvas = ui.Canvas(recorder);
  const ui.Size size = ui.Size(350, 110);
  MyCustomMarker customMarker = MyCustomMarker(place, duration);
  customMarker.paint(canvas, size);
  ui.Picture picture = recorder.endRecording();
  final ui.Image image = await picture.toImage(
    size.width.toInt(),
    size.height.toInt(),
  );

  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

createMarker({
  required String id,
  required LatLng position,
  required Uint8List bytes,
  VoidCallback? onTap,
}) {
  final markerId = MarkerId(id);

  final marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(bytes),
      position: position,
      onTap: () {});

  return marker;
}

/*
Future<Uint8List> currentLocationMarker() async {
  ui.PictureRecorder recorder = ui.PictureRecorder();
  ui.Canvas canvas = ui.Canvas(recorder);
  const ui.Size size = ui.Size(300, 100);
  MyCustomMarker customMarker = MyCustomMarker();
  customMarker.paint(canvas, size);

  final ui.Image image = await recorder.endRecording().toImage(
        size.width.toInt(),
        size.height.toInt(),
      );

  final ByteData? byteData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  return byteData!.buffer.asUint8List();
}
*/

///
dynamic getZoom(LatLng origin, LatLng destination) {
  final linearDistance = getDistanceInKM(origin, destination);

  double radius = linearDistance / 2;
  double scale = radius / 0.3;
  final zoom = (16 - math.log(scale) / math.log(2));

  return zoom;
}

CameraUpdate centerMap(LatLng origin, LatLng destination,
    {double padding = 30.0}) {
  //1 - Calcular a cordenada que se encontra mais a sul e oeste
  final double left = math.min(origin.latitude, destination.latitude);
  final double right = math.max(origin.latitude, destination.latitude);
  final double top = math.min(origin.longitude, destination.longitude);
  final double bottom = math.max(origin.longitude, destination.longitude);
  //
  final LatLng southwest = LatLng(left, bottom);
  final LatLng northeast = LatLng(right, top);
  //
  final LatLngBounds bounds = LatLngBounds(
    southwest: southwest,
    northeast: northeast,
  );
  if (Platform.isIOS) {
    final CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(
      bounds,
      padding,
    );
    return cameraUpdate;
  }
  final LatLng center = LatLng(
    (southwest.latitude + northeast.latitude) / 2,
    (southwest.longitude + northeast.longitude) / 2,
  );
  final zoom = getZoom(origin, destination);
  return CameraUpdate.newLatLngZoom(center, zoom);
  //
}

/// parse degrees to radians
double deg2rad(deg) {
  return deg * (math.pi / 180);
}

/// calculates the distance between two coords in km
double getDistanceInKM(LatLng position1, LatLng position2) {
  final lat1 = position1.latitude;
  final lon1 = position1.longitude;
  final lat2 = position2.latitude;
  final lon2 = position2.longitude;

  const R = 6371; // Radius of the earth in km
  final dLat = deg2rad(lat2 - lat1); // deg2rad below
  final dLon = deg2rad(lon2 - lon1);
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(deg2rad(lat1)) *
          math.cos(deg2rad(lat2)) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  final d = R * c; // Distance in km

  return d;
}

//
Future<RouteData> createRoute({
  required Map<PolylineId, Polyline> polylines,
  required LatLng origin,
  required LatLng destination,
}) async {
  final newPolylines = Map<PolylineId, Polyline>.from(polylines);
  final routes = await RoutingAPI.instance.calculate(origin, destination);
  String googleAPiKey = "AIzaSyDW23YjhjYnczAewkHEPZzLSQ3jz0H4yJU";

  List<LatLng> points = [];
  // ignore: unnecessary_null_comparison
  if (routes != null && routes.isNotEmpty) {
    const PolylineId polylineId = PolylineId('route');
    final RoutingModel route = routes[0];
    //List<LatLngZ>
    PointLatLng pointFromLatLng =
        PointLatLng(origin.latitude, origin.longitude);
    PointLatLng pointToLatLng =
        PointLatLng(destination.latitude, destination.longitude);
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey, pointFromLatLng, pointToLatLng);
    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }
    //
    final Polyline polyline = Polyline(
        polylineId: polylineId, width: 4, color: Colors.black, points: points);
    newPolylines[polylineId] = polyline;
    return RouteData(route, newPolylines);
  }
  return createRoute(
      polylines: polylines, origin: origin, destination: destination);
}

class RouteData {
  final RoutingModel route;
  final Map<PolylineId, Polyline> polylines;

  RouteData(this.route, this.polylines);
}
