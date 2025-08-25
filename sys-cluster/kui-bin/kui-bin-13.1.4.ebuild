# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="kui"

inherit desktop pax-utils xdg optfeature

DESCRIPTION="A hybrid command-line/UI development experience for cloud-native development"
HOMEPAGE="https://github.com/kubernetes-sigs/kui"
SRC_URI="
	amd64? ( https://github.com/kubernetes-sigs/kui/releases/download/v${PV}/Kui-linux-x64.zip -> ${P}-amd64.zip )
"
S="${WORKDIR}"

RESTRICT="mirror strip bindist"

LICENSE="
	Apache-2.0
	BSD
	BSD-1
	BSD-2
	BSD-4
	CC-BY-4.0
	ISC
	LGPL-2.1+
	MIT
	MPL-2.0
	openssl
	PYTHON
	TextMate-bundle
	Unlicense
	UoI-NCSA
	W3C
"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	sys-apps/util-linux
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libxshmfence
	x11-libs/pango
	|| ( sys-cluster/kind )
"

QA_PREBUILT="
	/opt/kui/chrome_crashpad_handler
	/opt/kui/chrome-sandbox
	/opt/kui/Kui
	/opt/kui/kubectl-kui
	/opt/kui/libEGL.so
	/opt/kui/libffmpeg.so
	/opt/kui/libGLESv2.so
	/opt/kui/libvk_swiftshader.so
	/opt/kui/libvulkan.so*
	/opt/kui/resources/app/extensions/*
	/opt/kui/resources/app/node_modules.asar.unpacked/*
	/opt/kui/swiftshader/libEGL.so
	/opt/kui/swiftshader/libGLESv2.so
"

src_install() {
	if use amd64; then
		cd "${WORKDIR}/Kui-linux-x64" || die
	elif use arm; then
		cd "${WORKDIR}/Kui-linux-armhf" || die
	elif use arm64; then
		cd "${WORKDIR}/Kui-linux-arm64" || die
	else
		die "Kui only supports amd64, arm and arm64"
	fi

	# Install
	pax-mark m Kui
	pax-mark m kubectl-kui
	insinto "/opt/${MY_PN}"
	doins -r *
	fperms +x /opt/${MY_PN}/Kui
	fperms +x /opt/${MY_PN}/kubectl-kui
	fperms +x /opt/${MY_PN}/chrome_crashpad_handler
	fperms 4711 /opt/${MY_PN}/chrome-sandbox
	fperms +x /opt/${MY_PN}/resources/app/dist/build/Release/spawn-helper
	dosym "../../opt/${MY_PN}/Kui" "usr/bin/kui"
	dosym "../../opt/${MY_PN}/kubectl-kui" "usr/bin/kubectl-kui"
	domenu "${FILESDIR}/kui.desktop"
	newicon "resources/app/node_modules/@kui-shell/build/icons/svg/kui.svg" "kui.png"
}

pkg_postinst() {
	xdg_pkg_postinst
}
