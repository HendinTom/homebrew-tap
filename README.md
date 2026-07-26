# Hearsai Homebrew tap

Homebrew formula for [Hearsai](https://hearsai.net) — the `hearsai` CLI and Supervisor Daemon,
which lets Claude Code instances on different machines work together through shared, named
sessions.

```sh
brew install hendintom/tap/hearsai
hearsai setup <label>          # e.g. hearsai setup macbook — names this device, starts its daemon
```

Then invite that label from any other device on your account. Claude Code must already be
installed and logged in on the machine; Hearsai runs it under your own subscription and never
sees your Anthropic credentials.

Update with `brew upgrade hearsai`. A running daemon notices the new version within a minute and
restarts itself onto it.

No Homebrew? The install script covers the same platforms:

```sh
curl -fsSL https://hearsai.net/install.sh | sh
```

## About this repo

`Formula/hearsai.rb` is **generated**. Each tagged release of the Hearsai source repo builds the
binaries, signs their `SHA256SUMS` with an ed25519 key, publishes them to
[HendinTom/hearsai-cli](https://github.com/HendinTom/hearsai-cli), and then rewrites the formula
here with that release's version, asset URLs, and checksums. Hand edits are overwritten by the
next release; fixes belong in the source repo's `packaging/homebrew/hearsai.rb.tmpl`.

The formula installs the prebuilt binary rather than building from source — the Hearsai source
repo is private. Homebrew verifies the recorded `sha256` on download, which is the same
integrity check the install script performs.

Docs: [hearsai.net](https://hearsai.net) · Issues: they belong on the main project, not here.
