# cython: language_level=3str

from cython.cimports.libc.stdlib import malloc, free, realloc
from cygl.vectors cimport Vec, Vec1, Vec2, Vec3, Vec4
from cygl.common import *
import json

cdef class VertexArray:
    """An OpenGL Vertex Array.

    This class manages a Vertex Array Object (VAO) and a Vertex Buffer
    Object (VBO).  It only supports the "combined format" because the
    "separate format" is not supported by Apple.  This means that all
    vertex attributes are stored in the one buffer.  The buffer is
    structured as a sequence of records, one per buffer.

    A VertexArray is instantiated with keyword arguments which give
    the names of the vertex attributes. The value assigned to a
    keyword specifies the GL type of the attribute.  A VertexArray
    object has a special attribute named Vertex which is a Python
    class whose objects have the specified attributes.  All attributes
    are floats or vectors of floats.

    An object of the class VertexArray.Vertex has a "save" method
    which adds the vertex to the buffer.  When a vertex is saved it
    acquires an integer id which can be used as the vertex index when
    creating a primitive element.  A negative id indicates that the
    vertex object has not yet been saved."""

    defaults = {
        'vec1 ' : Vec1(0.0),
        'vec2'  : Vec2(0.0, 0.0),
        'vec3'  : Vec3(0.0, 0.0, 0.0),
        'vec4'  : Vec4(0.0, 0.0, 0.0, 1.0),
        }

    dimensions = {'vec1' : 1, 'vec2' : 2, 'vec3' : 3, 'vec4' : 4}
    
    def __init__(self, **kwargs):
        self.gl_attributes = kwargs
        self.attribute_size = {} 
        for key, value in self.gl_attributes.items():
            if value not in self.defaults:
                valid = ' '.join(self.defaults.keys())
                raise ValueError("Valid argument values are: %s" % valid)
            size = self.dimensions[value]
            self.record_size += size
            self.attribute_size[key] = size
        self.vertex_defaults = {
            attr: self.defaults[self.gl_attributes[attr]]
            for attr in self.gl_attributes}

    def __dealloc__(self):
        if self.vbo:
            glDeleteBuffer(self.vbo)
            glDeleteVertexArray(self.vao)
        if self.vbo_data:
            free(self.vbo_data)

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

    def __getitem__(self, int key):
        """Returns a single buffer record represented as a dict."""
        cdef int n
        cdef int m
        cdef int size
        if key < 0 or key > len(self.gl_attributes):
            raise IndexError()
        n = key * self.record_size
        result = {}
        for attr in self.gl_attributes:
            size = self.attribute_size[attr]
            result[attr] = [self.vbo_data[n + m] for m in range(size)]
            n += size
        return result

    cdef init_array(self):
        cdef int dimension
        # This will segfault if there is no GL context.
        self.vbo = glGenBuffer()
        self.vao = glGenArray()
        glBindVertexArray(self.vao)
        for n, dimension in enumerate(self.attribute_size.values()):
            glVertexAttribPointer(
                n,                # attribute index
                dimension,        # size
                GL_FLOAT,         # type
                GL_FALSE,         # normalized
                0,                # stride (0 means "tightly packed")
                0)           # offset of the first element in the buffer
    
    def dumps(self):
        cdef int n
        data = [self[n] for n in range(self.record_count)]
        return json.dumps(data)

    def bind(self):
        if self.vbo == 0:
            # This will segfault if there is no GL context.
            self.vbo = glGenBuffer()
        glBindBuffer(GL_ARRAY_BUFFER, self.vbo)
        glBindVertexArray(self.vao)

    def load(self):
        # self.bind()
        # glBufferData(GL_ARRAY_BUFFER,
        #    <GLsizeiptr>num_bytes,
        #    verts,
        #    GL_STATIC_DRAW)
        pass

# Local Variables:
# mode: Cython
# End:
