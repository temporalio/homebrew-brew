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
    root_url "https://github.com/temporalio/homebrew-brew/releases/download/temporal-cloud-0.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "b4e9275d8ef192bcff0278560f93032c0c46a4c70d6cbe6e978671d2103988e5"
    sha256 cellar: :any,                 x86_64_linux: "345752255e5825419910dadb2bdb0590544b5d95a9f76d6fb43bb82dd3d5bca6"
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
