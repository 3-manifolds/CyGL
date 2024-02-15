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
        _GL_VERSION "GL_VERSION"
        _GL_SHADING_LANGUAGE_VERSION "GL_SHADING_LANGUAGE_VERSION"

    const GLubyte *_glGetString "glGetString" (GLenum name)
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
    void _glGetProgramiv "glGetProgramiv" (GLuint program, GLenum pname,
        GLint *params)
    void _glGetShaderiv  "glGetShaderiv" (GLuint shader, GLenum pname,
        GLint *params)
    void _glCompileShader "glCompileShader" (GLuint shader)
    void _glAttachShader "glAttachShader" (GLuint program, GLuint shader)
    void _glLinkProgram "glLinkProgram" (GLuint program)
    void _glGetShaderiv "glGetShaderiv" (GLuint shader, GLenum pname,
        GLint *params)
    void _glGetShaderInfoLog "glGetShaderInfoLog" (GLuint shader,
        GLsizei maxLength, GLsizei *length, GLchar *infoLog)
    void _glGetProgramInfoLog "glGetProgramInfoLog" (GLuint program,
        GLsizei maxLength, GLsizei *length, GLchar *infoLog)
    void _glUniform1iv "glUniform1iv" (GLint location, GLsizei count,
        const GLint *value)
    void _glUniform1f "glUniform1f" (GLint location, GLfloat v0)
    void _glUniform2f "glUniform2f" (GLint location, GLfloat v0, GLfloat v1)
    void _glUniform3f "glUniform3f" (GLint location, GLfloat v0, GLfloat v1,
        GLfloat v2)
    void _glUniform4f "glUniform4f" (GLint location, GLfloat v0, GLfloat v1,
        GLfloat v2, GLfloat v3)
    void _glUniform1i "glUniform1i" (GLint location, GLint v0)
    void _glUniform2i "glUniform2i" (GLint location, GLint v0, GLint v1)
    void _glUniform3i "glUniform3i" (GLint location, GLint v0, GLint v1,
        GLint v2)
    void _glUniform4i "glUniform4i" (GLint location, GLint v0, GLint v1,
        GLint v2, GLfloat v3)
    void _glUniform1fv "glUniform1fv" (GLint location, GLsizei count,
        const GLfloat *value)
    void _glUniform2fv "glUniform2fv" (GLint location, GLsizei count,
        const GLfloat *value)
    void _glUniform3fv "glUniform3fv"(GLint location, GLsizei count,
        const GLfloat *value)
    void _glUniform4fv "glUniform4fv" (GLint location, GLsizei count,
        const GLfloat *value)
    GLint _glGetUniformLocation "glGetUniformLocation"(GLuint program,
        const GLchar *name);
    void _glUniformMatrix2fv "glUniformMatrix2fv" (GLint location,
        GLsizei count, GLboolean transpose, const GLfloat *value)
    void _glUniformMatrix3fv "_glUniformMatrix3fv" (GLint location,
        GLsizei count, GLboolean transpose, const GLfloat *value);
    void _glUniformMatrix4fv "glUniformMatrix4fv" (GLint location,
        GLsizei count, GLboolean transpose, const GLfloat *value)
    void _glUniformMatrix2x3fv "glUniformMatrix2x3fv" (GLint location,
        GLsizei count, GLboolean transpose, const GLfloat *value)
    void _glUniformMatrix3x2fv "glUniformMatrix3x2fv" (GLint location,
        GLsizei count, GLboolean transpose, const GLfloat *value)
    void _glUniformMatrix2x4fv "glUniformMatrix2x4fv" (GLint location,
        GLsizei count, GLboolean transpose, const GLfloat *value)
    void _glUniformMatrix4x2fv "glUniformMatrix4x2fv" (GLint location,
        GLsizei count, GLboolean transpose, const GLfloat *value);
    void _glUniformMatrix3x4fv "glUniformMatrix3x4fv"(GLint location,
        GLsizei count, GLboolean transpose, const GLfloat *value);
    void _glUniformMatrix4x3fv "glUniformMatrix4x3fv"(GLint location,
        GLsizei count, GLboolean transpose, const GLfloat *value);
