# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/virglrenderer.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/virgl/${PN}/-/archive/${PV}/${P}.tar.bz2"
	S="${WORKDIR}/${P}"

	KEYWORDS="~amd64"
fi

DESCRIPTION="VirGL virtual OpenGL renderer."
HOMEPAGE="https://virgil3d.github.io/"

LICENSE="MIT"
SLOT="0"
IUSE="static-libs +egl glx minigbm-allocation venus venus-validate +check-gl-errors drm-renderer-msm drm-renderer-amdgpu-experimental +render-server-worker-process render-server-worker-thread render-server-worker-minijail video tests valgrind tracing-percetto tracing-perfetto tracing-sysprof tracing-stderr unstable-apis"

RDEPEND="
	>=x11-libs/libdrm-2.4.50
	>=media-libs/libepoxy-1.5.4
	render-server-worker-minijail? ( sys-apps/minijail )
	venus? (
		media-libs/vulkan-loader
		gui-libs/egl-gbm[${MULTILIB_USEDEP}]
	)
	minigbm-allocation? ( gui-libs/egl-gbm )
	video? (
		media-libs/libva
		media-libs/libva-compat[drm,egl?]
		glx? ( media-libs/libva-compat[opengl] )
	)
	glx? ( x11-libs/libX11 )
"

DEPEND="${RDEPEND}"

BDEPEND="
	glx? ( x11-base/xorg-proto )
	dev-build/meson-format-array
	virtual/pkgconfig
"

REQUIRED_USE="
	|| ( egl glx )
	?? ( tracing-percetto tracing-perfetto tracing-sysprof tracing-stderr )
	?? ( render-server-worker-process render-server-worker-thread render-server-worker-minijail )
"

# Most of the testsuite cannot run in our sandboxed environment, just don't
# deal with it for now.
RESTRICT="test"

src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		$(meson_use minigbm-allocation minigbm_allocation)
		$(meson_use venus)
		$(meson_use check-gl-errors)
		$(meson_use video)
		$(meson_use tests)
		$(meson_use valgrind)
		$(meson_use unstable-apis)
	)

	local platforms=()
	if use glx; then
		platforms+=(glx)
	fi
	if use egl; then
		platforms+=(egl)
	fi

	if [ ${#platforms[@]} -gt 0 ]; then
		emesonargs+=(-Dplatforms="$(
			IFS=,
			echo "${platforms[*]}"
		)")
	else
		die "No platform selected"
	fi

	if use venus; then
		emesonargs+=($(meson_use venus-validate))
	else
		emesonargs+=(-Dvenus-validate=false)
	fi

	local drm_renderers=()
	if use drm-renderer-msm; then
		drm_renderers+=(msm)
	fi

	if use drm-renderer-amdgpu-experimental; then
		drm_renderers+=(amdgpu-experimental)
	fi

	if [ ${#drm_renderers[@]} -gt 0 ]; then
		emesonargs+=(-Ddrm-renderers="$(
			IFS=,
			echo "${drm_renderers[*]}"
		)")
	fi

	if use render-server-worker-minijail; then
		emesonargs+=(-Drender-server-worker="minijail")
	elif use render-server-worker-thread; then
		emesonargs+=(-Drender-server-worker="thread")
	elif use render-server-worker-process; then
		emesonargs+=(-Drender-server-worker="process")
	else
		die "No render-server-worker selected"
	fi

	if use tracing-percetto; then
		emesonargs+=(-Dtracing=percetto)
	elif use tracing-perfetto; then
		emesonargs+=(-Dtracing=perfetto)
	elif use tracing-sysprof; then
		emesonargs+=(-Dtracing=sysprof)
	elif use tracing-stderr; then
		emesonargs+=(-Dtracing=stderr)
	else
		emesonargs+=(-Dtracing=none)
	fi

	meson-multilib_src_configure
}

src_install() {
	meson-multilib_src_install
	find "${ED}/usr" -name 'lib*.la' -delete
}
