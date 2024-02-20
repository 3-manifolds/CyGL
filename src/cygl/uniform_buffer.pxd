from cython.cimports.libc.stdlib cimport calloc, free
include "gl_types.pxi"

#cdef extern from *:
#    """
##define FLOAT_SIZE sizeof(GLfloat)
#   """
cdef enum:
    FLOAT_SIZE = sizeof(GLfloat)

cdef class UBOElement:
    cdef GLfloat *data
    cdef int alignment
    cdef public int array_length
    cdef int array_stride
    cdef int shape[2]
    cdef int padded_shape[2]
    cdef inline round_up(self, int value, int unit):
        cdef result = unit * (value // unit)
        if value % unit:
            result += unit
        return result
    cdef inline alloc_data(self, value,
            alignment=0, shape=(0,0), padded_shape=(0,0)):
        cdef size_t size
        self.alignment = alignment
        self.shape = shape
        self.padded_shape = padded_shape
        size = padded_shape[0]*self.padded_shape[1]*FLOAT_SIZE
        self.array_stride = self.round_up(size, 4*FLOAT_SIZE)
        if not hasattr(value, '__iter__'):
            self.array_length = 0
        elif not hasattr(value[0], '__iter__'):
            self.array_length = len(value)
        elif shape[1] > 1 and not hasattr(value[0][0], '__iter__'):
            self.array_length = 0
        else:
            self.array_length = len(value)
        size = <size_t> self.padded_size()
        self.data = <float *> calloc(size, 1)
    cdef save(self, value, int offset)
    cpdef aligned_offset(self, int offset)
    cpdef padded_size(self)

