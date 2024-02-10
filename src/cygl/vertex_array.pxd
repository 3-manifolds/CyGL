
cdef class VertexArray:
    cdef int buffer_size
    cdef float *buffer_data
    cdef int record_size
    cdef int record_count
    cdef attribute_size
    cdef public Vertex
    cdef public gl_attributes
    cdef save_vertex(self, vertex)
