# GENERATED FILE — do not edit.
# Rendered for v0.1.8 by scripts/bump-tap-formula.mjs in the Hearsai source repo and
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
  version "0.1.8"

  on_macos do
    on_arm do
      url "https://github.com/HendinTom/hearsai-cli/releases/download/v0.1.8/hearsai-darwin-arm64"
      sha256 "06220fccaf58a95c21968ffec5ed534337312164535cddf2caf432abf20e21a1"
    end
    on_intel do
      url "https://github.com/HendinTom/hearsai-cli/releases/download/v0.1.8/hearsai-darwin-x64"
      sha256 "2c0f63ec3695f3d271b3f875b1dc8e40913a2b5a224fd018903a1cf0a1929cd3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/HendinTom/hearsai-cli/releases/download/v0.1.8/hearsai-linux-arm64"
      sha256 "2c494a312800c04df8607b8c4c51bca354d9986f97953a29c8872cac146f477a"
    end
    on_intel do
      url "https://github.com/HendinTom/hearsai-cli/releases/download/v0.1.8/hearsai-linux-x64"
      sha256 "2e21f8feb85e1d09e9d4af174a28e991fdd5f34e1aff13700db5de1300aa759b"
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
