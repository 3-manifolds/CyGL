# cython: language_level=3str
# This file declares OpenGL functions which were deprecated in version 3.0
# and removed in version 3.2.
#

include "gl_types.pxi"

cdef extern from "gl_headers.h":
    void _glBegin "glBegin" (GLenum mode)
    void _glEnd "glEnd" ()
    void _glVertex2d "glVertex2d" (GLdouble x, GLdouble y )

# glColor*
# glNormal*
# glMatrixMode
# glFrustrum
# glOrtho
# glLoadIdentity
# glRotatef
# glTranslatef
# glScale*
# glLight*
# glLightModel
# glMaterial
# glPushMatrix
# glPopMatrix
