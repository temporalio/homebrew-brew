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
    root_url "https://github.com/temporalio/homebrew-brew/releases/download/temporal-cloud-0.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "89c3d71d347b0858b571c1dd32fc370daed44ad781f16262ca7642bd666d7bff"
    sha256 cellar: :any,                 x86_64_linux: "3a7319caf97795c09dcf0b1fc357981d6a7f6eb7ca225fb04e4ee5d67b11f4bc"
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
