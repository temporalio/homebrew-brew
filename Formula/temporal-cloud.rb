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
    root_url "https://github.com/temporalio/homebrew-brew/releases/download/temporal-cloud-0.2.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "cb921944cceb8644746d98d04b99dd6d4593e243b5a4183483159daa5ad4a086"
    sha256 cellar: :any,                 x86_64_linux: "78e640bb447c86f1effc934c7f1a274ef60736893d3afe5e3973d7b81b218c0f"
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
