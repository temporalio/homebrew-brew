class Tcld < Formula
  desc "Temporal Cloud CLI (tcld)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tcld.git",
     tag:      "v0.55.0",
     revision: "4bde81d5c73d36a3316a73f21416cbb6af983384"

  license "MIT"

  bottle do
    root_url "https://github.com/temporalio/homebrew-brew/releases/download/tcld-0.55.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "38219956735791aeeb017203a9fcab99228483ecab97da954622e21c020c35fe"
    sha256 cellar: :any,                 x86_64_linux: "5055fc5f8e0958f56c6e8a131b12f2b5301a2ec21b79e063302bc62161d19a1e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/temporalio/tcld/app.version=v#{version}
      -X github.com/temporalio/tcld/app.commit=#{Utils.git_short_head(length: 12)}
      -X github.com/temporalio/tcld/app.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tcld", "./cmd/tcld"
  end

  test do
    # Verify the version string of tcld is set correctly.
    run_output = shell_output("#{bin}/tcld version 2>&1")
    assert_match "v#{version}", run_output

    # Basic validation of help.
    run_output = shell_output("#{bin}/tcld help")
    assert_match "tcld", run_output
  end
end
