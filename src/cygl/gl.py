"""
Importing this module requires first creating an OpenGL context.
"""

from cygl.vertex_array import VertexArray
from cygl.gl_context import gl_context_exists
__all__ = ["VertexArray","Vertex", "gl_context_exists"]

class Vertex():
    def __init__(self, array, **kwargs):
        if array.__class__ != VertexArray:
            raise ValueError("Argument must be a VertexArray")
        self._array = array
        self.id = -1
        size = array.attribute_size
        for key in kwargs:
            try:
                if len(kwargs[key]) != size[key]:
                    raise ValueError('%s should have size %d'%(key, size[key]))
            except IndexError:
                raise AttributeError('Invalid attribute %s'%key)
        defaults = array.vertex_defaults
        for attr in defaults:
            setattr(self, attr, kwargs.get(attr, defaults[attr].copy()))

    def __repr__(self):
        attributes = [(k, v) for k, v in self.__dict__.items()
                          if k in self._array.gl_attributes]
        return 'Vertex(%s)' % ', '.join('%s=%s' % item for item in attributes)

    def save(self):
        self._array._save_vertex(self)
