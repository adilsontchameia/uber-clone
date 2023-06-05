import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/src/utils/latlng_extension.dart';

import '../src/models/places.dart';

class SearchApi {
  SearchApi._internal();
  SearchApi();
  static SearchApi get instance => SearchApi._internal();

  final Dio _dio = Dio();
  CancelToken? _cancelToken;

  Future<List<Place>> search(String query, LatLng at) async {
    _cancelToken = CancelToken();
    try {
      final response = await _dio.get(
          //https://discover.search.hereapi.com/v1/discover
          'https://autosuggest.search.hereapi.com/v1/autosuggest',
          queryParameters: {
            'at': at.format(),
            'q': query,
            "lang": "pt-PT",
            'apiKey': 'XvrNLgnZvfG21wb7ufmzxgscYivrUvBpeXOlz2wVwig',
          },
          cancelToken: _cancelToken);
      final List<Place> places = (response.data['items'] as List)
          .where((element) => element["position"] != null)
          .map((item) {
        //print('Search Place: ${Place.fromjson(item)}');
        return Place.fromjson(item);
      }).toList();
      _cancelToken = null;
      return places;
    } catch (e) {
      //print('Search Place: ${e.toString()}');
      return [];
    }
  }

  void cancel() {
    //Should be false
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel();
    }
  }
}
