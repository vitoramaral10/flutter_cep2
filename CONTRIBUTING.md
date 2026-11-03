# Contributing to flutter_cep2

Thanks for helping. This page has what you need to get a change merged.

## Reporting bugs and asking for features

Open an [issue](https://github.com/vitoramaral10/flutter_cep2/issues) with the
bug report or feature request template. For bugs, include the smallest code
that shows the problem and your `flutter_cep2` and Dart/Flutter versions.

For security problems, follow [SECURITY.md](SECURITY.md) instead.

## Development

You need the Dart SDK (3.0 or later). The `example/` app also needs Flutter.

```bash
git clone https://github.com/<you>/flutter_cep2.git
cd flutter_cep2
dart pub get --no-example
bash scripts/setup-hooks.sh   # format check and commit message check
```

Before opening a pull request, run what CI runs:

```bash
dart format lib test
dart analyze --fatal-infos lib test
dart test
```

CI also requires at least 90% line coverage, runs the tests with the lowest
dependency versions allowed by `pubspec.yaml`, and analyzes and tests the
example app (`cd example && flutter analyze && flutter test`).

## Pull requests

- Open the PR against `main` and say what changed and why.
- Add or update tests for any change in behavior.
- Add an entry under `## [Unreleased]` in `CHANGELOG.md` for anything users notice.
- Keep public APIs documented; the analyzer enforces `public_member_api_docs`.

## Commit messages

[Conventional Commits](https://www.conventionalcommits.org/):
`type(scope?): subject`, with the subject in the imperative, lowercase, no
final period.

| Type       | Use for                                  |
|------------|------------------------------------------|
| `feat`     | A new feature                            |
| `fix`      | A bug fix                                |
| `docs`     | Documentation only                       |
| `style`    | Formatting, no code change               |
| `refactor` | Code change with no behavior change      |
| `perf`     | Performance                              |
| `test`     | Tests only                               |
| `build`    | Dependencies and packaging               |
| `ci`       | CI configuration                         |
| `chore`    | Anything else                            |
| `revert`   | Reverting a commit                       |

Add `!` after the type for a breaking change, e.g. `feat!: drop XML output`.

## Releasing (maintainers)

1. Bump `version` in `pubspec.yaml` and move the `Unreleased` entries in
   `CHANGELOG.md` under the new version with today's date.
2. Merge to `main`.
3. Tag the merge commit and push the tag:
   `git tag v1.2.3 && git push origin v1.2.3`.

The `Publish` workflow checks that the tag matches `pubspec.yaml`, runs the
checks, publishes to pub.dev and creates the GitHub release.

## Code of Conduct

This project follows the [Code of Conduct](CODE_OF_CONDUCT.md).
