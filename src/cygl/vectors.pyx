# cython: language_level=3str

"""
The classes Vec1, Vec2, Vec3 and Vec4 all support basic vector
operations. The * operator is scalar multiplication, which can be done
on either side.  The + and - operators represent vector addition and
subtraction. The operator %, which has the same precedence as *,
represents the dot product.

The Vec3 class also supports the cross product. If we identify R^3
with its dual using their standard bases, the wedge product on the
dual agrees with the cross product.  So it might be nice if we could
implement the xor operator ^ as the cross product.  However, that does
not work because xor has lower precedence than + and - in python,
leading to surprising errors.  Instead we use @ for the cross product,
which also correctly suggests that the cross product is not
commutative.  """

from libc.string cimport memcpy
from libc.math cimport sqrt
from cygl.vectors cimport *

cdef extern from *:
    """
    /* This C code will be quoted verbatim in the .c file output by Cython */
    static inline float c_dot(int size, float *x, float *y) {
        float result = 0.0f;
        for (int i = 0; i < size; i++) {
            result += x[i]*y[i];
        }
        return result;
    }
    static inline float c_abs(int size, float *x) {
        float dot = 0.0f;
        for (int i = 0; i < size; i++) {
            dot += x[i]*x[i];
        }
        return sqrt(dot);
    }
    """
    float c_dot(int size, float *x, float*y)
    float c_abs(int size, float *x)

cdef class Vec:
    cdef int write(self, float *buffer):
        memcpy(buffer, self._v, self._size * sizeof(float))
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

    def __mod__(self, Vec other):
        if self._size != other._size:
            raise TypeError('Vectors have different sizes.')
        return c_dot(self._size, self._v, other._v)

    def __neg__(self):
        return self.__class__(*(-self._v[i] for i in range(self._size)))

    def __abs__(self):
        return c_abs(self._size, self._v)

    def __repr__(self):
        return '<%s>'%', '.join(str(self._v[i]) for i in range(self._size))

    __str__ = __repr__

    def copy(self):
        return self.__class__(*self)

cdef class Vec1(Vec):
    def __init__(self, float x=0.0):
        self._v = &self._data
        self._size = 2
        self._v[0] = x

cdef class Vec2(Vec):
    def __init__(self, *args):
        cdef int i, nargs = len(args)
        self._v = &self._data[0]
        self._size = 2
        if nargs == 0:
            return
        if nargs > 2:
            raise ValueError('Too many input values for a Vec2.')
        for i in range(nargs):
            self._v[i] = args[i]

cdef class Vec4(Vec):
    def __init__(self, *args):
        cdef int i, nargs = len(args)
        self._v = &self._data[0]
        self._size = 4
        if nargs == 0:
            return
        if nargs > 4:
            raise ValueError('Too many input values for a Vec4.')
        for i in range(nargs):
            self._v[i] = args[i]
        if nargs < 4:
            self._v[3] = 1.0

cdef class Vec3(Vec):

    def __cinit__(self):
        self._data[3] = 1.0

    def __init__(self, *args):
        cdef int i, nargs = len(args)
        self._v = &self._data[0]
        self._size = 3
        if nargs == 0:
            return
        if nargs > 3:
            raise ValueError('Too many input values for a Vec3.')
        for i in range(nargs):
            self._v[i] = args[i]

    def __matmul__(self, Vec3 other):
        """ The cross product!"""
        cdef float *L = self._v
        cdef float *R = other._v
        return Vec3(L[1] * R[2] - L[2] * R[1],
                    L[2] * R[0] - L[0] * R[2],
                    L[0] * R[1] - L[1] * R[0])

    def __neg__(self):
        return Vec3(-self._v[0], -self._v[1], -self._v[2])

    def normalized(self):
        cdef float *v = self._v
        cdef float norm = sqrt(v[0]*v[0] + v[1] * v[1] + v[2] * v[2])
        if float == 0:
            raise ValueError('Cannot normalize the zero vector.')
        return Vec3(v[0] / norm, v[1] / norm, v[2] / norm)
