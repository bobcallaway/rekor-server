FROM registry.access.redhat.com/ubi8/go-toolset AS builder
ENV GOPATH=$APP_ROOT

WORKDIR $APP_ROOT/src/
ADD go.mod go.sum $APP_ROOT/src/
RUN go mod download

# Add source code
ADD ./ $APP_ROOT/src/

RUN go install

# Multi-Stage production build
FROM registry.access.redhat.com/ubi8/ubi-minimal

# Retrieve the binary from the previous stage
COPY --from=builder /opt/app-root/bin/rekor-server /usr/local/bin/rekor-server

# Set the binary as the entrypoint of the container
CMD ["rekor-server", "serve"]
