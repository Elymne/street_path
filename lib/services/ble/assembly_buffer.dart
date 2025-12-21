class AssemblyBuffer {
  final int total;
  final Map<int, List<int>> chunks = {};
  final DateTime created = DateTime.now();

  AssemblyBuffer(this.total);

  void add(int index, List<int> data) {
    chunks.putIfAbsent(index, () => data);
  }

  bool get isComplete => chunks.length == total;

  bool get isExpired => DateTime.now().difference(created).inSeconds > 5;

  List<int> assemble() {
    final result = <int>[];
    for (int i = 0; i < total; i++) {
      result.addAll(chunks[i]!);
    }
    return result;
  }
}
