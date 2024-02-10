# cython: language_level=3str

cdef class Vec:
    cdef int _size
    cdef float *_v
    cdef int write(self, float *buffer)
