# renovate-config

Shared Renovate setup for the DiverOfDark image repos.

- `default.json`: the preset. Security fixes (OSV) skip the 14-day release-age wait, weekly
  lockfile maintenance, patch updates automerge on green CI, cargo-auditable pin in Dockerfiles.
- `.github/workflows/renovate.yml`: reusable workflow that runs Renovate on the calling repo,
  then starts the Renovate agent for it (`agent: false` in the caller turns that off).
- `.github/workflows/renovate-agent.yml` + `agent/`: the Renovate agent. Per repo, an LLM
  triages the open Renovate PRs (comment + `agent:safe` / `agent:needs-human` label), pushes
  source fixes an update needs, merges the safe PRs one at a time once CI is green, and
  watches CI on the default branch and the GitImage rollout (found in the cluster by the
  repo's URL), reverting the merge if either fails. Runs on the `renovate-agent-apps` runner
  scale set in the homelab cluster. Manual run: Actions → Renovate agent → Run workflow.

To add a repo: `renovate.json` with `"extends": ["github>DiverOfDark/renovate-config"]`, a
`.github/workflows/renovate.yml` calling this workflow (see `caller.yml.tmpl`), and the
`RENOVATE_TOKEN` repo secret. Add the repo to that token's repository list too: the agent
reaches only repos the token covers.
