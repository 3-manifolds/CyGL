#ifdef _WIN32
#include "windows.h"
#include "wingdi.h"
#include "GL/gl.h"
#endif

#ifdef __linux
#include "GL/gl.h"
#endif

#ifdef __APPLE__
#include "gltypes.h"
#include "gl.h"
/* Declarations missing from Apple's headers */
extern void glGenVertexArrays(GLsizei n, GLuint *arrays);
extern void glBindVertexArray(GLuint array);
extern void glDeleteVertexArrays(GLsizei n, const GLuint *arrays);
#endif
