from openapi_server.models.base_model import Model
from openapi_server import util


class MehrspielerStartPostRequest(Model):
    def __init__(self, code=None):
        self.openapi_types = {
            'code': str
        }
        self.attribute_map = {
            'code': 'code'
        }
        self._code = code

    @classmethod
    def from_dict(cls, dikt) -> 'MehrspielerStartPostRequest':
        return util.deserialize_model(dikt, cls)

    @property
    def code(self) -> str:
        return self._code

    @code.setter
    def code(self, code: str):
        if code is None:
            raise ValueError("`code` darf nicht None sein.")
        self._code = code
