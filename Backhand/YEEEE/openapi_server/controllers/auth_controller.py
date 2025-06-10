import connexion
from typing import Dict
from typing import Tuple
from typing import Union

from openapi_server.models.login import Login  # noqa: E501
from openapi_server.models.register_admin import RegisterAdmin  # noqa: E501
from openapi_server.models.register_user import RegisterUser  # noqa: E501
from openapi_server import util


def auth_admin_register_post(body):  # noqa: E501
    """Admin registrieren

     # noqa: E501

    :param register_admin: 
    :type register_admin: dict | bytes

    :rtype: Union[None, Tuple[None, int], Tuple[None, int, Dict[str, str]]
    """
    register_admin = body
    if connexion.request.is_json:
        register_admin = RegisterAdmin.from_dict(connexion.request.get_json())  # noqa: E501
    return 'do some magic!'


def auth_login_post(body):  # noqa: E501
    """Login für Admin/User

     # noqa: E501

    :param login: 
    :type login: dict | bytes

    :rtype: Union[None, Tuple[None, int], Tuple[None, int, Dict[str, str]]
    """
    login = body
    if connexion.request.is_json:
        login = Login.from_dict(connexion.request.get_json())  # noqa: E501
    return 'do some magic!'


def auth_user_register_post(body):  # noqa: E501
    """User registrieren

     # noqa: E501

    :param register_user: 
    :type register_user: dict | bytes

    :rtype: Union[None, Tuple[None, int], Tuple[None, int, Dict[str, str]]
    """
    register_user = body
    if connexion.request.is_json:
        register_user = RegisterUser.from_dict(connexion.request.get_json())  # noqa: E501
    return 'do some magic!'
