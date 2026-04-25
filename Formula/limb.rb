class Limb < Formula
  desc "A focused CLI for git worktree management"
  homepage "https://github.com/ss0923/limb"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ss0923/limb/releases/download/v0.1.1/limb-aarch64-apple-darwin.tar.xz"
      sha256 "c0fd4dda792736053da4c3ed72f38b571f7a254f0672353cb034b36d0688cfda"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ss0923/limb/releases/download/v0.1.1/limb-x86_64-apple-darwin.tar.xz"
      sha256 "d0981ef83cf091137bf4d259a87a573d0cd4039fc1c754722928145f2f191c30"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ss0923/limb/releases/download/v0.1.1/limb-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ceb17c14480bb242a041295b3f77d41c6197c846d244e23dc61c33e9b838bd85"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ss0923/limb/releases/download/v0.1.1/limb-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d6740a17592a0c5358e5281b756e954d41595880a50b88f14e988cad26e5ee5e"
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
