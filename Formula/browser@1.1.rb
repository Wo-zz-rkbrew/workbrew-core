class BrowserAT11 < Formula
  desc "Pipe HTML to a browser"
  homepage "https://gist.github.com/anonymous/9b9188f065944eb3c40fa308ba465141"
  url "https://gist.githubusercontent.com/anonymous/9b9188f065944eb3c40fa308ba465141/raw/6871c1079fb7dde9559915b439ae47b6de17c081/browser"
  version "1.1.0"
  sha256 "be0b4e42b31476dd2411d40fb66d95fc4dba5b5c0b72e798414bcf956526eb50"

  def install
    bin.install "browser"
  end

  test do
    assert_match "you idiot", shell_output("#{bin}/browser")
  end
end
