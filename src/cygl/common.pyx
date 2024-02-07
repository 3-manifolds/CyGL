# cython: language_level=3str

from cygl.common cimport *

GL_COLOR_BUFFER_BIT = _GL_COLOR_BUFFER_BIT
GL_QUADS = _GL_QUADS
GL_NO_ERROR = _GL_NO_ERROR

def glGetError():
    return _glGetError()
    
def glClearColor(GLclampf R, GLclampf G, GLclampf B, GLclampf A):
     _glClearColor(R, G, B, A)

def glClear(GLbitfield mask):
    _glClear(mask)

def glViewport(GLint x, GLint y, GLsizei width, GLsizei height):
     _glViewport(x, y, width, height)
