# cython: language_level=3str

from cython.cimports.libc.stdlib import malloc, free
from cygl.common cimport *

GL_COLOR_BUFFER_BIT = _GL_COLOR_BUFFER_BIT
GL_QUADS = _GL_QUADS
GL_NO_ERROR = _GL_NO_ERROR
GL_ARRAY_BUFFER = _GL_ARRAY_BUFFER

def glGetError():
    return _glGetError()
    
def glClearColor(GLclampf R, GLclampf G, GLclampf B, GLclampf A):
     _glClearColor(R, G, B, A)

def glClear(GLbitfield mask):
    _glClear(mask)

def glViewport(GLint x, GLint y, GLsizei width, GLsizei height):
     _glViewport(x, y, width, height)

# The GL functions glGenBuffers and glDeleteBuffers are
# replaced by glGenBuffer and glDeleteBuffer which deal with
# only one buffer at a time.

def glGenBuffer():
    cdef GLuint buffer
    _glGenBuffers(1, &buffer)
    return buffer

def glDeleteBuffer(GLuint buffer):
    _glDeleteBuffers(1, &buffer)

def glGenVertexArray():
    cdef GLuint array
    _glGenVertexArrays(1, &array)
    return array

def glDeleteVertexArray(GLuint array):
    _glDeleteVertexArrays(1, &array)

def glBindBuffer(GLenum target, GLuint buffer):
    _glBindBuffer(_GL_ARRAY_BUFFER, buffer)

def glBindVertexArray(GLuint array):
    _glBindVertexArray(array)
        
#glEnable

#glBindBufferBase
#glBufferSubData
#glDrawElements
#glDrawArrays
#glAttachShader
#glCompileShader
#glLinkProgram
