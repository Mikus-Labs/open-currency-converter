import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:open_converter/app_state.dart';
import 'package:open_converter/rates.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _rates = '{"date":"2026-10-20","usd":{"usd":1,"eur":0.9,"gbp":0.75,"jpy":150,"cny":7}}';
const _names = '{"usd":"US Dollar","eur":"Euro","gbp":"British Pound","jpy":"Japanese Yen","cny":"Chinese Yuan"}';

/// App state backed by a mock rates API and empty preferences.
Future<AppState> testState({bool online = true}) async {
  SharedPreferences.setMockInitialValues({});
  final client = MockClient((req) async {
    if (!online) throw http.ClientException('offline');
    return http.Response(req.url.path.endsWith('/usd.min.json') ? _rates : _names, 200);
  });
  final state = AppState(
    service: RatesService(client: client),
    prefs: await SharedPreferences.getInstance(),
  );
  await state.load();
  return state;
}
