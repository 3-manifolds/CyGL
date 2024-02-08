# cython: language_level=3str

"""
Hamilton's quaternions.  The non-commutative algebra multiplication
operator is represented by @.  Scalar multiplication is represented
by *.
"""

from libc.math cimport sqrt
from cygl.vec3 cimport Vec3
from cygl.hh cimport Quaternion

cdef class Quaternion():

    def __init__(self, float s, Vec3 v=Vec3(0, 0, 0)):
        self._re = s
        self._im = v

    def __repr__(self):
        return '%f*h_1 + %f*h_I + %f*h_J + %f*h_K'%(self._re, *self._im)

    def __add__(self, Quaternion other):
        return Quaternion(self._re + other._re, self._im + other._im)

    def __radd__(self, other):
        return Quaternion(self._re + other._re, self._im + other._im)

    def __sub__(self, other):
        return Quaternion(self._re - other._re, self._im - other._im)

    def __matmul__(self, Quaternion other):
        return Quaternion(self._re * other._re - self._im @ other._im,
            self._re * other._im + self._im * other._re + self._im ^ other._im) 
        
    def __mul__(self, float other):
        return Quaternion(other * self._re, other * self._im)

    def __rmul__(self, float other):
        return Quaternion(other * self._re, other * self._im)

    def __abs__(self):
        return sqrt(self._re * self._re + self._im @ self._im)

    def real(self):
        return self._re

    def imag(self):
        return self._im

h_1 = Quaternion(1, Vec3(0, 0, 0))
h_I = Quaternion(0, Vec3(1, 0, 0))
h_J = Quaternion(0, Vec3(0, 1, 0))
h_K = Quaternion(0, Vec3(0, 0, 1))
