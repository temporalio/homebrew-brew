class TemporalCloud < Formula
  desc "Cloud plugin for the Temporal CLI (Pre-release)"
  homepage "https://github.com/temporalio/cloud-cli"

  url "https://github.com/temporalio/cloud-cli/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "1768577a5ab23ebbbb589e26ce60a3590585ad5dac048d2dc7c02bf29c910d07"
  license "MIT"
  head "https://github.com/temporalio/cloud-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/temporalio/homebrew-brew/releases/download/temporal-cloud-0.2.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "a7e86224635b0e1390a1d8891b5b2d25e8144fc849c35157d35e92d2126dbf8d"
    sha256 cellar: :any,                 x86_64_linux: "e8873fb092c648f366b2ff72308968b5c622e0c5ad2df9d2500122b00790dfff"
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
