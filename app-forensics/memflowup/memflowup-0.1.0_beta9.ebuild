# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.5.1

EAPI=8

CRATES="
	adler-1.0.2
	aes-0.7.5
	ahash-0.7.6
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.0
	base64ct-1.0.1
	bitflags-1.3.2
	block-buffer-0.10.2
	bumpalo-3.10.0
	byteorder-1.4.3
	bzip2-0.4.3
	bzip2-sys-0.1.11+1.0.8
	cc-1.0.73
	cfg-if-1.0.0
	chrono-0.4.19
	chunked_transfer-1.4.0
	cipher-0.3.0
	clap-3.1.18
	clap_lex-0.2.0
	constant_time_eq-0.1.5
	cpufeatures-0.2.2
	crc-2.1.0
	crc-catalog-1.1.1
	crc32fast-1.3.2
	crossbeam-channel-0.5.4
	crossbeam-utils-0.8.8
	crypto-common-0.1.3
	digest-0.10.3
	dirs-4.0.0
	dirs-sys-0.3.7
	either-1.6.1
	flate2-1.0.24
	form_urlencoded-1.0.1
	generic-array-0.14.5
	getrandom-0.2.6
	hashbrown-0.11.2
	hermit-abi-0.1.19
	hmac-0.12.1
	idna-0.2.3
	indexmap-1.8.2
	instant-0.1.12
	itoa-1.0.2
	jobserver-0.1.24
	js-sys-0.3.57
	lazy_static-1.4.0
	libc-0.2.126
	log-0.4.17
	matches-0.1.9
	miniz_oxide-0.5.3
	num-integer-0.1.45
	num-traits-0.2.15
	num_threads-0.1.6
	once_cell-1.12.0
	opaque-debug-0.3.0
	os_str_bytes-6.1.0
	password-hash-0.3.2
	pbkdf2-0.10.1
	pbr-1.0.4
	percent-encoding-2.1.0
	pkg-config-0.3.25
	proc-macro2-1.0.39
	progress-streams-1.1.0
	quote-1.0.18
	rand_core-0.6.3
	redox_syscall-0.2.13
	redox_users-0.4.3
	rhai-1.7.0
	rhai_codegen-1.4.0
	ring-0.16.20
	rustls-0.20.6
	ryu-1.0.10
	sct-0.7.0
	serde-1.0.137
	serde_derive-1.0.137
	serde_json-1.0.81
	sha1-0.10.1
	sha2-0.10.2
	simplelog-0.11.2
	smallvec-1.8.0
	smartstring-1.0.1
	spin-0.5.2
	static_assertions-1.1.0
	strsim-0.10.0
	subtle-2.4.1
	syn-1.0.96
	termcolor-1.1.3
	textwrap-0.15.0
	thiserror-1.0.31
	thiserror-impl-1.0.31
	time-0.1.43
	time-0.3.9
	time-macros-0.2.4
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	typenum-1.15.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.0
	unicode-normalization-0.1.19
	untrusted-0.7.1
	ureq-2.4.0
	url-2.2.2
	version_check-0.9.4
	wasi-0.10.2+wasi-snapshot-preview1
	wasm-bindgen-0.2.80
	wasm-bindgen-backend-0.2.80
	wasm-bindgen-macro-0.2.80
	wasm-bindgen-macro-support-0.2.80
	wasm-bindgen-shared-0.2.80
	web-sys-0.3.57
	webpki-0.22.0
	webpki-roots-0.22.3
	which-4.2.5
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	zip-0.6.2
	zstd-0.10.2+zstd.1.5.2
	zstd-safe-4.1.6+zstd.1.5.2
	zstd-sys-1.6.3+zstd.1.5.2
"

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

inherit cargo

DESCRIPTION="setup tool for the memflow physical memory introspection framework"
HOMEPAGE="https://github.com/memflow/${PN}"
SRC_URI="https://github.com/memflow/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${MY_P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 CC0-1.0 ISC MIT MPL-2.0 MPL-2.0+ Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

S="${WORKDIR}/${MY_P}"