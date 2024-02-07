# cython: language_level=3str
from libc.math cimport sqrt

cdef class vec3():
    cdef float _v[3]

    def __init__(self, float x, float y, float z):
        self._v[0] = x
        self._v[1] = y
        self._v[2] = z

    def __iter__(self):
        return (self._v[0], self._v[1], self._v[2]).__iter__()

    def __getitem__(self, int key):
        if key < -3 or key > 2:
            raise IndexError
        if key < 0:
            return self._v[3 + key]
        return self._v[key] 

    def __setitem__(self, int key, float value):
        if key < -3 or key > 2:
            raise IndexError
        if key < 0:
            key += 3
        self._v[key] = value

    def __add__(self, vec3 other):
        cdef float *L = self._v
        cdef float *R = other._v
        return vec3(L[0] + R[0], L[1] + R[1], L[2] + R[2])

    def __sub__(self, vec3 other):
        cdef float *L = self._v
        cdef float *R = other._v
        return vec3(L[0] - R[0], L[1] - R[1], L[2] - R[2])

    def __xor__(self, vec3 other):
        cdef float *L = self._v
        cdef float *R = other._v
        return vec3(L[1] * R[2] - L[2] * R[1],
                    L[2] * R[0] - L[0] * R[2],
                    L[0] * R[1] - L[1] * R[0])
            
    def __matmul__(self, vec3 other):
        cdef float *L = self._v
        cdef float *R = other._v
        return L[0] * R[0] + L[1] * R[1] + L[2] * R[2]

    def __mul__(self, float other):
        cdef float *v = self._v
        return vec3(other*v[0], other*v[1], other*v[2])

    def __rmul__(self, float other):
        cdef float *v = self._v
        return vec3(other*v[0], other*v[1], other*v[2])

    def __abs__(self):
        cdef float *v = self._v
        return sqrt(v[0] * v[0] + v[1] * v[1] +v[2] * v[2])

    def __len__(self):
        return 3

    def __repr__(self):
        return 'vec3(%f, %f, %f)' % (self._v[0], self._v[1], self._v[2])

    def __str__(self):
        return '<%f, %f, %f>' % (self._v[0], self._v[1], self._v[2])

    def normalized(self):
        cdef float *v = self._v
        cdef float norm = sqrt(v[0]*v[0] + v[1] * v[1] + v[2] * v[2])
        if float == 0:
            raise ValueError('Cannot normalize the zero vector.')
        return vec3(v[0] / norm, v[1] / norm, v[2] / norm)
