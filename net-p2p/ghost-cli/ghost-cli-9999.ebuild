# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="CLI for Ghost by John McAfee privacy coin"
HOMEPAGE="https://ipfs.ghostbyjohnmcafee.com/#/"
EGIT_REPO_URI="https://github.com/ghost-coin/ghost-core.git"

LICENSE="MIT"
SLOT="0"

IUSE="+asm +hardened ccache test"

RDEPEND="
	dev-libs/boost:=
	dev-libs/libevent:=
"

DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/automake-1.13
	|| ( >=sys-devel/gcc-7[cxx] >=sys-devel/clang-5 )
	ccache? ( dev-util/ccache )
"

RESTRICT="!test? ( test )"

pkg_pretend() {
	if use ccache; then
	ewarn "Make sure to configure Portage accordingly"
	ewarn "to be able to use ccache."
	ewarn "https://wiki.gentoo.org/wiki/Ccache"
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local my_econf=(
		$(use_enable asm)
		$(use_enable test tests)
		$(use_enable hardened hardening)
		$(use_enable ccache ccache)
		--disable-wallet
		--enable-util-cli
		--without-qrencode
		--without-qtdbus
		--disable-zmq
		--without-gui
		--disable-util-tx
		--disable-util-util
		--disable-util-wallet
		--without-daemon
		--disable-bench
		--without-libs
		--disable-static
	)
	econf "${my_econf[@]}"
}

src_install() {
	default
}

pkg_postinst() {
	elog "To get ${PN} running on Musl-based systems,"
	elog "make sure to set LC_ALL=\"C\" environment variable."
}
