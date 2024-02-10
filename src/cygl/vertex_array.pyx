# cython: language_level=3str

from cython.cimports.libc.stdlib import malloc, free, realloc
from cygl.vectors cimport Vec, Vec1, Vec2, Vec3, Vec4
import json

cdef class VertexArray():
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

    vec_sizes = {'vec1' : 1, 'vec2' : 2, 'vec3' : 3, 'vec4' : 4}

    def __cinit__(self):
        pass

    def __dealloc(self):
        if self.buffer_data:
            print('freeing buffer')
            free(self.buffer_data)

    cdef save_vertex(self, vertex):
        cdef float *buf
        cdef int pos
        cdef int size = self.buffer_size + self.record_size
        cdef Vec vec
        if self.record_count * self.record_size >= self.buffer_size:
            print("calling realloc")
            self.buffer_data = <float *> realloc(self.buffer_data,
                2 * size * sizeof(float))
            self.buffer_size = 2 * size
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
            buf = &self.buffer_data[pos]
            pos += vec.write(buf)
    
    def __init__(self, **kwargs):
        self.gl_attributes = kwargs
        self.attribute_size = {} 
        for key, value in self.gl_attributes.items():
            if value not in self.defaults:
                valid = ' '.join(self.defaults.keys())
                raise ValueError("Valid argument values are: %s" % valid)
            size = self.vec_sizes[value]
            self.record_size += size
            self.attribute_size[key] = size
        defaults = {attr: self.defaults[self.gl_attributes[attr]]
                        for attr in self.gl_attributes}

        def _vertex_init(vertex, **vertex_kwargs):
            vertex_attributes = defaults.copy()
            vertex_attributes.update(vertex_kwargs)
            if len(vertex_attributes) != len(defaults):
                raise ValueError("Invalid Vertex attribute")
            for attr in vertex_attributes:
                if len(vertex_attributes[attr]) != len(defaults[attr]):
                    raise ValueError('Value of %s should have length %d.'%(
                        attr, len(defaults[attr])))
                setattr(vertex, attr, vertex_attributes[attr])

        def _vertex_save(vertex):
            self.save_vertex(vertex)

        self.Vertex = type('Vertex', (object,), {
            '__init__' : _vertex_init,
            '_array' : self,
            'id' : -1,
            'save' : _vertex_save,
            })

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
            result[attr] = [self.buffer_data[n + m] for m in range(size)]
            n += size
        return result

    def dumps(self):
        cdef int n
        data = [self[n] for n in range(self.record_count)]
        return json.dumps(data, indent=2)

# Local Variables:
# mode: Cython
# End:
