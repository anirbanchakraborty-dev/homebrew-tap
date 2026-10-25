#!/usr/bin/env bash
# Writes Formula/swara.rb for one Swara release, taking every checksum from the SHA256SUMS file
# that the release publishes, so no checksum is typed by hand.
#
#   scripts/update-swara.sh 0.1.0           writes the formula
#   scripts/update-swara.sh --check 0.1.0   exits 1 if the formula differs from what it would write
set -euo pipefail

check=0
if [ "${1:-}" = "--check" ]; then
  check=1
  shift
fi
version="${1:?usage: scripts/update-swara.sh [--check] VERSION}"
version="${version#v}"

repo="anirbanchakraborty-dev/swara"
base="https://github.com/${repo}/releases/download/v${version}"
root="$(cd "$(dirname "$0")/.." && pwd)"
formula="${root}/Formula/swara.rb"

sums="$(curl --fail --location --silent --show-error "${base}/SHA256SUMS")"

# Prints the checksum of one platform's archive, or fails if the release has none.
sha() {
  local name="swara-${version}-$1.tar.gz" hash
  hash="$(awk -v name="${name}" '$2 == name { print $1 }' <<<"${sums}")"
  if [[ ! "${hash}" =~ ^[0-9a-f]{64}$ ]]; then
    echo "no checksum for ${name} in ${base}/SHA256SUMS" >&2
    return 1
  fi
  printf '%s' "${hash}"
}

mac_arm="$(sha aarch64-apple-darwin)"
mac_intel="$(sha x86_64-apple-darwin)"
linux_arm="$(sha aarch64-unknown-linux-gnu)"
linux_intel="$(sha x86_64-unknown-linux-gnu)"

new="$(mktemp)"
trap 'rm -f "${new}"' EXIT
cat >"${new}" <<EOF
# Written by scripts/update-swara.sh from the release's SHA256SUMS. Change the script, not this file.
class Swara < Formula
  desc "LilyPond language server, formatter and Tree-sitter grammar"
  homepage "https://github.com/${repo}"
  license "MIT"

  on_macos do
    on_arm do
      url "${base}/swara-${version}-aarch64-apple-darwin.tar.gz"
      sha256 "${mac_arm}"
    end
    on_intel do
      url "${base}/swara-${version}-x86_64-apple-darwin.tar.gz"
      sha256 "${mac_intel}"
    end
  end

  on_linux do
    on_arm do
      url "${base}/swara-${version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "${linux_arm}"
    end
    on_intel do
      url "${base}/swara-${version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "${linux_intel}"
    end
  end

  # swara looks for its grammar in ../lib beside its own resolved path, so the two stay together.
  def install
    bin.install "bin/swara"
    lib.install Dir["lib/*"]
  end

  test do
    assert_match "swara #{version}", shell_output("#{bin}/swara --version")
    assert_match "\"grammar\":\"#{lib}/libswara_parser.", shell_output("#{bin}/swara info")
  end
end
EOF

if [ "${check}" -eq 1 ]; then
  if cmp -s "${new}" "${formula}"; then
    echo "Formula/swara.rb matches the ${version} release"
  else
    echo "Formula/swara.rb differs from what the ${version} release gives; run scripts/update-swara.sh ${version}" >&2
    exit 1
  fi
else
  mkdir -p "$(dirname "${formula}")"
  cp "${new}" "${formula}"
  echo "wrote Formula/swara.rb for ${version}"
fi
