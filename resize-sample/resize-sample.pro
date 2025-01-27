QT += widgets

TEMPLATE = app
CONFIG += console c++17
CONFIG -= app_bundle

SOURCES += \
        viewport-resize.cpp

INCLUDEPATH += $(VULKAN_SDK)/include
INCLUDEPATH += ../third-party/

QMAKE_CXXFLAGS += -std=c++17 -msse4 -ftemplate-depth=2048 -fconstexpr-depth=2048
QMAKE_CXXFLAGS += -Wno-unknown-pragmas
QMAKE_CXXFLAGS += -Wno-deprecated-copy
QMAKE_CXXFLAGS += -Wno-unused-but-set-variable
QMAKE_CXXFLAGS += -Wno-missing-field-initializers

QMAKE_CXXFLAGS += -DQT_NO_FOREACH

win32 {
    QMAKE_CXXFLAGS += -DVK_USE_PLATFORM_WIN32_KHR
} else:macx {
    QMAKE_CXXFLAGS += -DVK_USE_PLATFORM_MACOS_MVK
} else:unix {
    QMAKE_CXXFLAGS += -DVK_USE_PLATFORM_XCB_KHR
} else:android {
    QMAKE_CXXFLAGS += -DVK_USE_PLATFORM_ANDROID_KHR
} else:ios {
    QMAKE_CXXFLAGS += -DVK_USE_PLATFORM_IOS_MVK
}

GLSLC=$(VULKAN_SDK)/bin/glslangValidator

defineReplace(compileShader) {
    GLSL_FILE = $$PWD/$$1
    SPIRV_FILE = $$PWD/$$2
    !exists($$GLSL_FILE): error(Missing GLSL shader file $$GLSL_FILE)
    !exists($$SPIRV_FILE): return($$GLSLC -V $$GLSL_FILE -o $$SPIRV_FILE$$escape_expand(\\n\\t))
    return
}

compile_shaders.target = compile_shaders
compile_shaders.commands += $$compileShader(transform.vert, transform.o)
compile_shaders.commands += $$compileShader(frontFace.frag, frontFace.o)

QMAKE_EXTRA_TARGETS = compile_shaders
PRE_TARGETDEPS = compile_shaders

LIBS += -L$(VULKAN_SDK)/Lib
CONFIG(debug, debug|release) {
    LIBS += -L../framework/debug
    LIBS += -L../third-party/magma/projects/qt/debug
} else {
    LIBS += -L../framework/release
    LIBS += -L../third-party/magma/projects/qt/release
}
LIBS += -lframework -lmagma -lvulkan-1
