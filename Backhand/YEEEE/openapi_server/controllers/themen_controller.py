import connexion
from typing import Dict
from typing import Tuple
from typing import Union

from openapi_server.models.thema import Thema  # noqa: E501
from openapi_server import util


def themen_get(published=None):  # noqa: E501
    """Themen abrufen (optional gefiltert nach veröffentlicht)

     # noqa: E501

    :param published: Nur veröffentlichte Themen anzeigen (true/false)
    :type published: bool

    :rtype: Union[List[Thema], Tuple[List[Thema], int], Tuple[List[Thema], int, Dict[str, str]]
    """
    return 'do some magic!'


def themen_post(body):  # noqa: E501
    """Neues Thema anlegen (Admin)

     # noqa: E501

    :param thema: 
    :type thema: dict | bytes

    :rtype: Union[None, Tuple[None, int], Tuple[None, int, Dict[str, str]]
    """
    thema = body
    if connexion.request.is_json:
        thema = Thema.from_dict(connexion.request.get_json())  # noqa: E501
    return 'do some magic!'
