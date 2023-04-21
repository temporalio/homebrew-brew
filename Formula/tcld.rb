class Tcld < Formula
  desc "Temporal Cloud CLI (tcld)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tcld/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "34aa769944e2c38eacd957e648739e3f70c4169fbbc91836cf43e33bf1336084"
  
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
