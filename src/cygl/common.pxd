# cython: language_level=3str
# This file declares OpenGL functions which are available in all
# versions of OpenGL.

include "gl_types.pxi"

cdef extern from "gl_headers.h":
    enum:
        _GL_COLOR_BUFFER_BIT "GL_COLOR_BUFFER_BIT"
        _GL_QUADS "GL_QUADS"
        _GL_NO_ERROR "GL_NO_ERROR"
        _GL_ARRAY_BUFFER "GL_ARRAY_BUFFER"

    GLenum _glGetError "glGetError" ()
    void _glClearColor "glClearColor" (
        GLclampf R, GLclampf G, GLclampf B, GLclampf A)
    void _glClear "glClear" (GLbitfield mask )
    void _glViewport "glViewport" (
        GLint x, GLint y, GLsizei width, GLsizei height)
    void _glGenBuffers "glGenBuffers" (GLsizei n, GLuint* buffers)
    void _glDeleteBuffers "glDeleteBuffers" (GLsizei n, GLuint* buffers)
    void _glBindBuffer "glBindBuffer" (GLenum target, GLuint buffer)
    void _glGenVertexArrays "glGenVertexArrays" (GLsizei n, GLuint* arrays)
    void _glDeleteVertexArrays "glDeleteVertexArrays" (GLsizei n, GLuint* arrays)
    void _glBindVertexArray "glBindVertexArray" (GLuint array)
    void _glVertexAttribPointer "glVertexAttribPointer" (GLuint index, GLint size,
        GLenum type, GLboolean normalized, GLsizei stride, const void * pointer);
