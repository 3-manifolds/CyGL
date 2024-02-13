# cython: language_level=3str

from cython.cimports.libc.stdlib import malloc, free, realloc
from cygl.vectors cimport Vec, Vec1, Vec2, Vec3, Vec4
from cygl.common cimport *
from cygl.common import *
import cygl
import json

cdef class VertexArray:
    """An OpenGL Vertex Array.

    By definition, "An OpenGL Object is an OpenGL construct that contains some
    state" of the GL context.  To change the state of the context an object is
    "bound" to the contex.

    This class manages a Vertex Array Object (VAO) and a Vertex Buffer Object
    (VBO).  It only supports the "combined format" because the "separate
    format" is not supported by Apple.  This means that all vertex attributes
    are stored in the one buffer.  The buffer is structured as a sequence of
    records, one per buffer.

    A VertexArray is instantiated with keyword arguments which give the names of
    the vertex attributes. The value assigned to a keyword specifies the GL type
    of the attribute.  A VertexArray object has a special attribute named Vertex
    which is a Python class whose objects have the specified attributes.  All
    attributes are floats or vectors of floats.

    An object of the class Vertex must be instantiated with a VertexArray, and
    holds a reference to the VertexArray.  The attributes of the Vertex are
    determined by its VertexArray.  A Vertex has a "save" method which adds the
    vertex to the buffer.  When a Vertex is saved it acquires an integer id
    which can be used as the vertex index when creating a primitive element.  A
    negative id indicates that the Vertex has not yet been saved.

    Currently we only support vertex attributes which are vectors of floats.
    This should change - best practice calls for some vector quantities,
    notably normals and colors, to be stored as packed integers.  A
    3-dimension value can be stored in 10-10-10-2 format with the 2 bit field
    unused or adapted for some purpose.
    """

    #To do: add packed integer vectors, e.g. for normal and colors.
    classes = {
        'vec1 ' : Vec1,
        'vec2'  : Vec2,
        'vec3'  : Vec3,
        'vec4'  : Vec4,
        }
    defaults = {
        'vec1 ' : Vec1(0.0),
        'vec2'  : Vec2(0.0, 0.0),
        'vec3'  : Vec3(0.0, 0.0, 0.0),
        'vec4'  : Vec4(0.0, 0.0, 0.0, 1.0),
        }

    sizes = {'vec1' : 1, 'vec2' : 2, 'vec3' : 3, 'vec4' : 4}
    
    def __init__(self, **kwargs):
        self.gl_attributes = kwargs
        self.attribute_size = {} 
        for key, value in self.gl_attributes.items():
            if value not in self.defaults:
                valid = ' '.join(self.defaults.keys())
                raise ValueError("Valid argument values are: %s" % valid)
            size = self.sizes[value]
            self.record_size += size
            self.attribute_size[key] = size
        self.vertex_defaults = {
            attr: self.defaults[self.gl_attributes[attr]]
            for attr in self.gl_attributes}

    def __dealloc__(self):
        if self.vbo:
            glDeleteBuffer(self.vbo)
        if self.vao:
            glDeleteVertexArray(self.vao)
        if self.vbo_data:
            free(self.vbo_data)

    def __getitem__(self, int index):
        """Returns a Vertex object

        The Vertex is built from the item in this array with the
        provided index.  Its _array attribute is set to this array and
        its id is set to the index.
        """
        cdef int n
        cdef int m
        cdef int size
        if index < 0 or index >= self.record_count:
            raise IndexError()
        n = index * self.record_size
        kwargs = {}
        for attr in self.gl_attributes:
            size = self.attribute_size[attr]
            attr_type = self.gl_attributes[attr]
            V = tuple(self.vbo_data[n + m] for m in range(size))
            kwargs[attr] = self.classes[attr_type](*V)
            n += size
        vertex = cygl.Vertex(self, **kwargs)
        vertex.id = index
        return vertex

    cpdef _save_vertex(self, vertex):
        cdef float *buf
        cdef int pos
        cdef int size = self.vbo_size + self.record_size
        cdef Vec vec
        if self.record_count * self.record_size >= self.vbo_size:
            print("calling realloc")
            self.vbo_data = <float *> realloc(self.vbo_data,
                2 * size * sizeof(float))
            self.vbo_size = 2 * size
        if vertex.id < 0:
            print('adding new vertex')
            pos = self.record_count * self.record_size
            vertex.id = self.record_count
            self.record_count += 1
        else:
            print('updating vertex', vertex.id)
            pos = vertex.id * self.record_size
        for key in self.gl_attributes:
            vec = getattr(vertex, key)
            buf = &self.vbo_data[pos]
            pos += vec.write(buf)

    cdef init_array(self):
        cdef int size
        # Note: these calls will segfault if there is no GL context.
        # Create a Buffer for our data.
        _glGenBuffers(1, &self.vbo)
        # Create an Array Object to describe the buffer structure.
        _glGenVertexArrays(1, &self.vao)
        # Make our Array Object active. 
        _glBindVertexArray(self.vao)
        # Configure the Array Object to match our vertices.
        for n, size in enumerate(self.attribute_size.values()):
            _glVertexAttribPointer(
                n,                # attribute index
                size,             # size
                GL_FLOAT,         # type
                GL_FALSE,         # normalized
                0,                # stride (0 means "tightly packed")
                <void *> 0)        # offset of the first element in the buffer

    def dumps(self):
        cdef int n
        data = [self[n] for n in range(self.record_count)]
        return json.dumps(data)

    def bind(self):
        # Activate our Buffer and Array Object.
        _glBindBuffer(GL_ARRAY_BUFFER, self.vbo)
        _glBindVertexArray(self.vao)

    def load(self):
        # self.bind()
        # _glBufferData(GL_ARRAY_BUFFER,
        #    <GLsizeiptr>num_bytes,
        #    verts,
        #    GL_STATIC_DRAW)
        pass

# Local Variables:
# mode: Cython
# End:
