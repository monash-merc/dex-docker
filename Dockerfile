FROM ubuntu:16.04
MAINTAINER Jason Rigby <Jason.Rigby@monash.edu>

# Update, upgrade and install dependencies
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y wget git gcc make ca-certificates && \
    apt-get clean

# Set the desired GO version and Dex branch/commit hash
ENV GO_VERSION 1.7.3
ENV DEX_GIT_URL https://github.com/jasonrig/dex.git
ENV DEX_BRANCH 9286bed
# ENV DEX_GIT_URL https://github.com/coreos/dex.git
# ENV DEX_BRANCH 6202e4d

# Fetch GO
WORKDIR /opt
RUN wget --quiet https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz && \
    tar -zxf go$GO_VERSION.linux-amd64.tar.gz && \
    rm go$GO_VERSION.linux-amd64.tar.gz
ENV PATH $PATH:/opt/go/bin
ENV GOROOT /opt/go

# Download Dex source
ENV GOPATH /opt/dex
RUN git clone $DEX_GIT_URL $GOPATH/src/github.com/coreos/dex
WORKDIR $GOPATH/src/github.com/coreos/dex
RUN git checkout $DEX_BRANCH

# Build Dex and copy binaries to /usr/local/bin
RUN make
RUN cp $GOPATH/src/github.com/coreos/dex/bin/dex /usr/local/bin/dex

# Clean up...
# Remove Dex source
RUN rm -R $GOPATH
# Remove GO compilers
RUN rm -R $GOROOT
# Remove packages no longer required
RUN apt-get purge -y git wget make && apt-get autoremove -y

# Expose the Dex port
EXPOSE 5556

CMD ["dex", "serve", "/mnt/config.yaml"]
