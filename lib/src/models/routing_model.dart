class RoutingModel {
  final String id;
  final DateTime arrivalTime;
  final int duration;
  final int length;
  final String polyline;

  RoutingModel({
    required this.id,
    required this.arrivalTime,
    required this.duration,
    required this.length,
    required this.polyline,
  });

  static RoutingModel fromJson(Map<String, dynamic> json) {
    final section = Map<String, dynamic>.from(json['sections'][0]);

    return RoutingModel(
      arrivalTime: DateTime.parse(
        section['arrival']['time'],
      ),
      id: json['id'],
      polyline: section['polyline'],
      duration: section['summary']['duration'],
      length: section['summary']['length'],
    );
  }
}
