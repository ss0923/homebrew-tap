class Limb < Formula
  desc "A focused CLI for git worktree management"
  homepage "https://github.com/ss0923/limb"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ss0923/limb/releases/download/v0.1.0/limb-aarch64-apple-darwin.tar.xz"
      sha256 "43a87aebf0a5f55230c76b51f9c4733e908538adaa8d0ae700c86897ef4e2ad8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ss0923/limb/releases/download/v0.1.0/limb-x86_64-apple-darwin.tar.xz"
      sha256 "1071a38a4f55ecee152841cefa1eb304fa3f01064cb6843dcdc6081c02eabddc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ss0923/limb/releases/download/v0.1.0/limb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fee28ddd3f13a801ff040ca24e5edcb3ed0006b66fbe655ff0c50765c1f75f23"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ss0923/limb/releases/download/v0.1.0/limb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2d6aae9d9005e627aa26710515ec359f044f17dc5e2104735d6bc171b5d88c98"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "limb" if OS.mac? && Hardware::CPU.arm?
    bin.install "limb" if OS.mac? && Hardware::CPU.intel?
    bin.install "limb" if OS.linux? && Hardware::CPU.arm?
    bin.install "limb" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
