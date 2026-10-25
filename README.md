# homebrew-tap

Homebrew formulae for [Swara](https://github.com/anirbanchakraborty-dev/swara), a LilyPond language server and Neovim plugin.

## Installing Swara

```bash
brew install anirbanchakraborty-dev/tap/swara
```

The formula installs the `swara` program, which holds the language server, the formatter and the LilyPond grammar. It uses the archive each Swara release publishes for macOS on Apple silicon and Intel and for Linux on x86-64 and ARM64, checked against that release's checksums. LilyPond itself comes from `brew install lilypond`.

The Neovim plugin uses a `swara` found on `PATH` before it downloads one of its own, so it picks this one up with no setting. It does not compare versions, so run `brew upgrade swara` whenever the plugin is updated, and the two stay on the same release.

## Updating the formula

`scripts/update-swara.sh 0.2.0` rewrites `Formula/swara.rb` for a new release from the `SHA256SUMS` file that release publishes, so no checksum is typed by hand. `scripts/update-swara.sh --check 0.2.0` changes nothing and exits 1 when the formula differs from what the script would write.

## Licence

MIT.
