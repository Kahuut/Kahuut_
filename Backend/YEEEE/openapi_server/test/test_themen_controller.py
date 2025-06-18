import unittest

from flask import json

from openapi_server.models.thema import Thema  # noqa: E501
from openapi_server.test import BaseTestCase


class TestThemenController(BaseTestCase):
    """ThemenController integration test stubs"""

    def test_themen_get(self):
        """Test case for themen_get

        Themen abrufen (optional gefiltert nach veröffentlicht)
        """
        query_string = [('published', True)]
        headers = { 
            'Accept': 'application/json',
        }
        response = self.client.open(
            '/themen',
            method='GET',
            headers=headers,
            query_string=query_string)
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))

    def test_themen_post(self):
        """Test case for themen_post

        Neues Thema anlegen (Admin)
        """
        thema = {"Antwort":"Antwort","Published":True,"Fragen":"Fragen","Code":"Code"}
        headers = { 
            'Content-Type': 'application/json',
            'Authorization': 'Bearer special-key',
        }
        response = self.client.open(
            '/themen',
            method='POST',
            headers=headers,
            data=json.dumps(thema),
            content_type='application/json')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))


if __name__ == '__main__':
    unittest.main()
