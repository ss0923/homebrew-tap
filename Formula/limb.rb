class Limb < Formula
  desc "A focused CLI for git worktree management"
  homepage "https://github.com/ss0923/limb"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ss0923/limb/releases/download/v0.2.1/limb-aarch64-apple-darwin.tar.xz"
      sha256 "9deffea969120d941da2cb48794feb7250de25b2201fe3f5fe450f05edd68c9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ss0923/limb/releases/download/v0.2.1/limb-x86_64-apple-darwin.tar.xz"
      sha256 "4b429dae80577a636f3f803a83c3684977ebfbe84a0e9ae57f1ebecbc1889160"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ss0923/limb/releases/download/v0.2.1/limb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6f8e77ac9d6d57a5285727832a8a81e2120b591cd2984748bade9d065ba7909e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ss0923/limb/releases/download/v0.2.1/limb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "397c304e43fe9208bc3ce287651615a472e9532c63be29fd80924f721f3a8b83"
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
