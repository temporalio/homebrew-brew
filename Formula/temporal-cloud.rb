class TemporalCloud < Formula
  desc "Cloud plugin for the Temporal CLI (Pre-release)"
  homepage "https://github.com/temporalio/cloud-cli"

  url "https://github.com/temporalio/cloud-cli/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "32ca6328da291057f62863b45157000b41a96190837ae17df78a791620c5e5f3"
  license "MIT"
  head "https://github.com/temporalio/cloud-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/temporalio/homebrew-prerelease/releases/download/temporal-cloud-0.0.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "cc5a9dec01a1514ee85d93f12740551a113b3431eea026e9655d30cb1768784d"
    sha256 cellar: :any,                 x86_64_linux: "a2d8cdcd33e97e2d90aa84288fbe5c65288ae1b39446120eb03780dc3cd26899"
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
