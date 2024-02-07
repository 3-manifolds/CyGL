# cython: language_level=3str

from cygl.vec3 cimport vec3

cdef class VertexArray():
    """An OpenGL Vertex Array."""

    attribute_defaults = {
        'vec1' : (0.0),
        'vec2' : (0.0, 0.0),
        'vec3' : vec3(0.0, 0.0, 0.0),
        'vec4' : (0.0, 0.0, 0.0, 1.0),
        'rgba' : (0.0, 0.0, 0.0, 1.0)
        }
        
    def __init__(self, **kwargs):
        cdef vec3 mytest
        self.attribute_types = kwargs
        for value in self.attribute_types.values():
            if value not in self.attribute_defaults:
                valid = ' '.join(self.attribute_defaults.keys())
                raise ValueError("Valid argument values are: %s" % valid)
        defaults = {attr: self.attribute_defaults[self.attribute_types[attr]]
                        for attr in self.attribute_types}

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
            print('Saving current attributes in array %s'%vertex._array)

        self.Vertex = type('Vertex', (object,), {
            '__init__' : _vertex_init,
            '_array' : self,
            'save' : _vertex_save,
            })
 
# Local Variables:
# mode: Python
# End:
