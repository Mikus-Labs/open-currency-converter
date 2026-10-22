# Security

## Reporting a vulnerability

Please report security problems privately, not in a public issue:

- [Report a vulnerability](https://github.com/Mikus-Labs/open-currency-converter/security/advisories/new)
  on GitHub (preferred), or
- email <dev@mikuslabs.co>.

Include what you found, how to reproduce it, and which version or commit it
affects. You'll get a reply within a week. Fixes go into the next release,
and the report is published as a GitHub security advisory once a fix is out,
with credit unless you'd rather stay anonymous.

## Scope

The app has no accounts, servers or analytics. It downloads public exchange
rates and stores your settings on your device; see [PRIVACY.md](PRIVACY.md).
Relevant reports include anything that could let another app, website or
network attacker read or change the app's data, run code, or tamper with the
rates it shows, and problems in the build and release pipeline in
`.github/workflows/`.
