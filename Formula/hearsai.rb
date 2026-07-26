# GENERATED FILE — do not edit.
# Rendered for v0.1.4 by scripts/bump-tap-formula.mjs in the Hearsai source repo and
# pushed here by its release workflow. Hand edits are lost on the next release.
# typed: false
# frozen_string_literal: true

# Homebrew formula for the Hearsai CLI + Supervisor Daemon (issue #28, docs/DAEMON.md
# "Distribution channels"). Rendered from packaging/homebrew/hearsai.rb.tmpl in the source repo
# by scripts/bump-tap-formula.mjs, and pushed to the tap by .github/workflows/release.yml on
# every tagged release — see the GENERATED banner the renderer puts at the top of the output.
#
# Binary-only on purpose: the source repo is private, so the formula installs the same signed
# release assets install.sh downloads. Homebrew verifies the sha256 recorded here (pinned per
# release by the renderer, read straight out of the release's own SHA256SUMS), which is the
# same integrity check install.sh performs.
#
# macOS signing: the binaries are ad-hoc (linker) signed by `bun build --compile`, which is what
# arm64 macOS requires to execute them at all, and Homebrew does not quarantine formula
# downloads the way it does casks — so Gatekeeper never prompts on this path. Developer ID
# signing + notarization stays deferred (issue #28) and would only matter if these binaries were
# ever distributed as a .app/.pkg or downloaded by a browser.
class Hearsai < Formula
  desc "Relay daemon that lets Claude Code instances on different machines work together"
  homepage "https://hearsai.net"
  version "0.1.4"

  on_macos do
    on_arm do
      url "https://github.com/HendinTom/hearsai-cli/releases/download/v0.1.4/hearsai-darwin-arm64"
      sha256 "c10fd43033b9fdaf8032755c723be24d66fff18de521718b2b08324fbd6d68f5"
    end
    on_intel do
      url "https://github.com/HendinTom/hearsai-cli/releases/download/v0.1.4/hearsai-darwin-x64"
      sha256 "a68ba93315d6027a1d282d08bfe6197e0dd018b679c3b328700246cd97c722e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/HendinTom/hearsai-cli/releases/download/v0.1.4/hearsai-linux-arm64"
      sha256 "4abb8be88ddeeef0725ea7b182b0f9789079d1262d42b04ef0c7957df8230eb6"
    end
    on_intel do
      url "https://github.com/HendinTom/hearsai-cli/releases/download/v0.1.4/hearsai-linux-x64"
      sha256 "93e56e0e026b02a3f239c6e0ca1f281bd955583a9e743837c0060d2eb87aa9c6"
    end
  end

  def install
    # One asset per platform, named hearsai-<os>-<arch> by the release workflow; whichever one
    # the blocks above selected is the only file staged here.
    bin.install Dir["hearsai-*"].first => "hearsai"
  end

  def caveats
    <<~EOS
      Finish setup once per machine — this names the device and starts its background daemon:

          hearsai setup <label>          # e.g. hearsai setup macbook

      Claude Code must already be installed and logged in on this machine; Hearsai runs it
      under your own subscription and never sees your Anthropic credentials.

      On a headless box (no browser here), use the device-code flow:

          hearsai setup <label> --device

      Updates: run `brew upgrade hearsai`. A running daemon notices the new version within a
      minute and restarts itself onto it — nothing else to do. (Homebrew installs deliberately
      opt out of the daemon's own self-updater, so the package manager stays in charge.)
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hearsai --version")
  end
end
