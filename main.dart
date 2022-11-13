import 'dart:isolate';

import 'package:collection/collection.dart';

import '../extensions/list.extension.dart';
import '../interfaces/operator.interface.dart';

part 'models/automoto.model.dart';
part 'models/afd_state.model.dart';
part 'models/regex_operator.model.dart';
part 'functions/treatment_infix.dart';
part 'functions/infix_to_postfix.dart';
part 'functions/evaluate_automaton.dart';
part 'functions/its_op.dart';
part 'functions/rename_states.dart';
part 'functions/merge_rules.dart';
part 'functions/merge_alphabets.dart';
part 'functions/afn_to_afd.dart';
part 'functions/clasp_isolate.dart';

const String error = 'Houve um erro, verifique a expressão e tente novamente';
const String empty = '&';

void main() {
  String infix = r'(a+b)*b';
  if (infix.isNotEmpty) {
    var treatedInfix = treatInfix(infix);

    var postFixed = infixToPostfix(treatedInfix);

    if (postFixed != null) {
      print('Pós-Fixa: $postFixed');
      final automaton = evaluateAutomaton(postFixed);
      automaton?.render();
      toAfd(automaton!);
      AFD.fromAFN(automaton);
    } else {
      print(error);
    }
  } else {
    print('Houve um problema, não consegui entender sua entrada');
  }
}
