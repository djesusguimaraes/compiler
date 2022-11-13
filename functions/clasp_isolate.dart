part of '../main.dart';

Future<void> claspWithIsolate(AFN automaton) async {
  for (var state in automaton.states) {
    final port = ReceivePort();
    var args = [port.sendPort, state, <int>[], automaton];
    await Isolate.spawn<List<dynamic>>(claspIsolate, args);
    final response = await port.first as List<int>;
    print(response);
  }
}

void claspIsolate(List<dynamic> args) {
  SendPort sendPort = args[0];
  int state = args[1];
  List<int> visited = args[2];
  AFN automaton = args[3];

  if (visited.contains(state)) return;
  visited.add(state);

  var rule = automaton.rules?.firstWhereOrNull(
    (rule) => rule.start == state && rule.simbol == empty,
  );

  for (var end in rule?.ends ?? {}) {
    claspIsolate([sendPort, end, visited, automaton]);
  }
  Isolate.exit(sendPort, visited);
}
