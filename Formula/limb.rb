class Limb < Formula
  desc "A focused CLI for git worktree management"
  homepage "https://github.com/ss0923/limb"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ss0923/limb/releases/download/v0.3.0/limb-aarch64-apple-darwin.tar.xz"
      sha256 "23085029d7b57761fa681802bd94ac5e033f9f19d64afa6c0e28dd7e709e132f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ss0923/limb/releases/download/v0.3.0/limb-x86_64-apple-darwin.tar.xz"
      sha256 "1742225724977a8905c54abecd9a78dbb715a362131ec7ff6bdb9ee65dc488e7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ss0923/limb/releases/download/v0.3.0/limb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "92881a0fd0c59ed99f4420ed49c5d5b9b10f6f3f37fd782c4df75b69c64246c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ss0923/limb/releases/download/v0.3.0/limb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "396a7f8b127b9ffdb6941c4c744d2300f802751809475e2fc8ac63ce8a70d94e"
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
