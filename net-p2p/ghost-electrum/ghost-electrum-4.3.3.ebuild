# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )
PYTHON_REQ_USE="ncurses?"

inherit distutils-r1 xdg-utils

DESCRIPTION="Lightweight Electrum wallet for Ghost Coin"
HOMEPAGE="https://ipfs.ghostbyjohnmcafee.com/#/"
SRC_URI="https://github.com/ghost-coin/ghost-electrum/archive/refs/tags/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cli ncurses qrcode test"
REQUIRED_USE="|| ( cli ncurses )"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/libsecp256k1
	>=dev-python/aiohttp-socks-0.3[${PYTHON_USEDEP}]
	=dev-python/aiorpcX-0.22*[${PYTHON_USEDEP}]
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	dev-python/bitstring[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	>=dev-python/dnspython-2[${PYTHON_USEDEP}]
	dev-python/pbkdf2[${PYTHON_USEDEP}]
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/qrcode[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.12[${PYTHON_USEDEP}]
	qrcode? ( media-gfx/zbar[v4l] )
	ncurses? ( $(python_gen_impl_dep 'ncurses') )
"
BDEPEND="
	test? (
		dev-python/pyaes[${PYTHON_USEDEP}]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
	)
"
S="${WORKDIR}/ghost-electrum-${PV}"
distutils_enable_tests pytest

src_prepare() {
	# use backwards-compatible cryptodome API
	sed -i -e 's:Cryptodome:Crypto:' electrum/crypto.py || die

	# make qdarkstyle dep optional
	sed -i -e '/qdarkstyle/d' contrib/requirements/requirements.txt || die
	bestgui=qt

	eapply_user

	xdg_environment_reset
	distutils-r1_src_prepare
}

src_install() {
	dodoc RELEASE-NOTES
	distutils-r1_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	elog "Run ${PN} with 'electrum' command."
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
