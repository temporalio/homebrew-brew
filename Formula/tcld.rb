class Tcld < Formula
  desc "Temporal Cloud CLI (tcld)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tcld/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "ac0d02dafe48662d49e2bd9eda94e69d841bcaad02148c866a53767a3ae55cf7"
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
