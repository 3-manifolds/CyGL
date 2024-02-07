# cython: language_level=3str

include "gl_types.pxi"

cdef extern from "gl_headers.h":
    enum:
        _GL_COLOR_BUFFER_BIT "GL_COLOR_BUFFER_BIT"
        _GL_QUADS "GL_QUADS"
        _GL_NO_ERROR "GL_NO_ERROR"
    GLenum _glGetError "glGetError" ()
    void _glClearColor "glClearColor" (
        GLclampf R, GLclampf G, GLclampf B, GLclampf A)
    void _glClear "glClear" (GLbitfield mask )
    void _glViewport "glViewport" (
        GLint x, GLint y, GLsizei width, GLsizei height)
