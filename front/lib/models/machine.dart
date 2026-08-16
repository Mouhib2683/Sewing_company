class Machine {
  final String id;
  final String code; // e.g. "15" -> displayed as "Machine #15"
  final String name;
  final String location;

  const Machine({
    required this.id,
    required this.code,
    required this.name,
    required this.location,
  });

  String get displayName => 'Machine #$code';
}
