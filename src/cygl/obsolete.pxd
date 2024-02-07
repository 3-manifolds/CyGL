# cython: language_level=3str

include "gl_types.pxi"

cdef extern from "gl_headers.h":
    void _glBegin "glBegin" (GLenum mode)
    void _glEnd "glEnd" ()
    void _glVertex2d "glVertex2d" (GLdouble x, GLdouble y )
