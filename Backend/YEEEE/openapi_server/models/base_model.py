import pprint
import typing
from openapi_server import util
from openapi_server.util import logger

T = typing.TypeVar('T')


class Model:
    # openapiTypes: The key is attribute name and the
    # value is attribute type.
    openapi_types: typing.Dict[str, type] = {}

    # attributeMap: The key is attribute name and the
    # value is json key in definition.
    attribute_map: typing.Dict[str, str] = {}

    @classmethod
    def from_dict(cls: typing.Type[T], dikt) -> T:
        """Returns the dict as a model"""
        try:
            instance = util.deserialize_model(dikt, cls)
            logger.debug(f"{cls.__name__}: Erfolgreich aus Dictionary erstellt")
            return instance
        except Exception as e:
            logger.error(f"{cls.__name__}: Fehler beim Erstellen aus Dictionary: {e}")
            raise

    def to_dict(self):
        """Returns the model properties as a dict

        :rtype: dict
        """
        try:
            result = {}

            for attr in self.openapi_types:
                value = getattr(self, attr)
                if isinstance(value, list):
                    result[attr] = list(map(
                        lambda x: x.to_dict() if hasattr(x, "to_dict") else x,
                        value
                    ))
                elif hasattr(value, "to_dict"):
                    result[attr] = value.to_dict()
                elif isinstance(value, dict):
                    result[attr] = dict(map(
                        lambda item: (item[0], item[1].to_dict())
                        if hasattr(item[1], "to_dict") else item,
                        value.items()
                    ))
                else:
                    result[attr] = value

            logger.debug(f"{self.__class__.__name__}: Erfolgreich zu Dictionary konvertiert")
            return result
        except Exception as e:
            logger.error(f"{self.__class__.__name__}: Fehler bei Konvertierung zu Dictionary: {e}")
            raise

    def to_str(self):
        """Returns the string representation of the model

        :rtype: str
        """
        return pprint.pformat(self.to_dict())

    def __repr__(self):
        """For `print` and `pprint`"""
        return self.to_str()

    def __eq__(self, other):
        """Returns true if both objects are equal"""
        return self.__dict__ == other.__dict__

    def __ne__(self, other):
        """Returns true if both objects are not equal"""
        return not self == other
