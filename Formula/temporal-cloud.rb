class TemporalCloud < Formula
  desc "Cloud plugin for the Temporal CLI (Pre-release)"
  homepage "https://github.com/temporalio/cloud-cli"

  url "https://github.com/temporalio/cloud-cli/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "456924abb44a0ff7c5fa2126e8ac3be0465b711670cfb2aa3e2e7a6feaa58cdf"
  license "MIT"
  head "https://github.com/temporalio/cloud-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/temporalio/homebrew-brew/releases/download/temporal-cloud-0.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "18672dc14c00e31e367638e45e8c21bf0afb5fc9d5937a880c9ffa7d5c4c2976"
    sha256 cellar: :any,                 x86_64_linux: "192af11b996aa5c5ee8b0808f2065f921669b5314e852adbcd60d8d10d83d76a"
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
