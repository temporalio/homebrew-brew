class Tcld < Formula
  desc "Temporal Cloud CLI (tcld)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tcld/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "01a6fc6703cdd57cee7c4fbbb84342bd0fea9ff00bc296ca20c7ba1e43b5a466"
  
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"tcld", "./cmd/tcld/main.go", "./cmd/tcld/fx.go"
  end

  test do
    # Given tcld is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tcld version 2>&1")
    assert_match "Version", run_output

    run_output = shell_output("#{bin}/tcld -s localhost:1234 n l 2>&1")
    assert_match "rpc error", run_output
  end
end
