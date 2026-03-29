################################################################################
#
# itisimplecal
#
################################################################################

ITISIMPLECAL_VERSION = 1.0
ITISIMPLECAL_SITE = $(ITISIMPLECAL_PKGDIR)
ITISIMPLECAL_SITE_METHOD = local
ITISIMPLECAL_DEPENDENCIES = qt6base qt6declarative
ITISIMPLECAL_INSTALL_TARGET = YES

ITISIMPLECAL_CONF_OPTS = \
	-DQT_HOST_PATH=$(HOST_DIR)

$(eval $(cmake-package))
