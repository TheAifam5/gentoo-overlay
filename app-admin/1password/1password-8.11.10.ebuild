# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature desktop xdg

if [[ "${PV}" == *_beta* ]]; then
  RELEASE="beta"
  MY_PV="${PV/_beta/-}.BETA"
else
  RELEASE="stable"
  MY_PV="${PV}"
fi

DESCRIPTION="The world’s most-loved password manager"
HOMEPAGE="https://1password.com"
SRC_URI="
	amd64? ( https://downloads.1password.com/linux/tar/${RELEASE}/x86_64/${PN}-${MY_PV}.x64.tar.gz -> ${P}-amd64.tar.gz )
	arm64? ( https://downloads.1password.com/linux/tar/${RELEASE}/aarch64/${PN}-${MY_PV}.arm64.tar.gz -> ${P}-arm64.tar.gz )"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="policykit cli"
RESTRICT="mirror strip test bindist"

DEPEND="
	acct-group/onepassword
	policykit? ( sys-auth/polkit )
	cli? ( app-admin/op-cli-bin )
"
RDEPEND="
	${DEPEND}
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-crypt/libsecret[crypt]
	app-misc/ca-certificates
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/libglvnd
	media-libs/mesa
	net-misc/curl
	sys-apps/dbus
	sys-libs/zlib
	sys-process/lsof
	x11-libs/cairo
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
	x11-libs/libXScrnSaver
	x11-libs/pango
	x11-misc/xdg-utils
"

QA_PREBUILT="usr/bin/${MY_PN} opt/1Password/*"

src_prepare() {
	default
	xdg_environment_reset
}

src_install() {
	mkdir -p "${D}/opt/1Password/"
	cp -ar "${S}/${PN}-"**"/"* "${D}/opt/1Password/" || die "Install failed!"

	# Fill in policy kit file with a list of (the first 10) human users of
	# the system.
	mkdir -p "${D}/usr/share/polkit-1/actions/"
	export POLICY_OWNERS
	POLICY_OWNERS="$(cut -d: -f1,3 /etc/passwd | grep -E ':[0-9]{4}$' | cut -d: -f1 | head -n 10 | sed 's/^/unix-user:/' | tr '\n' ' ')"
	eval "cat <<EOF
$(cat "${D}/opt/1Password/com.1password.1Password.policy.tpl")
EOF" >"${D}/usr/share/polkit-1/actions/com.1password.1Password.policy"
	chmod 644 "${D}/usr/share/polkit-1/actions/com.1password.1Password.policy"

	dosym /opt/1Password/1password /usr/bin/1password
	dosym /opt/1Password/op-ssh-sign /usr/bin/op-ssh-sign

	dosym /opt/1Password/resources/1password.desktop "/usr/share/applications/${PN}.desktop"
	desktop-file-edit --set-key=Exec --set-value="/usr/bin/1password %U" "${D}/usr/share/applications/${PN}.desktop"

	resolutions=(32x32 64x64 256x256 512x512)
	for resolution in "${resolutions[@]}"; do
		newicon -s "${resolution}" "${D}/opt/1Password/resources/icons/hicolor/${resolution}/apps/1password.png" "${PN}.png"
	done

	dodoc "${D}/opt/1Password/resources/custom_allowed_browsers"

	rm "${D}/opt/1Password/after-install.sh" || die
	rm "${D}/opt/1Password/after-remove.sh" || die
	rm "${D}/opt/1Password/install_biometrics_policy.sh" || die
	rm "${D}/opt/1Password/com.1password.1Password.policy.tpl" || die
	rm -r "${D}/opt/1Password/resources/icons" || die
}

pkg_postinst() {
	# chrome-sandbox requires the setuid bit to be specifically set.
	# See https://github.com/electron/electron/issues/17972
	chmod 4755 /opt/1Password/chrome-sandbox

	# This gives no extra permissions to the binary. It only hardens it against environmental tampering.
	chgrp onepassword /opt/1Password/1Password-BrowserSupport
	chmod g+s /opt/1Password/1Password-BrowserSupport

	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
