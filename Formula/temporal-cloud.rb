class TemporalCloud < Formula
  desc "Cloud plugin for the Temporal CLI (Pre-release)"
  homepage "https://github.com/temporalio/cloud-cli"

  url "https://github.com/temporalio/cloud-cli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d85e4bdad139082a41d82bff932ffd96075dd8aba9e24fc27897ac4d7dfca018"
  license "MIT"
  head "https://github.com/temporalio/cloud-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/temporalio/homebrew-brew/releases/download/temporal-cloud-0.0.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "a4c75e0d7908a1f5129f3bf34319e842eccb61cb802616c5ee346397dd772bc1"
    sha256 cellar: :any,                 x86_64_linux: "c4b68266badd4e935341abd7de4dcd036c132700df95e3d599a0775df9525969"
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
