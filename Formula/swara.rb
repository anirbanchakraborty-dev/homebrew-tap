# Written by scripts/update-swara.sh from the release's SHA256SUMS. Change the script, not this file.
class Swara < Formula
  desc "LilyPond language server, formatter and Tree-sitter grammar"
  homepage "https://github.com/anirbanchakraborty-dev/swara"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/anirbanchakraborty-dev/swara/releases/download/v0.1.0/swara-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "40a32c159cbd5650389783c35d560544dad5f9d059516635c609ec613527a4ff"
    end
    on_intel do
      url "https://github.com/anirbanchakraborty-dev/swara/releases/download/v0.1.0/swara-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "9f5df7e88b9d7631dc7b7b3cb3d5e34184ec007480bef6b1408d9eda3a63f3f9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anirbanchakraborty-dev/swara/releases/download/v0.1.0/swara-0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2e5bc5c6c246225c82a3e1bd82ce6b96b00d2106727cb92ea987df438a7361dd"
    end
    on_intel do
      url "https://github.com/anirbanchakraborty-dev/swara/releases/download/v0.1.0/swara-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "33a6d03581662e8ea491cacab48e6353b2a067a9a2d56172c7efaa501f3e2000"
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
