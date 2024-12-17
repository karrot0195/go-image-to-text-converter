# Stage 1: Build stage
FROM golang:1.23.4 AS builder

WORKDIR /app

# Copy the go.mod and go.sum first to leverage caching for dependencies
COPY go.mod go.sum ./

# Fetch Go dependencies (will be cached if go.mod and go.sum don't change)
RUN go mod tidy

# Now copy the rest of the application code
COPY . .

# Build the app (if needed, you can replace `go run` with `go build` for production)
RUN go mod tidy

# Stage 2: Final runtime image
FROM alpine:3.14

# Install runtime dependencies (no need to install build tools again)
RUN apk add --no-cache \
build-base \
tesseract-ocr \
tesseract-ocr-dev \
&& rm -rf /var/cache/apk/*

# Copy only the necessary files from the builder stage
COPY --from=builder /app /app
COPY --from=builder /usr/local/go /usr/local/go

# Set Go environment variables
ENV GOPATH=/go
ENV GOROOT=/usr/local/go
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# Set the working directory
WORKDIR /app

RUN go get
# Run the application
CMD ["go", "run", "app.go"]
