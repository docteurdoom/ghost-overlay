# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="CLI for Ghost by John McAfee privacy coin"
HOMEPAGE="https://ipfs.ghostbyjohnmcafee.com/#/"
SRC_URI="https://github.com/ghost-coin/ghost-core/archive/refs/tags/v${PV}.tar.gz -> ghost-core-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

IUSE="+asm +hardened ccache test"

RDEPEND="
	dev-libs/boost:=
	dev-libs/libevent:=
	ccache? (
			dev-util/ccache
		)
"

DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/automake-1.13
	|| ( >=sys-devel/gcc-7[cxx] >=sys-devel/clang-5 )
"

RESTRICT="!test? ( test )"

S="${WORKDIR}/ghost-core-${PV}"

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
