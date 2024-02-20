from cython.cimports.libc.stdlib cimport calloc, free
include "gl_types.pxi"

# The Cython way to create a #define constant
cdef extern from *:
    """
#define FLOAT_SIZE sizeof(GLfloat)
    """
    cdef enum:
        FLOAT_SIZE

cdef class UBOElement:
    cdef GLfloat *data
    cdef size_t alignment
    cdef public size_t array_length
    cdef size_t array_stride
    cdef int shape[2]
    cdef int padded_shape[2]
    cdef size_t padded_size
    cdef inline round_up(self, int value, int unit):
        cdef result = unit * (value // unit)
        if value % unit:
            result += unit
        return result
    cdef inline alloc_data(self, value, alignment=0, shape=(0,0),
            padded_shape=(0,0)):
        # Called by __cinit__ methods of subclasses of UBOElement.
        cdef size_t columns = padded_shape[0]
        cdef size_t rows = padded_shape[1]
        cdef size_t unit_size = columns * rows * FLOAT_SIZE
        self.alignment = alignment
        self.shape = shape
        self.padded_shape = padded_shape
        self.array_stride = self.round_up(unit_size, 4*FLOAT_SIZE)
        if not hasattr(value, '__iter__'):
            self.array_length = 0
        elif not hasattr(value[0], '__iter__'):
            self.array_length = len(value)
        elif shape[1] > 1 and not hasattr(value[0][0], '__iter__'):
            self.array_length = 0
        else:
            self.array_length = len(value)
        if self.array_length == 0:
            self.padded_size = self.round_up(unit_size, self.alignment)
        else:
            self.padded_size = self.round_up(
                self.array_length * self.array_stride, 4*FLOAT_SIZE)
        self.data = <float *> calloc(self.padded_size, 1)
    cdef write_data(self, value, int offset)
