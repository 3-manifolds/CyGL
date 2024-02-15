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

cdef gl_strings = {
    'GL_VERSION' : _GL_VERSION,
    'GL_SHADING_LANGUAGE_VERSION' : _GL_SHADING_LANGUAGE_VERSION,
    }
    
def glGetString(gl_string_name):
    cdef const char *result
    try:
        result = <const char *> _glGetString(gl_strings[gl_string_name])
    except IndexError:
        raise ValueError('Unknown GL string %s' % gl_string_name)
    return result.decode('utf-8')

# We only need python wrappers for functions that will be called
# from user code.  Commenting these out for now.
# def glGenBuffer():
#     cdef GLuint buffer
#     _glGenBuffers(1, &buffer)
#     return buffer
#
# def glDeleteBuffer(GLuint buffer):
#     _glDeleteBuffers(1, &buffer)
#
# def glGenVertexArray():
#     cdef GLuint array
#     _glGenVertexArrays(1, &array)
#     return array
#
# def glDeleteVertexArray(GLuint array):
#     _glDeleteVertexArrays(1, &array)
#
# def glBindBuffer(GLenum target, GLuint buffer):
#     _glBindBuffer(_GL_ARRAY_BUFFER, buffer)
#
# def glBindVertexArray(GLuint array):
#     _glBindVertexArray(array)
#
# def glCreateShader(GLenum shaderType):
#     _glCreateShader(shaderType)
#
# def glShaderSource(GLuint shader, GLsizei count, string):
#     cdef GLint length = 0
#     cdef const GLchar * const *c_string = string
#     _glShaderSource(shader, count, c_string, &length)
#     return length
#
# def glCompileShader(GLuint shader):
#     _glCompileShader(shader)
#
# def glAttachShader(GLuint program, GLuint shader):
#     _glAttachShader(program, shader)
#
# def glLinkProgram(GLuint program):
#     _glLinkProgram(program)
#
# def glGetShaderiv(GLuint shader, GLenum pname, params):
#     cdef GLint *c_params = <GLint *>malloc(len(params)*sizeof(GLuint))
#     cdef int i
#     for i in range(len(params)):
#         c_params[i] = <int>params[i]
#     _glGetShaderiv(shader, pname, c_params)
#     free(c_params)
    
# def glGetShaderInfoLog(GLuint shader, GLsizei maxLength):
#      cdef GLsizei length
#      cdef GLchar *infoLog = <GLchar *>malloc(maxLength)
#      _glGetShaderInfoLog(shader, maxLength, &length, infoLog)
#      result = str(infoLog)
#      free(infoLog)
#      return result
     

#glEnable
#glBindBufferBase
#glBufferSubData
#glDrawElements
#glDrawArrays
