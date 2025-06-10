import unittest

from flask import json

from openapi_server.models.spiel import Spiel  # noqa: E501
from openapi_server.test import BaseTestCase


class TestSpielenController(BaseTestCase):
    """SpielenController integration test stubs"""

    def test_spielen_get(self):
        """Test case for spielen_get

        Spielverlauf eines Users
        """
        query_string = [('userId', 'user_id_example')]
        headers = { 
            'Accept': 'application/json',
        }
        response = self.client.open(
            '/spielen',
            method='GET',
            headers=headers,
            query_string=query_string)
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))

    def test_spielen_post(self):
        """Test case for spielen_post

        Spiel starten (User - nur veröffentlichte Themen)
        """
        spiel = {"fk_ID_User":"fk_ID_User","Punkte":0,"fk_ID_Themen":"fk_ID_Themen","Zeit":"2000-01-23T04:56:07.000+00:00"}
        headers = { 
            'Content-Type': 'application/json',
            'Authorization': 'Bearer special-key',
        }
        response = self.client.open(
            '/spielen',
            method='POST',
            headers=headers,
            data=json.dumps(spiel),
            content_type='application/json')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))


if __name__ == '__main__':
    unittest.main()
