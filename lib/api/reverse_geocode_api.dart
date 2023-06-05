import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/src/utils/latlng_extension.dart';

import '../src/models/places.dart';

class ReverseGeocodeAPI {
  ReverseGeocodeAPI._internal();
  static ReverseGeocodeAPI get instance => ReverseGeocodeAPI._internal();

  final _dio = Dio();

  Future<Place> reverse(LatLng at) async {
    try {
      final Response response = await _dio.get(
        'https://revgeocode.search.hereapi.com/v1/revgeocode',
        queryParameters: {
          "apiKey": "XvrNLgnZvfG21wb7ufmzxgscYivrUvBpeXOlz2wVwig",
          "lang": "pt-PT",
          "maxresult": 1,
          "at": at.format()
        },
      );

      final list = response.data['items'] as List;
      if (list.isNotEmpty) {
        final place = Place(
          id: list[0]['id'],
          title: list[0]['title'],
          position: at,
        );
        return place;
      }
      return Place();
    } catch (e) {
      debugPrint(e.toString());
      return Place();
    }
  }
}
