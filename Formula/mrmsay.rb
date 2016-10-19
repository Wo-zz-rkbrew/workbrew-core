class Mrmsay < Formula
  include Language::Python::Virtualenv

  desc "MrM's wisdom in your terminal"
  homepage "https://github.com/janeappleseed/MrMsay"
  url "https://github.com/janeappleseed/MrMsay/archive/v0.3.tar.gz"
  sha256 "2f8ac95f61ebec5798ac9feb8eb0c4217fe9a07511d2f54684921466a3bd1f5b"

  bottle do
    root_url "https://workbrew.bintray.com/bottles"
    sha256 "42da8114022ec9810f0e965396ed1f409cd10d9e6b4c7f9af8b1040cb18b494f" => :sierra
  end

  depends_on "cowsay" => :run
  depends_on :python3

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/58/91/21d65af4899adbcb4158c8f0def8ce1a6d18ddcd8bbb3f5a3800f03b9308/arrow-0.8.0.tar.gz"
    sha256 "b210c17d6bb850011700b9f54c1ca0eaf8cbbd441f156f0cd292e1fbda84e7af"
  end

  resource "daemonize" do
    url "https://files.pythonhosted.org/packages/84/15/923e3fe48239adf5d697c29e04a3f868d3e4ce8539aab29d6abe784db5be/daemonize-2.4.7.tar.gz"
    sha256 "c0194e861826be456c7c69985825ac7b79632d8ac7ad4cde8e12fee7971468c8"
  end

  resource "peewee" do
    url "https://files.pythonhosted.org/packages/c1/22/8d6bc2333b6478503ef3a260d20d76f1b814fdb1930ebe195d1a626a5aea/peewee-2.8.5.tar.gz"
    sha256 "198f4b0c1e71b0ee7f3f87cb96104796a5a4cc0a52a9cd832611394f5cfdee37"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/39/ca/1db6ebefdde0a7b5fb639ebc0527d8aab1cdc6119a8e4ac7c1c0cc222ec5/sh-1.11.tar.gz"
    sha256 "590fb9b84abf8b1f560df92d73d87965f1e85c6b8330f8a5f6b336b36f0559a4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  plist_options :startup => true, :manual => "mrmd"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/mrmd</string>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProcessType</key>
        <string>Background</string>
      </dict>
    </plist>
    EOS
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    ENV["XDG_CACHE_HOME"] = testpath/".cache"
    assert_match "https://git.io/", shell_output("#{bin}/mrmsay")
  end
end
