# cython: language_level=3str

include "gltypes.pxi"

cdef extern from "gl_headers.h":
    # ctypedef unsigned int GLenum
    # ctypedef unsigned char GLboolean
    # ctypedef unsigned int GLbitfield
    # ctypedef void GLvoid
    # ctypedef signed char GLbyte
    # ctypedef short GLshort
    # ctypedef int GLint
    # ctypedef unsigned char GLubyte
    # ctypedef unsigned short GLushort
    # ctypedef unsigned int GLuint
    # ctypedef int GLsizei
    # ctypedef float GLfloat
    # ctypedef float GLclampf
    # ctypedef double GLdouble
    # ctypedef double GLclampd
    # ctypedef char GLchar
    # ctypedef void* GLintptr
    # ctypedef void* GLsizeiptr

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
    void _glBegin "glBegin" (GLenum mode)
    void _glEnd "glEnd" ()
    void _glVertex2d "glVertex2d" (GLdouble x, GLdouble y )
