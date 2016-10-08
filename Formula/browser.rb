class Browser < Formula
  desc "Pipe HTML to a browser"
  homepage "https://gist.github.com/12e1e81f6559efe2e70954a593efc767"
  url "https://gist.githubusercontent.com/anonymous/12e1e81f6559efe2e70954a593efc767/raw/ee15ab6da61d4e26cb736ef065fd316581a69cdd/browser"
  version "1.0.0"
  sha256 "4fde3bb9c9ef97e8955eee8d7d1f6147d55b141500a5a7576ff6c341d3ec3cdb"

  def install
    bin.install "browser"
  end

  test do
    assert_match "you idiot", shell_output("#{bin}/browser")
  end
end
