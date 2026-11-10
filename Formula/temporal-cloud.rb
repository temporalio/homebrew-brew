class TemporalCloud < Formula
  desc "Cloud plugin for the Temporal CLI (Pre-release)"
  homepage "https://github.com/temporalio/cloud-cli"

  url "https://github.com/temporalio/cloud-cli/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "39ef1cf6cd6a83d915a31558ff5a41949f582ee430735c29f99667159708c943"
  license "MIT"
  head "https://github.com/temporalio/cloud-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/temporalio/homebrew-brew/releases/download/temporal-cloud-0.2.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "9c896240e9d80055f45e2a23d3e56401095ce6e21d337250057bf83d7caf908e"
    sha256 cellar: :any,                 x86_64_linux: "5ff6ba550902d605d6a60f48e0920804cad7c1ab39d5ecfddc7aec5b2a03fd58"
  end

  depends_on "go" => :build
  depends_on "temporal"

  def install
    v = build.head? ? "0.0.0-HEAD+#{Utils.git_short_head}" : version.to_s
    ldflags = "-s -w -X github.com/temporalio/cloud-cli/temporalcloudcli.Version=#{v}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal-cloud"
  end

  test do
    run_output = shell_output("#{bin}/temporal-cloud --version")
    assert_match "cloud version #{version}", run_output
  end
end
