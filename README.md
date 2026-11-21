# renovate-config

Shared Renovate setup for the DiverOfDark image repos.

- `default.json`: the preset. Security fixes (OSV) skip the 14-day release-age wait, weekly
  lockfile maintenance, patch updates automerge on green CI, cargo-auditable pin in Dockerfiles.
- `.github/workflows/renovate.yml`: reusable workflow that runs Renovate on the calling repo.

To add a repo: `renovate.json` with `"extends": ["github>DiverOfDark/renovate-config"]`, a
`.github/workflows/renovate.yml` calling this workflow (see `caller.yml.tmpl`), and the
`RENOVATE_TOKEN` repo secret.
