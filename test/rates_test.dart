import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:open_converter/rates.dart';

const _rates = '{"date":"2026-10-20","usd":{"usd":1,"eur":0.9}}';
const _names = '{"usd":"US Dollar","eur":"Euro"}';

/// Serves the API from [working] mirrors and fails the rest the given way.
MockClient _client(Set<String> working, {required http.Response Function() failure, List<String>? log}) {
  return MockClient((req) async {
    log?.add(req.url.host);
    if (!working.any((m) => req.url.toString().startsWith(m))) return failure();
    return http.Response(req.url.path.endsWith('/usd.min.json') ? _rates : _names, 200);
  });
}

void main() {
  final [primary, fallback] = RatesService.mirrors;

  test('uses jsDelivr when it works', () async {
    final hosts = <String>[];
    final service = RatesService(
      client: _client({primary, fallback}, failure: () => http.Response('', 500), log: hosts),
    );
    final snapshot = await service.fetch();
    expect(snapshot.rates['eur'], 0.9);
    expect(hosts.toSet(), {'cdn.jsdelivr.net'});
  });

  test('falls back to Cloudflare Pages when jsDelivr returns an error', () async {
    final hosts = <String>[];
    final service = RatesService(
      client: _client({fallback}, failure: () => http.Response('', 503), log: hosts),
    );
    final snapshot = await service.fetch();
    expect(snapshot.rates['eur'], 0.9);
    expect(hosts.last, 'latest.currency-api.pages.dev');
  });

  test('falls back when jsDelivr serves something that is not rates', () async {
    final service = RatesService(client: _client({fallback}, failure: () => http.Response('<html>', 200)));
    expect((await service.fetch()).date, '2026-10-20');
  });

  test('falls back when jsDelivr is unreachable', () async {
    final service = RatesService(
      client: MockClient((req) async {
        if (req.url.host == 'cdn.jsdelivr.net') throw http.ClientException('no route to host');
        return http.Response(req.url.path.endsWith('/usd.min.json') ? _rates : _names, 200);
      }),
    );
    expect((await service.fetch()).rates['eur'], 0.9);
  });

  test('fails only when every mirror fails', () async {
    final service = RatesService(client: _client({}, failure: () => http.Response('', 500)));
    expect(service.fetch(), throwsA(isA<http.ClientException>()));
  });
}
