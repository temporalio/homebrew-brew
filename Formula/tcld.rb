class Tcld < Formula
  desc "Temporal Cloud CLI (tcld)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tcld.git",
    tag: "v0.14.1",
    revision: "49cf16b25027bfee2f7294ec81cd5c9e385cc309"

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
