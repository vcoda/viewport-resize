TEMPLATE = subdirs

SUBDIRS += \
    third-party/magma/projects/qt/magma.pro \
    framework \
    resize-sample

framework.depends = third-party/magma/projects/qt/magma.pro

resize-sample.depends += third-party/magma/projects/qt/magma.pro
resize-sample.depends += framework
