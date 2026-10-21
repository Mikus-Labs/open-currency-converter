/// Whether a currency is a government currency, a cryptocurrency or a
/// precious metal.
enum CurrencyKind { fiat, crypto, metal }

/// Which currencies the long currency lists show.
enum CurrencyFilter { all, noCrypto, cryptoOnly }

/// Gold, silver, platinum and palladium by the troy ounce.
const _metals = {'xag', 'xau', 'xpd', 'xpt'};

/// ISO 4217 currencies the rates API serves, current and withdrawn (such as
/// DEM or FRF), plus the territorial pounds GGP, IMP and JEP, Tuvalu's TVD,
/// Seborga's SPL, offshore yuan CNH and the IMF's SDR (XDR). Every other code
/// the API serves is a crypto token, so new tokens are classified without
/// updating this list. The API's XCG is the Xchange token, not the Caribbean
/// guilder.
const _fiat = {
  'aed', 'afn', 'all', 'amd', 'ang', 'aoa', 'ars', 'ats', 'aud', 'awg', 'azm', 'azn', //
  'bam', 'bbd', 'bdt', 'bef', 'bgn', 'bhd', 'bif', 'bmd', 'bnd', 'bob', 'brl', 'bsd', //
  'btn', 'bwp', 'byn', 'byr', 'bzd', 'cad', 'cdf', 'chf', 'clp', 'cnh', 'cny', 'cop', //
  'crc', 'cuc', 'cup', 'cve', 'cyp', 'czk', 'dem', 'djf', 'dkk', 'dop', 'dzd', 'eek', //
  'egp', 'ern', 'esp', 'etb', 'eur', 'fim', 'fjd', 'fkp', 'frf', 'gbp', 'gel', 'ggp', //
  'ghc', 'ghs', 'gip', 'gmd', 'gnf', 'grd', 'gtq', 'gyd', 'hkd', 'hnl', 'hrk', 'htg', //
  'huf', 'idr', 'iep', 'ils', 'imp', 'inr', 'iqd', 'irr', 'isk', 'itl', 'jep', 'jmd', //
  'jod', 'jpy', 'kes', 'kgs', 'khr', 'kmf', 'kpw', 'krw', 'kwd', 'kyd', 'kzt', 'lak', //
  'lbp', 'lkr', 'lrd', 'lsl', 'ltl', 'luf', 'lvl', 'lyd', 'mad', 'mdl', 'mga', 'mgf', //
  'mkd', 'mmk', 'mnt', 'mop', 'mro', 'mru', 'mtl', 'mur', 'mvr', 'mwk', 'mxn', 'myr', //
  'mzm', 'mzn', 'nad', 'ngn', 'nio', 'nlg', 'nok', 'npr', 'nzd', 'omr', 'pab', 'pen', //
  'pgk', 'php', 'pkr', 'pln', 'pte', 'pyg', 'qar', 'rol', 'ron', 'rsd', 'rub', 'rwf', //
  'sar', 'sbd', 'scr', 'sdd', 'sdg', 'sek', 'sgd', 'shp', 'sit', 'skk', 'sle', 'sll', //
  'sos', 'spl', 'srd', 'srg', 'ssp', 'std', 'stn', 'svc', 'syp', 'szl', 'thb', 'tjs', //
  'tmm', 'tmt', 'tnd', 'top', 'try', 'ttd', 'tvd', 'twd', 'tzs', 'uah', 'ugx', 'usd', //
  'uyu', 'uzs', 'val', 'veb', 'vef', 'ves', 'vnd', 'vuv', 'wst', 'xaf', 'xcd', 'xdr', //
  'xof', 'xpf', 'yer', 'zar', 'zmk', 'zmw', 'zwd', 'zwl', //
};

CurrencyKind kindOf(String code) => _metals.contains(code)
    ? CurrencyKind.metal
    : _fiat.contains(code)
    ? CurrencyKind.fiat
    : CurrencyKind.crypto;

extension CurrencyFilterMatch on CurrencyFilter {
  bool matches(String code) => switch (this) {
    CurrencyFilter.all => true,
    CurrencyFilter.noCrypto => kindOf(code) != CurrencyKind.crypto,
    CurrencyFilter.cryptoOnly => kindOf(code) == CurrencyKind.crypto,
  };
}
