# cython: language_level=3str

cdef class Vec:
    cdef int _size
    cdef float *_v
    cdef int write(self, float *buffer)

cdef class Vec1(Vec):
    cdef float _data

cdef class Vec2(Vec):
    cdef float _data[2]

cdef class Vec3(Vec):
    cdef float _data[3]

cdef class Vec4(Vec):
    cdef float _data[4]
