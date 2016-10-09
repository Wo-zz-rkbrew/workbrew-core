class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftpmirror.gnu.org/emacs/emacs-25.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/emacs/emacs-25.1.tar.xz"
  sha256 "19f2798ee3bc26c95dca3303e7ab141e7ad65d6ea2b6945eeba4dbea7df48f33"

  head do
    url "https://github.com/emacs-mirror/emacs.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-ctags", "Do not remove the ctags executable provided by emacs"
  option "with-modules", "Build with dynamic modules support"
  option "with-x11", "Build with X11 support (implies --without-cocoa)"
  option "without-cocoa", "Build without Cocoa support"
  option "without-libxml2", "Build without libxml2 support"

  depends_on "dbus" => :optional
  depends_on "gnutls" => :optional
  depends_on "imagemagick" => :optional
  depends_on "librsvg" => :recommended
  depends_on "mailutils" => :optional
  depends_on "pkg-config" => :build
  depends_on :x11 => :optional

  # https://github.com/Homebrew/homebrew/issues/37803
  if build.with? "x11"
    depends_on "freetype"
    depends_on "fontconfig"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp
      --infodir=#{info}/emacs
      --prefix=#{prefix}
    ]

    %W[
      libxml2 xml2
      dbus dbus
      gnutls gnutls
      librsvg rsvg
      imagemagick imagemagick
    ].each_slice(2) do |option, feature|
      if build.with? option
        args << "--with-#{feature}"
      else
        args << "--without-#{feature}"
      end
    end

    args << "--without-pop" if build.with? "mailutils"

    if build.with?("x11")
      ENV.append "LDFLAGS", "-lfreetype -lfontconfig"
      args << "--with-x" << "--without-gif" << "--without-tiff" << "--without-jpeg"
    else
      args << "--without-x"
    end

    if build.with?("cocoa") && build.without?("x11")
      args << "--with-ns" << "--disable-ns-self-contained"
    else
      args << "--without-ns"
    end

    system "./autogen.sh" if build.head? || build.devel?
    system "./configure", *args
    system "make"
    system "make", "install"

    if build.with?("cocoa") && build.without?("x11")
      prefix.install "nextstep/Emacs.app"

      # Replace the symlink with one that avoids starting Cocoa.
      (bin/"emacs").unlink # Kill the existing symlink
      (bin/"emacs").write <<-EOS.undent
        #!/bin/bash
        exec #{prefix}/Emacs.app/Contents/MacOS/Emacs "$@"
      EOS
    end

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    if build.without? "ctags"
      (bin/"ctags").unlink
      (man1/"ctags.1.gz").unlink
    end
  end

  plist_options :manual => "emacs"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/emacs</string>
        <string>--daemon</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
