import connexion
from typing import Dict
from typing import Tuple
from typing import Union

from openapi_server.models.spiel import Spiel  # noqa: E501
from openapi_server import util


def spielen_get(user_id):  # noqa: E501
    """Spielverlauf eines Users

     # noqa: E501

    :param user_id: 
    :type user_id: str

    :rtype: Union[List[Spiel], Tuple[List[Spiel], int], Tuple[List[Spiel], int, Dict[str, str]]
    """
    return 'do some magic!'


def spielen_post(body):  # noqa: E501
    """Spiel starten (User - nur veröffentlichte Themen)

     # noqa: E501

    :param spiel: 
    :type spiel: dict | bytes

    :rtype: Union[None, Tuple[None, int], Tuple[None, int, Dict[str, str]]
    """
    spiel = body
    if connexion.request.is_json:
        spiel = Spiel.from_dict(connexion.request.get_json())  # noqa: E501
    return 'do some magic!'
