import unittest

from flask import json

from openapi_server.models.mehrspieler_join_post_request import MehrspielerJoinPostRequest  # noqa: E501
from openapi_server.models.mehrspieler_start_post_request import MehrspielerStartPostRequest  # noqa: E501
from openapi_server.test import BaseTestCase


class TestMehrspielerController(BaseTestCase):
    """MehrspielerController integration test stubs"""

    def test_mehrspieler_join_post(self):
        """Test case for mehrspieler_join_post

        Mehrspieler-Quiz beitreten (per Code)
        """
        mehrspieler_join_post_request = openapi_server.MehrspielerJoinPostRequest()
        headers = { 
            'Content-Type': 'application/json',
            'Authorization': 'Bearer special-key',
        }
        response = self.client.open(
            '/mehrspieler/join',
            method='POST',
            headers=headers,
            data=json.dumps(mehrspieler_join_post_request),
            content_type='application/json')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))

    def test_mehrspieler_start_post(self):
        """Test case for mehrspieler_start_post

        Mehrspieler-Quiz starten (nur Admin)
        """
        mehrspieler_start_post_request = openapi_server.MehrspielerStartPostRequest()
        headers = { 
            'Content-Type': 'application/json',
            'Authorization': 'Bearer special-key',
        }
        response = self.client.open(
            '/mehrspieler/start',
            method='POST',
            headers=headers,
            data=json.dumps(mehrspieler_start_post_request),
            content_type='application/json')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))


if __name__ == '__main__':
    unittest.main()
