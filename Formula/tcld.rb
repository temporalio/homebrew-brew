class Tcld < Formula
  desc "Temporal Cloud CLI (tcld)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tcld.git",
     tag: "v0.27.0"
     revision: "72cd25913471b9907a0ac8f22a147d92a2f60a74"

  license "MIT"

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
