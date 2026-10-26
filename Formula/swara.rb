# Written by scripts/update-swara.sh from the release's SHA256SUMS. Change the script, not this file.
class Swara < Formula
  desc "LilyPond language server, formatter and Tree-sitter grammar"
  homepage "https://github.com/anirbanchakraborty-dev/swara"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/anirbanchakraborty-dev/swara/releases/download/v0.1.1/swara-0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "d229d578282810c96cc1cedf0998e8422dc1f70aa72b34558b0769a41e91b96d"
    end
    on_intel do
      url "https://github.com/anirbanchakraborty-dev/swara/releases/download/v0.1.1/swara-0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "80dc2f3bef79b663ced094d0cdfb04a0adfc6bec170507cafa8ac2a70dbc8689"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anirbanchakraborty-dev/swara/releases/download/v0.1.1/swara-0.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5a6c123c4b6dc0041eb24bebea5a97cb3ca343b164dc80195fb3d3032b78bb2b"
    end
    on_intel do
      url "https://github.com/anirbanchakraborty-dev/swara/releases/download/v0.1.1/swara-0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "338dc01cf6598e283147792af7831c91dc0370a4e76a16e24fbb6ef781f0fbdb"
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
