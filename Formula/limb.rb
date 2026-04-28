class Limb < Formula
  desc "A focused CLI for git worktree management"
  homepage "https://github.com/ss0923/limb"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ss0923/limb/releases/download/v0.2.0/limb-aarch64-apple-darwin.tar.xz"
      sha256 "89eabbb96aac3ee26983f4a358064e8a80e5c33a38179c3e74bd8681207a4d6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ss0923/limb/releases/download/v0.2.0/limb-x86_64-apple-darwin.tar.xz"
      sha256 "46856546c2721b6b88788d680f86c7b86f0262078fff00b2c717379521493aa5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ss0923/limb/releases/download/v0.2.0/limb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8ccf9ca593afad4d815e469a70c2c75ffa7e16f396c55f6d761f109584eb442c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ss0923/limb/releases/download/v0.2.0/limb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7330d0c9a09e5574a8484820e728d96276f8e25cd0d2c36f11a0338d21e8f059"
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
