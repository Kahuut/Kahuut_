from datetime import date, datetime  # noqa: F401

from typing import List, Dict  # noqa: F401

from openapi_server.models.base_model import Model
from openapi_server import util
from openapi_server.util import logger


class MehrspielerJoinPostRequest(Model):
    """NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).

    Do not edit the class manually.
    """

    def __init__(self, code=None, user_id=None):  # noqa: E501
        """MehrspielerJoinPostRequest - a model defined in OpenAPI

        :param code: The code of this MehrspielerJoinPostRequest.  # noqa: E501
        :type code: str
        :param user_id: The user_id of this MehrspielerJoinPostRequest.  # noqa: E501
        :type user_id: str
        """
        self.openapi_types = {
            'code': str,
            'user_id': str
        }

        self.attribute_map = {
            'code': 'code',
            'user_id': 'userId'
        }

        self._code = code
        self._user_id = user_id

    @classmethod
    def from_dict(cls, dikt) -> 'MehrspielerJoinPostRequest':
        """Returns the dict as a model

        :param dikt: A dict.
        :type: dict
        :return: The _mehrspieler_join_post_request of this MehrspielerJoinPostRequest.  # noqa: E501
        :rtype: MehrspielerJoinPostRequest
        """
        return util.deserialize_model(dikt, cls)

    @property
    def code(self) -> str:
        """Gets the code of this MehrspielerJoinPostRequest.


        :return: The code of this MehrspielerJoinPostRequest.
        :rtype: str
        """
        return self._code

    @code.setter
    def code(self, code: str):
        """Sets the code of this MehrspielerJoinPostRequest.


        :param code: The code of this MehrspielerJoinPostRequest.
        :type code: str
        """
        if code is None:
            logger.error("MehrspielerJoinPostRequest: Versuch, code=None zu setzen")
            raise ValueError("Invalid value for `code`, must not be `None`")  # noqa: E501

        self._code = code

    @property
    def user_id(self) -> str:
        """Gets the user_id of this MehrspielerJoinPostRequest.


        :return: The user_id of this MehrspielerJoinPostRequest.
        :rtype: str
        """
        return self._user_id

    @user_id.setter
    def user_id(self, user_id: str):
        """Sets the user_id of this MehrspielerJoinPostRequest.


        :param user_id: The user_id of this MehrspielerJoinPostRequest.
        :type user_id: str
        """
        if user_id is None:
            logger.error("MehrspielerJoinPostRequest: Versuch, user_id=None zu setzen")
            raise ValueError("Invalid value for `user_id`, must not be `None`")  # noqa: E501

        self._user_id = user_id
