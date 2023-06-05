import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/src/utils/latlng_extension.dart';

import '../src/models/routing_model.dart';

class RoutingAPI {
  RoutingAPI._internal();

  static RoutingAPI get instance => RoutingAPI._internal();

  final _dio = Dio();

  Future<List<RoutingModel>> calculate(
      LatLng origin, LatLng destination) async {
    try {
      final Response response = await _dio
          .get("https://router.hereapi.com/v8/routes", queryParameters: {
        'transportMode': 'car',
        'origin': origin.format(),
        'destination': destination.format(),
        'return': 'summary,polyline',
        'apiKey': 'XvrNLgnZvfG21wb7ufmzxgscYivrUvBpeXOlz2wVwig',
        'routingMode': 'fast',
        'alternatives': '1',
      });

      return (response.data['routes'] as List)
          .map((e) => RoutingModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
