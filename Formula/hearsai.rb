# GENERATED FILE — do not edit.
# Rendered for v0.1.7 by scripts/bump-tap-formula.mjs in the Hearsai source repo and
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
  version "0.1.7"

  on_macos do
    on_arm do
      url "https://github.com/HendinTom/hearsai-cli/releases/download/v0.1.7/hearsai-darwin-arm64"
      sha256 "c359c655fc0a5d4f13911f20bafb23b0af0d6654a35163c736014bf389d31632"
    end
    on_intel do
      url "https://github.com/HendinTom/hearsai-cli/releases/download/v0.1.7/hearsai-darwin-x64"
      sha256 "fc3c31b45fa8a50bb2941b91b819f7dfc5f2df16ba90b25c406ae1d96ea637aa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/HendinTom/hearsai-cli/releases/download/v0.1.7/hearsai-linux-arm64"
      sha256 "a4aee0de0502120cb9d3db68f66e405e0fd97c13ee297627099c8742d8f05ef6"
    end
    on_intel do
      url "https://github.com/HendinTom/hearsai-cli/releases/download/v0.1.7/hearsai-linux-x64"
      sha256 "278ea54b47def50a40752964c3893cd1155695caec98d1bba555ac6c118f9ef4"
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

      It signs you in (that login IS this device's identity), asks which directory invited
      sessions should work in, and installs the daemon. It connects to hearsai.net — there is
      nothing to configure. If your account already has a device, a human approves this one on
      the dashboard first; setup tells you where and waits for it.

      Claude Code must already be installed and logged in on this machine; Hearsai runs it
      under your own subscription and never sees your Anthropic credentials.

      Then check the whole path any time with `hearsai status`.

      On a headless box (no browser here), use the device-code flow:

          hearsai setup <label> --device

      Updates: run `brew upgrade hearsai`. A running daemon notices the new version within a
      minute and restarts itself onto it — nothing else to do. (Homebrew installs deliberately
      opt out of the daemon's own self-updater, so the package manager stays in charge.)

      Uninstalling — run these two IN THIS ORDER:

          hearsai uninstall --full
          brew uninstall hearsai

      The first stops the daemon and removes the Hearsai tools from Claude Code and this
      device's saved login; the second removes the binary, which is Homebrew's to delete.
      Running `brew uninstall` on its own leaves a background service and a Claude Code entry
      pointing at a binary that no longer exists.

      To stop this machine accepting invites without removing anything else, use plain
      `hearsai uninstall` — it keeps the Hearsai tools working in your own Claude Code sessions.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hearsai --version")
  end
end
