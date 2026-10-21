import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

/// Exchange rates against USD plus display names, keyed by lowercase code.
class RatesSnapshot {
  const RatesSnapshot({required this.date, required this.rates, required this.names});

  /// Publication date of the rates, `YYYY-MM-DD`.
  final String date;

  /// Units of each currency per 1 USD.
  final Map<String, double> rates;
  final Map<String, String> names;

  factory RatesSnapshot.fromJson(Map<String, dynamic> json) => RatesSnapshot(
        date: json['date'] as String,
        rates: {
          for (final e in (json['rates'] as Map<String, dynamic>).entries)
            e.key: (e.value as num).toDouble(),
        },
        names: Map<String, String>.from(json['names'] as Map),
      );

  Map<String, dynamic> toJson() => {'date': date, 'rates': rates, 'names': names};

  static Future<RatesSnapshot> bundled() async {
    final text = await rootBundle.loadString('assets/rates_fallback.json');
    return RatesSnapshot.fromJson(jsonDecode(text) as Map<String, dynamic>);
  }
}

/// Fetches daily rates from the free, keyless fawazahmed0 currency-api
/// (CC0, https://github.com/fawazahmed0/exchange-api), trying the jsDelivr
/// CDN first and the Cloudflare Pages mirror second.
class RatesService {
  RatesService({http.Client? client}) : _client = client ?? http.Client();

  static const mirrors = [
    'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1',
    'https://latest.currency-api.pages.dev/v1',
  ];

  final http.Client _client;

  Future<RatesSnapshot> fetch() async {
    Object? lastError;
    for (final base in mirrors) {
      try {
        final responses = await Future.wait([
          _get('$base/currencies/usd.min.json'),
          _get('$base/currencies.min.json'),
        ]);
        return parse(responses[0], responses[1]);
      } catch (e) {
        lastError = e;
      }
    }
    throw lastError ?? Exception('No rate mirrors configured');
  }

  /// Builds a snapshot from the API's rates and names payloads, dropping
  /// entries without a usable rate or name.
  static RatesSnapshot parse(String ratesBody, String namesBody) {
    final ratesJson = jsonDecode(ratesBody) as Map<String, dynamic>;
    final namesJson = jsonDecode(namesBody) as Map<String, dynamic>;
    final rates = <String, double>{};
    final names = <String, String>{};
    for (final e in (ratesJson['usd'] as Map<String, dynamic>).entries) {
      final name = namesJson[e.key];
      final value = e.value;
      if (value is num && value > 0 && name is String && name.isNotEmpty) {
        rates[e.key] = value.toDouble();
        names[e.key] = name;
      }
    }
    rates['usd'] = 1;
    names['usd'] = (namesJson['usd'] as String?) ?? 'US Dollar';
    return RatesSnapshot(date: ratesJson['date'] as String, rates: rates, names: names);
  }

  Future<String> _get(String url) async {
    final response = await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw http.ClientException('HTTP ${response.statusCode}', Uri.parse(url));
    }
    return utf8.decode(response.bodyBytes);
  }
}
