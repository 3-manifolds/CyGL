# cython: language_level=3str

from cygl.vectors cimport Vec3

cdef class Quaternion():
    cdef float _re
    cdef Vec3  _im
