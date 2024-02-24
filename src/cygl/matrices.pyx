# cython: language_level=3str
from libc.math cimport sin, cos
from cygl.hh cimport *
from cygl.hh import q_1, q_I, q_J, q_K
from cygl.vectors cimport *

cdef class Mat:
    cpdef shape(self):
        return tuple(self._shape)

    def __init__(self, value=None):
        cdef int i, j
        cdef int columns, rows
        if value is None:
            return
        columns, rows = self._shape
        # input data is in row major order because it looks better.
        for i in range(rows):
            for j in range(columns):
                self.data[j*rows + i] = value[i][j]

cdef class Mat4(Mat):
    # stored in column major order so it can be copied directly to GL
    cdef float m[16]

    def __cinit__(self):
        self._shape[0] = 4
        self._shape[1] = 4
        self.data = &self.m[0]

    def __mul__(self, Vec other):
        cdef Vec4 rhs
        cdef int i, j
        cdef Vec4 result = Vec4()
        cdef int dim = len(other)
        if dim == 4:
            rhs = other
        elif dim == 3:
            rhs = Vec4(*other, 1.0)
        for i in range(4):
            for j in range(4):
                result._v[i] += self.data[i + 4*j] * rhs._v[j]
        return result

    def __matmul__(self, Mat4 other):
        cdef int i, j, k
        cdef Mat4 result = Mat4()
        for i in range(4):
            for j in range(4):
                for k in range(4):
                    result.data[i + 4*j] += (
                        self.data[i + 4*k] * other.data[k + 4*j])
        return result

    def __repr__(self):
        cdef int i, j
        cdef int columns, rows
        columns, rows = self._shape
        result = '\n'.join([str([self.m[j*rows + i] for j in range(columns)])
                                for i in range(rows)])
        return result

    @classmethod
    def identity(cls):
        cdef int i
        cdef Mat result = cls()
        for i in range(4):
            result.data[5*i] = 1.0
        return result

    @classmethod
    def translation(cls, float x, float y, float z):
        cdef Mat result = cls()
        for i in range(4):
            result.data[5*i] = 1.0
        result.data[12] = x
        result.data[13] = y
        result.data[14] = z
        return result

    @classmethod
    def rotation(cls, float x, float y, float z, float a):
        cdef Mat result = cls()
        cdef Vec3 axis = Vec3(x, y, z)
        cdef Quaternion q, qbar
        cdef int i, j
        cdef Vec3 imag
        axis *= 1/abs(axis)
        q = Quaternion(cos(a/2), sin(a/2)*axis)
        qbar = q.conjugate()
        components = (q @ q_I @ qbar, q @ q_J @ qbar,  q @ q_K @ qbar) 
        for i in range(3):
            imag = components[i].imag()
            for j in range(3):
                result.data[i + 4*j] = imag._v[j]
        result.data[15] = 1.0
        return result
