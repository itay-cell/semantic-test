# semantic-test

A sandbox for the versioning flow from dagster-pipelines (DEV-3970): Conventional Commit PR
titles, squash merges, and semantic-release, all on `main`. (dagster-pipelines squashes into
`development` first; this example skips that branch.)

## Files
- [.github/workflows/pr-title.yml](.github/workflows/pr-title.yml): checks that a PR title into
  `main` is a Conventional Commit.
- [.releaserc.yml](.releaserc.yml): semantic-release rules (which commit type bumps which part of
  the version, and the sections of the release notes).
- [.github/workflows/release.yml](.github/workflows/release.yml): on push to `main`, runs
  semantic-release, then passes the new tag to a placeholder `build` job.

## Flow
1. Branch off `main` and open a PR into `main` titled `<type>(<scope>): <summary> (DEV-1234)`.
   The "Validate PR title" check enforces the format.
2. Squash-merge it, so the PR title becomes the commit on `main`.
3. On that push, semantic-release reads the commits since the last `vX.Y.Z` tag, pushes the next
   tag and writes a GitHub Release.

| Title                                 | Release |
|---------------------------------------|---------|
| `feat(api): add a /health endpoint`   | minor   |
| `fix` / `perf` / `refactor` / `build` / `revert` | patch |
| `feat(core)!: ...` or a `BREAKING CHANGE:` footer | major |
| `docs` / `test` / `ci` / `chore` / `style` | none (no tag, no build) |

With no earlier tag, the first release is `v1.0.0`.

## GitHub setup
- Push these files to `main` before opening the first PR. `pull_request_target` runs the workflow
  as it exists on the base branch, so the check only runs once `pr-title.yml` is on `main`.
- Repository settings → General → Pull Requests: allow only squash merging, with the default
  message set to "Pull request title". A merge commit or rebase would put the branch's own commit
  messages on `main` instead of the checked title.
- Settings → Actions → General → Workflow permissions: "Read and write", so the release job can
  push tags and create Releases.
- Optional: a ruleset on `main` that requires the "Validate PR title" check.

## version.sh
Prints the version of the checkout, from the last release tag:

```console
$ ./version.sh
2.0.0
$ ./version.sh --json
{"version": "2.0.0", "commit": "abc1234"}
```

Between releases it adds the commits since the tag (`2.0.0-3-gabc1234`); before the first release
it prints `0.0.0`. It exits 1 outside a git repository. Pull the tags first (`git fetch --tags`),
since semantic-release creates them on GitHub.
