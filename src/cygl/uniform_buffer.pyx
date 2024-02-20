# cython: language_level=3str

from cygl.common cimport *
from cygl.common import *
import cygl
import json

cdef class UBOElement:
    def __init__(self, value):
        self.load_data(value)

    cdef load_data(self, value):
        """Loads uniform data from a python object.

        The data is written to the C buffer with std140 padding and
        alignment.  The python object must support approriate indexing
        for the shape of the struct element, or an IndexError will be
        raised.
        """        
        cdef size_t stride
        if self.array_length == 0:
            self.save_item(value, 0)
        else:
            stride = self.array_stride // FLOAT_SIZE
            for n, entry in enumerate(value):
                self.save_item(entry, n*stride)
            
    cdef save_item (self, value, int offset):
        """ Writes python data for one basic type to the C buffer"""
        cdef int i
        cdef int j
        cdef int rows
        cdef int padded_rows
        cdef int columns
        columns, rows = self.shape
        padded_rows = self.padded_shape[1]
        if rows == 1 and columns == 1:
            self.data[offset] = value
        elif columns == 1:
            for i in range(rows):
                self.data[offset + i] = float(value[i])
        else:
            # Input data for matrices should be a sequence of rows,
            # because elements of a list of lists look like rows.
            for i in range(columns):
                for j in range(rows):
                    self.data[offset + i * padded_rows + j] = float(value[j][i])

    def __dealloc__(self):
        if self.data:
            print('freeing data')
            free(self.data)

    def dump(self):
        cdef int i
        for i in range(self.padded_size // FLOAT_SIZE):
            print(self.data[i])

cdef class UBOFloat(UBOElement):
    def __cinit__(self, value):
        self.alloc_data(value, FLOAT_SIZE, (1,1), (1,1))

cdef class UBOVec2(UBOElement):
    def __cinit__(self, value):
        self.alloc_data(value, 2*FLOAT_SIZE, (1,2), (1,2))

cdef class UBOVec3(UBOElement):
    def __cinit__(self, value):
        self.alloc_data(value, 4*FLOAT_SIZE, (1,3), (1,4))

cdef class UBOVec4(UBOElement):
    def __cinit__(self, value):
        self.alloc_data(value, 4*FLOAT_SIZE, (1,4), (1,4))

cdef class UBOMat2(UBOElement):
    def __cinit__(self, value):
        self.alloc_data(value, 4*FLOAT_SIZE, (2,2), (2,2))

cdef class UBOMat2x3(UBOElement): # 2 columns of length 3
    def __cinit__(self, value):
        self.alloc_data(value, 4*FLOAT_SIZE, (2,3), (2,4))

cdef class UBOMat3x2(UBOElement): # 3 columns of length 2
    def __cinit__(self, value):
        self.alloc_data(value, 4*FLOAT_SIZE, (3,2), (3,2))

cdef class UBOMat3(UBOElement):
    def __cinit__(self, value):
        self.alloc_data(value, 4*FLOAT_SIZE, (3,3), (3,4))

cdef class UBOMat4(UBOElement):
    def __cinit__(self, value):
        self.alloc_data(value, 4*FLOAT_SIZE, (4,4), (4,4))

cdef class UniformBuffer:
    """An OpenGL Uniform Buffer Object.

    By definition, "An OpenGL Object is an OpenGL construct that contains some
    state" of the GL context.  To change the state of the context, an object
    is "bound" to the context.

    This class manages a Uniform Buffer Object (UBO). The buffer is structured
    as an array of records, each of which can be described by a C struct.  The
    layout of the buffer complies with std140.

    A UniformBuffer is instantiated with keyword arguments which give the
    names of the uniform variables. The value assigned to a keyword is an
    instance of one of the class VBOFloat, VBOVec2, VBOVec3 or VBOMat4.

    There is a companion python class named Uniform.  An object in the Uniform
    class must be instantiated with a UniformBuffer, and holds a reference to
    the UniformBuffer.  The attributes of the Uniform are determined by its
    UniformBuffer.  A Uniform has a "save" method which writes its struct to a
    C buffer managed by the UniformBuffer.  The data in the C buffer gets
    uploaded to the GPU by the UniformBuffer.
    """
    pass
