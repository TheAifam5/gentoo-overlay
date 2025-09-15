# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit meson python-any-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/virglrenderer.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/virgl/${PN}/-/archive/${PV}/${P}.tar.bz2"
	S="${WORKDIR}/${P}"

	KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
fi

DESCRIPTION="VirGL virtual OpenGL renderer."
HOMEPAGE="https://virgil3d.github.io/"

LICENSE="MIT"
SLOT="0"
IUSE="static-libs test +egl glx minigbm-allocation venus venus-validate vulkan-dload vulkan-preload +check-gl-errors video_cards_asahi video_cards_freedreno video_cards_amdgpu +render-server-worker-process render-server-worker-thread render-server-worker-minijail vaapi valgrind tracing-percetto tracing-perfetto tracing-sysprof tracing-stderr unstable-apis"

RDEPEND="
	>=x11-libs/libdrm-2.4.50
	>=media-libs/libepoxy-1.5.4
	render-server-worker-minijail? ( sys-apps/minijail )
	venus? (
		media-libs/vulkan-loader
		gui-libs/egl-gbm
	)
	minigbm-allocation? ( gui-libs/egl-gbm )
	vaapi? (
		media-libs/libva:=
		media-libs/libva-compat[drm,egl?]
		glx? ( media-libs/libva-compat[opengl] )
	)
	glx? ( x11-libs/libX11 )
"

DEPEND="${RDEPEND}"

BDEPEND="
	glx? ( x11-base/xorg-proto )
	venus? (
		!vulkan-dload? ( media-libs/vulkan-loader )
	)
	dev-build/meson-format-array
	virtual/pkgconfig
	${PYTHON_DEPS}
	$(python_gen_any_dep "
		dev-python/pyyaml[\${PYTHON_USEDEP}]
	")
"

REQUIRED_USE="
	|| ( egl glx )
	?? ( tracing-percetto tracing-perfetto tracing-sysprof tracing-stderr )
	?? ( render-server-worker-process render-server-worker-thread render-server-worker-minijail )
"

RESTRICT="!test? ( test )"

python_check_deps() {
	python_has_version -b "dev-python/pyyaml[${PYTHON_USEDEP}]" || return 1
}

src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		$(meson_use minigbm-allocation minigbm_allocation)
		$(meson_use venus)
		$(meson_use vulkan-dload)
		$(meson_use vulkan-preload)
		$(meson_use check-gl-errors)
		$(meson_use vaapi video)
		$(meson_use test tests)
		$(meson_use valgrind)
		$(meson_use unstable-apis)
	)

	local -a platforms=()
	if use glx; then
		platforms+=(glx)
	fi
	if use egl; then
		platforms+=(egl)
	fi

	if [ ${#platforms[@]} -gt 0 ]; then
		emesonargs+=(-Dplatforms="$(IFS=,; echo "${platforms[*]}")")
	else
		die "No platform selected"
	fi

	if use venus; then
		emesonargs+=($(meson_use venus-validate))
	else
		emesonargs+=(-Dvenus-validate=false)
	fi

	local drm_renderers=()
	if use video_cards_freedreno; then
		drm_renderers+=(msm)
	fi

	if use video_cards_amdgpu; then
		drm_renderers+=(amdgpu-experimental)
	fi

	if use video_cards_asahi; then
		drm_renderers+=(asahi)
	fi

	if [ ${#drm_renderers[@]} -gt 0 ]; then
		emesonargs+=(-Ddrm-renderers="$(IFS=,; echo "${drm_renderers[*]}")")
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

	meson_src_configure
}

src_test() {
	# Most of the testsuite cannot run in our sandboxed environment, just don't
	# deal with it for now.  Instead lets run a subset of tests atleast.
	meson_src_test test_virgl_gbm_resources test_fuzzer_formats
}
