#!/bin/bash
docker run --rm image-to-text sh -c "go run app.go --url $1"
