
cdef class VertexArray:
    cdef int vbo
    cdef int vbo_size
    cdef float *vbo_data
    cdef int vao
    cdef int record_size
    cdef int record_count
    cdef public attribute_size
    cdef public gl_attributes
    cdef public vertex_defaults
    cpdef _save_vertex(self, vertex)
    cdef init_array(self)
