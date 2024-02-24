# cython: language_level=3str

cdef class Mat:
    cdef int _shape[2] # [columns, rows]
    cdef float* data
    cpdef shape(self)
