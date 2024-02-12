__version__ = '1.0a0'
from cygl.vectors import Vec1, Vec2, Vec3, Vec4
from cygl.hh import Quaternion, q_1, q_I, q_J, q_K
from cygl.vertex_array import VertexArray

class Vertex():
    def __init__(self, array, **kwargs):
        if array.__class__ != VertexArray:
            raise ValueError("Argument must be a VertexArray")
        self._array = array
        self.id = -1
        size = array.attribute_size
        for key in kwargs:
            try:
                if len(key) != size[key]:
                    raise ValueError('%s should have size %d'%(key, size[key]))
            except IndexError:
                raise AttributeError('Invalid attribute %s'%key)
        defaults = array.vertex_defaults
        for attr in defaults:
            setattr(self, attr, kwargs.get(attr, defaults[attr].copy()))

    def save(self):
        self._array._save_vertex(self)

__all__ = [ "VertexArray","Vertex", "Vec1", "Vec2", "Vec3", "Vec4",
            "Quaternion", "q_1", "q_I", "q_J", "q_K"]
