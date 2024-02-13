include "gl_types.pxi"

cdef class VertexArray:
    cdef GLuint vbo
    cdef int vbo_size
    cdef GLfloat *vbo_data
    cdef GLuint vao
    cdef int record_size
    cdef int record_count
    cdef public attribute_size
    cdef public gl_attributes
    cdef public vertex_defaults
    cpdef _save_vertex(self, vertex)
    cdef init_array(self)
