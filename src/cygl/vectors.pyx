# cython: language_level=3str

"""
The classes Vec1, Vec2, Vec3 and Vec4 all support basic vector
operations. The * operator is scalar multiplication, which can be done
on either side.  The + and - operators represent vector addition and
subtraction. The operator @ represents the dot product, even though
it is commutative, since it is a matrix multiplication after
transposing one side.

The Vec3 class also supports the cross product. We identify R^3 with
its dual using their standard bases.  With these identifications the
wedge product on the dual agrees with the cross product.  Therefore we
implement the operator ^ as the cross product and.
"""

from libc.math cimport sqrt
from cygl.vectors cimport *

cdef class Vec:
    cdef int write(self, float *buffer):
        cdef int i
        for i in range(self._size):
            buffer[i] = self._v[i]
        return self._size

    def __len__(self):
        return self._size

    def __getitem__(self, int key):
        if key < -self._size or key >= self._size:
            raise IndexError
        if key < 0:
            return self._v[self._size + key]
        return self._v[key] 

    def __setitem__(self, int key, float value):
        if key < -self._size or key >= self._size:
            raise IndexError
        if key < 0:
            key += self._size
        self._v[key] = value

    def __iter__(self):
        cdef int i
        # One day we might do this right.
        return tuple(self._v[i] for i in range(self._size)).__iter__()

    def __add__(self, Vec other):
        cdef int i
        cdef float *L = self._v
        cdef float *R = other._v
        return self.__class__(*tuple(L[i] + R[i] for i in range(self._size)))

    def __sub__(self, Vec other):
        cdef int i
        cdef float *L = self._v
        cdef float *R = other._v
        return self.__class__(*(L[i] - R[i] for i in range(self._size)))

    def __mul__(self, float other):
        cdef int i
        cdef float *v = self._v
        return self.__class__(*(other*v[i] for i in range(self._size)))

    def __rmul__(self, float other):
        cdef int i
        cdef float *v = self._v
        return self.__class__(*(other*v[i] for i in range(self._size)))

    def __matmul__(self, Vec other):
        if self._size != other._size:
            raise TypeError('Vectors have different sizes.')
        cdef float *L = self._v
        cdef float *R = other._v
        cdef float result = 0
        cdef int i
        for i in range(self._size):
            result += L[i]*R[i]
        return result

    def __neg__(self):
        return self.__class__(*(-self._v[i] for i in range(self._size)))

    def __abs__(self):
        cdef int i
        cdef float *v = self._v
        return sqrt(sum(v[i] * v[i] for i in range(self._size)))

    def __repr__(self):
        return '<%s>'%', '.join(str(self._v[i]) for i in range(self._size))

    __str__ = __repr__

cdef class Vec1(Vec):
    def __init__(self, float x=0.0):
        self._size = 2
        self._v = self._data
        self._v[0] = x

cdef class Vec2(Vec):
    def __init__(self, float x=0.0, float y=0.0):
        cdef int i
        self._size = 2
        self._v = self._data
        self._v[0] = x
        self._v[1] = y

cdef class Vec4(Vec):
    def __init__(self, float x=0.0, float y=0.0, float z=0.0, float w=1.0):
        self._size = 4
        self._v = self._data
        self._v[0] = x
        self._v[1] = y
        self._v[2] = z
        self._v[3] = w

cdef class Vec3(Vec):        
    def __init__(self, float x=0.0, float y=0.0, float z=0.0):
        self._size = 3
        self._v = self._data
        self._v[0] = x
        self._v[1] = y
        self._v[2] = z

    def __add__(self, Vec3 other):
        cdef float *L = self._v
        cdef float *R = other._v
        return Vec3(L[0] + R[0], L[1] + R[1], L[2] + R[2])

    def __sub__(self, Vec3 other):
        cdef float *L = self._v
        cdef float *R = other._v
        return Vec3(L[0] - R[0], L[1] - R[1], L[2] - R[2])

    def __xor__(self, Vec3 other):
        cdef float *L = self._v
        cdef float *R = other._v
        return Vec3(L[1] * R[2] - L[2] * R[1],
                    L[2] * R[0] - L[0] * R[2],
                    L[0] * R[1] - L[1] * R[0])

    def __mul__(self, float other):
        cdef float *v = self._v
        return Vec3(other*v[0], other*v[1], other*v[2])

    def __rmul__(self, float other):
        cdef float *v = self._v
        return Vec3(other*v[0], other*v[1], other*v[2])

    def __abs__(self):
        cdef float *v = self._v
        return sqrt(v[0] * v[0] + v[1] * v[1] +v[2] * v[2])

    def __neg__(self):
        return Vec3(-self._v[0], -self._v[1], -self._v[2])

    def normalized(self):
        cdef float *v = self._v
        cdef float norm = sqrt(v[0]*v[0] + v[1] * v[1] + v[2] * v[2])
        if float == 0:
            raise ValueError('Cannot normalize the zero vector.')
        return Vec3(v[0] / norm, v[1] / norm, v[2] / norm)
