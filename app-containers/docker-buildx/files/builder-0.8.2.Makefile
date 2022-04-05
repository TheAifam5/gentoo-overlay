#   Copyright 2020 Docker Compose CLI authors

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

GOOS?=$(shell go env GOOS)
GOARCH?=$(shell go env GOARCH)

PKG_NAME := github.com/docker/buildx

EXTENSION:=
ifeq ($(GOOS),windows)
  EXTENSION:=.exe
endif

STATIC_FLAGS=CGO_ENABLED=0

GIT_TAG?=$(shell git describe --match 'v[0-9]*' --dirty='.m' --always --tags)
GIT_REV?=$(shell git rev-parse HEAD)$(shell if ! git diff --no-ext-diff --quiet --exit-code; then echo .m; fi)

LDFLAGS="-X $(PKG_NAME)/version.Version=${GIT_TAG} -X $(PKG_NAME)/version.Revision=${GIT_REV} -X $(PKG_NAME)/version.Package=$(PKG_NAME)"
GO_BUILD=$(STATIC_FLAGS) go build -trimpath -ldflags=$(LDFLAGS)

BUILDX_BINARY?=bin/docker-buildx
BUILDX_BINARY_WITH_EXTENSION=$(BUILDX_BINARY)$(EXTENSION)

WORK_DIR:=$(shell mktemp -d)

TAGS:=
ifdef BUILD_TAGS
  TAGS=-tags $(BUILD_TAGS)
  LINT_TAGS=--build-tags $(BUILD_TAGS)
endif

.PHONY: buildx-plugin
buildx-plugin:
	GOOS=${GOOS} GOARCH=${GOARCH} $(GO_BUILD) $(TAGS) -o $(BUILDX_BINARY_WITH_EXTENSION) ./cmd/buildx

.PHONY: cross
cross:
	GOOS=linux   GOARCH=amd64 $(GO_BUILD) $(TAGS) -o $(BUILDX_BINARY)-linux-x86_64 ./cmd/buildx
	GOOS=linux   GOARCH=arm64 $(GO_BUILD) $(TAGS) -o $(BUILDX_BINARY)-linux-aarch64 ./cmd/buildx
	GOOS=linux   GOARM=6 GOARCH=arm $(GO_BUILD) $(TAGS) -o $(BUILDX_BINARY)-linux-armv6 ./cmd/buildx
	GOOS=linux   GOARM=7 GOARCH=arm $(GO_BUILD) $(TAGS) -o $(BUILDX_BINARY)-linux-armv7 ./cmd/buildx
	GOOS=linux   GOARCH=s390x $(GO_BUILD) $(TAGS) -o $(BUILDX_BINARY)-linux-s390x ./cmd/buildx
	GOOS=darwin  GOARCH=amd64 $(GO_BUILD) $(TAGS) -o $(BUILDX_BINARY)-darwin-x86_64 ./cmd/buildx
	GOOS=darwin  GOARCH=arm64 $(GO_BUILD) $(TAGS) -o $(BUILDX_BINARY)-darwin-aarch64 ./cmd/buildx
	GOOS=windows GOARCH=amd64 $(GO_BUILD) $(TAGS) -o $(BUILDX_BINARY)-windows-x86_64.exe ./cmd/buildx

.PHONY: test
test:
	go test $(TAGS) -cover $(shell go list  $(TAGS) ./... | grep -vE 'e2e')

.PHONY: lint
lint:
	golangci-lint run $(LINT_TAGS) --timeout 10m0s ./...

.PHONY: check-license-headers
check-license-headers:
	./scripts/validate/fileheader

.PHONY: check-go-mod
check-go-mod:
	./scripts/validate/check-go-mod
