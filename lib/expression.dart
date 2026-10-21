/// Calculator expression handling for the converter keypad.
///
/// Expressions use the display operators `+ − × ÷` and postfix `%`.
/// `×`/`÷` bind tighter than `+`/`−`. A percentage that ends a `+`/`−` term
/// is taken of the running total, so `200+10%` is 220 like a desk calculator;
/// anywhere else `n%` is simply n/100.
library;

const operators = {'+', '−', '×', '÷'};

/// Evaluates [input], ignoring a trailing operator so partial input still
/// yields a value. Returns null for empty or malformed input, or a result
/// that isn't finite (e.g. division by zero).
double? evaluate(String input) {
  var s = input;
  while (s.isNotEmpty && operators.contains(s[s.length - 1])) {
    s = s.substring(0, s.length - 1);
  }
  final tokens = _tokenize(s);
  if (tokens == null || tokens.isEmpty) return null;
  try {
    final parser = _Parser(tokens);
    final value = parser.sum();
    if (parser.i != tokens.length || !value.isFinite) return null;
    return value;
  } on _ParseError {
    return null;
  }
}

/// True when [input] contains an operation, i.e. it's more than one number.
bool hasOperation(String input) {
  for (var i = 1; i < input.length; i++) {
    if (operators.contains(input[i]) || input[i] == '%') return true;
  }
  return input.endsWith('%');
}

List<Object>? _tokenize(String s) {
  final tokens = <Object>[];
  final number = StringBuffer();

  bool flush() {
    if (number.isEmpty) return true;
    var text = number.toString();
    number.clear();
    if (text.startsWith('-.')) text = '-0${text.substring(1)}';
    if (text.startsWith('.')) text = '0$text';
    if (text.endsWith('.')) text = '${text}0';
    final value = double.tryParse(text);
    if (value == null) return false;
    tokens.add(value);
    return true;
  }

  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    final isDigit = c.codeUnitAt(0) >= 0x30 && c.codeUnitAt(0) <= 0x39;
    if (isDigit || c == '.') {
      number.write(c);
    } else if (c == '−' && number.isEmpty && (tokens.isEmpty || (tokens.last is String && tokens.last != '%'))) {
      // Unary minus at the start or right after an operator.
      number.write('-');
    } else if (operators.contains(c) || c == '%') {
      if (!flush()) return null;
      tokens.add(c);
    } else if (c == ' ' || c == ',') {
      // Grouping separators from pasted text.
    } else {
      return null;
    }
  }
  if (!flush()) return null;
  return tokens;
}

class _ParseError implements Exception {}

class _Parser {
  _Parser(this.t);

  final List<Object> t;
  int i = 0;

  double sum() {
    var acc = term(null);
    while (i < t.length && (t[i] == '+' || t[i] == '−')) {
      final op = t[i++];
      final v = term(acc);
      acc = op == '+' ? acc + v : acc - v;
    }
    return acc;
  }

  /// [base] is the running sum, used for `a + b%` style percentages.
  double term(double? base) {
    var acc = factor(base);
    while (i < t.length && (t[i] == '×' || t[i] == '÷')) {
      final op = t[i++];
      final v = factor(null);
      acc = op == '×' ? acc * v : acc / v;
    }
    return acc;
  }

  double factor(double? base) {
    if (i >= t.length || t[i] is! double) throw _ParseError();
    var n = t[i++] as double;
    if (i < t.length && t[i] == '%') {
      i++;
      final endsTerm = i >= t.length || t[i] == '+' || t[i] == '−';
      n = base != null && endsTerm ? base * n / 100 : n / 100;
    }
    return n;
  }
}

/// Applies a keypad press to [expr] and returns the new expression.
///
/// Keys are digits, `.`, the operators, `%`, `⌫` (backspace) and `C` (clear).
String applyKey(String expr, String key) {
  if (key == 'C') return '';
  if (key == '⌫') return expr.isEmpty ? expr : expr.substring(0, expr.length - 1);

  final last = expr.isEmpty ? '' : expr[expr.length - 1];
  final segment = _lastNumber(expr);

  if (key == '.') {
    if (segment.contains('.')) return expr;
    if (segment.isEmpty || segment == '−') return '${expr}0.';
    return '$expr.';
  }
  if (operators.contains(key)) {
    if (expr.isEmpty) return key == '−' ? '−' : expr;
    if (expr == '−') return expr;
    // Allow a negative operand after × or ÷, otherwise replace the operator.
    if (key == '−' && (last == '×' || last == '÷')) return '$expr−';
    if (operators.contains(last)) {
      var trimmed = expr;
      while (trimmed.isNotEmpty && operators.contains(trimmed[trimmed.length - 1])) {
        trimmed = trimmed.substring(0, trimmed.length - 1);
      }
      return trimmed.isEmpty ? expr : '$trimmed$key';
    }
    if (last == '.') return '${expr}0$key';
    return '$expr$key';
  }
  if (key == '%') {
    final isDigit = last.isNotEmpty && last.codeUnitAt(0) >= 0x30 && last.codeUnitAt(0) <= 0x39;
    return isDigit || last == '.' ? '$expr%' : expr;
  }
  // Digit.
  if (last == '%') return expr;
  if (segment.replaceAll('−', '').replaceAll('.', '').length >= 15) return expr;
  if (segment == '0') return '${expr.substring(0, expr.length - 1)}$key';
  if (segment == '−0') return '${expr.substring(0, expr.length - 1)}$key';
  return '$expr$key';
}

/// The trailing number being typed, including a leading unary minus.
String _lastNumber(String expr) {
  var i = expr.length;
  while (i > 0) {
    final c = expr[i - 1];
    final isDigit = c.codeUnitAt(0) >= 0x30 && c.codeUnitAt(0) <= 0x39;
    if (!isDigit && c != '.') break;
    i--;
  }
  final isUnary = i > 0 && expr[i - 1] == '−' && (i == 1 || operators.contains(expr[i - 2]));
  return expr.substring(isUnary ? i - 1 : i);
}
