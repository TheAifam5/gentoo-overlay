EAPI=8

PYTHON_COMPAT=(python3_{10..14})

inherit meson python-single-r1

DESCRIPTION="An ultralightweight stacking window manager"
HOMEPAGE="https://github.com/Vladimir-csp/uwsm"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Vladimir-csp/uwsm.git"
else
	SRC_URI="https://github.com/Vladimir-csp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="uuctl uwsm-app fumon select wait-tray docs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pyxdg[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
	')
	sys-apps/dbus-broker
	sys-apps/util-linux
	select? ( dev-libs/newt )
	uwsm-app? ( x11-libs/libnotify )
	uuctl? (
		|| (
			gui-apps/walker
			gui-apps/fuzzel
			gui-apps/wofi
			|| ( x11-misc/rofi gui-apps/rofi-wayland gui-apps/rofi )
			gui-apps/tofi
			dev-libs/bemenu
			gui-apps/wmenu
			x11-misc/dmenu
		)
	)
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="
	docs? ( app-text/scdoc )
"

src_configure() {
	local emesonargs=(
		-Dpython-bin="${PYTHON}"
		$(meson_feature uuctl)
		$(meson_feature uwsm-app)
		$(meson_feature fumon)
		$(meson_feature wait-tray)
		$(meson_feature docs man-pages)
		-Ddocdir="/usr/share/doc/${PF}"
		-Dlicensedir="/usr/share/licenses/${PF}"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}/usr/bin"
	python_optimize "${ED}/usr/share/${PN}"
}

pkg_postinst() {
	elog "To properly configure uwsm, ensure that dbus-broker is used as the D-Bus daemon."
	elog "Consider running 'uwsm finalize' with the necessary environment variables after starting your compositor."
}
