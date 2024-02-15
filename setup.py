from setuptools import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import os
import sys
import platform

OpenGL_includes = []
OpenGL_extra_compile_args = []
OpenGL_extra_link_args = []

macOS_link_args = []

if sys.platform == 'darwin':
    OS_X_ver = int(platform.mac_ver()[0].split('.')[1])
    sdk_roots = [
        '/Library/Developer/CommandLineTools/SDKs',
        '/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs'
         ]
    version_strings = [ 'MacOSX10.%d.sdk' % OS_X_ver, 'MacOSX.sdk' ]
    poss_roots = [ '' ] + [
        '%s/%s' % (sdk_root, version_string)
        for sdk_root in sdk_roots
        for version_string in version_strings ]
    header_dir = '/System/Library/Frameworks/OpenGL.framework/Versions/Current/Headers/'
    poss_includes = [ root + header_dir for root in poss_roots ]
    OpenGL_includes += [ path for path in poss_includes if os.path.exists(path)][:1]
    OpenGL_extra_link_args = ['-framework', 'OpenGL']
    OpenGL_extra_link_args += macOS_link_args

elif sys.platform == 'win32':
    OpenGL_extra_link_args = ['opengl32.lib']

elif sys.platform == 'linux':
    OpenGL_extra_link_args = ['-lGL']

extensions = cythonize([
    # cythonize accepts a list of Extensions but their sources list
    # must have length 1.
    Extension(
        name="cygl.obsolete",
        sources=["src/cygl/obsolete.pyx"],
        include_dirs=OpenGL_includes,
        extra_link_args=OpenGL_extra_link_args,
        ),
    Extension(
        name="cygl.common",
        sources=["src/cygl/common.pyx"],
        include_dirs=OpenGL_includes,
        extra_link_args=OpenGL_extra_link_args,
        ),
    Extension(
        name="cygl.vectors",
        sources=["src/cygl/vectors.pyx"],
        ),
    Extension(
        name="cygl.hh",
        sources=["src/cygl/hh.pyx"],
        ),
    Extension(
        name="cygl.affine",
        sources=["src/cygl/affine.pyx"],
        ),
    Extension(
        name="cygl.vertex_array",
        sources=["src/cygl/vertex_array.pyx"],
        include_dirs=OpenGL_includes,
        extra_link_args=OpenGL_extra_link_args,
        ),
    Extension(
        name="cygl.program",
        sources=["src/cygl/program.pyx"],
        include_dirs=OpenGL_includes,
        extra_link_args=OpenGL_extra_link_args,
        ),
    Extension(
        name="cygl.gl_context",
        sources=["src/cygl/gl_context.pyx"],
        include_dirs=OpenGL_includes,
        extra_link_args=OpenGL_extra_link_args,
        ),
    ])

setup(
    ext_modules=extensions,
    packages=['cygl'],
    package_dir={'cygl':'src/cygl'}
)
