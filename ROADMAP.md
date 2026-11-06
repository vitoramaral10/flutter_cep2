# Roadmap

What comes next for flutter_cep2, in priority order. Ideas and feedback are
welcome in the [issues](https://github.com/vitoramaral10/flutter_cep2/issues).

flutter_cep2 is a connector: it reads each provider correctly, says who
answered, and leaves the trust decision to your app. Fixing a provider's data
is out of scope.

## Done in 1.4.0

- [x] Example app shows which provider answered and flags whole-city CEPs
- [x] `isValidCep` rejects numbers outside every Correios state range
- [x] `CepException.providerErrors`: what each provider said when all failed
- [x] Configurable cache size (`cacheMaxEntries`)

## Next (1.5.0)

- [ ] **Pluggable cache**: a `CepCache` interface, with the in-memory cache as
  the default, so answers can persist (Hive, shared_preferences) without the
  package depending on any of them.
- [ ] **Race mode**: ask every provider at once and keep the first answer.
  Lower latency when ViaCEP is slow, at the cost of more requests. Opt-in.
- [ ] **CEP kind by suffix**: street, special code, promotional, Correios unit
  or community box, offline. Check the table against real data first.
- [ ] **LRU cache eviction** instead of dropping the oldest answer.

## Later (2.0.0, breaking)

- [ ] **Custom providers**: open `CepProvider` so an app can plug in its own
  source (an internal API, a Correios contract).
- [ ] **Remove deprecated aliases** `flutter_cep2` and `CEP`.

## Out of scope

- **Fixing or arbitrating provider data** (consensus, trust scores). Each
  provider owns its database; use `Cep.provider` to apply your own rules.
- **A widget package.** The package stays pure Dart.
- **Address search on other providers.** Only ViaCEP offers it.

## Maintenance

- [ ] Pin the CI runner (`ubuntu-latest` moved to Ubuntu 26 in October 2026).
