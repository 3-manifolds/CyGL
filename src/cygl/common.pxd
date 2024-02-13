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
        _GL_INFO_LOG_LENGTH "GL_INFO_LOG_LENGTH"
        _GL_COMPILE_STATUS "GL_COMPILE_STATUS"

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
        GLenum type, GLboolean normalized, GLsizei stride, const void *pointer);
    # Khronos says these are supported in OpenGL 2.0 so I am putting them here.
    GLuint _glCreateShader "glCreateShader" (GLenum shaderType);
    void _glShaderSource "glShaderSource" (GLuint shader, GLsizei count,
        const GLchar * const *string, const GLint *length)
    void _glCompileShader "glCompileShader" (GLuint shader)
    void _glAttachShader "glAttachShader" (GLuint program, GLuint shader)
    void _glLinkProgram "glLinkProgram" (GLuint program)
    void _glGetShaderiv "glGetShaderiv" (GLuint shader, GLenum pname, GLint *params)
    void _glGetShaderInfoLog "glGetShaderInfoLog" (GLuint shader,
        GLsizei maxLength, GLsizei *length, GLchar *infoLog)
