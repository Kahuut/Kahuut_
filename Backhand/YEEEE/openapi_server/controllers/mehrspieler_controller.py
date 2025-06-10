import connexion
from typing import Dict
from typing import Tuple
from typing import Union

from openapi_server.models.mehrspieler_join_post_request import MehrspielerJoinPostRequest  # noqa: E501
from openapi_server.models.mehrspieler_start_post_request import MehrspielerStartPostRequest  # noqa: E501
from openapi_server import util


def mehrspieler_join_post(body):  # noqa: E501
    """Mehrspieler-Quiz beitreten (per Code)

     # noqa: E501

    :param mehrspieler_join_post_request: 
    :type mehrspieler_join_post_request: dict | bytes

    :rtype: Union[None, Tuple[None, int], Tuple[None, int, Dict[str, str]]
    """
    mehrspieler_join_post_request = body
    if connexion.request.is_json:
        mehrspieler_join_post_request = MehrspielerJoinPostRequest.from_dict(connexion.request.get_json())  # noqa: E501
    return 'do some magic!'


def mehrspieler_start_post(body):  # noqa: E501
    """Mehrspieler-Quiz starten (nur Admin)

     # noqa: E501

    :param mehrspieler_start_post_request: 
    :type mehrspieler_start_post_request: dict | bytes

    :rtype: Union[None, Tuple[None, int], Tuple[None, int, Dict[str, str]]
    """
    mehrspieler_start_post_request = body
    if connexion.request.is_json:
        mehrspieler_start_post_request = MehrspielerStartPostRequest.from_dict(connexion.request.get_json())  # noqa: E501
    return 'do some magic!'
