#!/bin/bash

# CDPx treats any output to stderr as a warning, so redirect output from
# "set -x" to stdout instead of stderr.
BASH_XTRACEFD=1
set -eux

export GOOS=windows
export GOPROXY=off # Prohibit downloads

mkdir -p /source/cdpx-artifacts
cd /source/cdpx-artifacts

# Set up GOPATH with a symlink pointing to the actual source location.
mkdir -p $GOPATH/src/github.com/Microsoft
ln -s /source $GOPATH/src/github.com/Microsoft/hcsshim

go build -v github.com/Microsoft/hcsshim/cmd/containerd-shim-runhcs-v1
go build -v github.com/Microsoft/hcsshim/cmd/runhcs
go build -v github.com/Microsoft/hcsshim/cmd/tar2ext4
GOOS=linux go build -v github.com/Microsoft/hcsshim/cmd/tar2ext4
go build -v github.com/Microsoft/hcsshim/internal/tools/zapdir
go build -v github.com/Microsoft/hcsshim/internal/tools/grantvmgroupaccess
go test -c -v github.com/Microsoft/hcsshim/test/cri-containerd --tags functional
