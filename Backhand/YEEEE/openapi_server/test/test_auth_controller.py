import unittest

from flask import json

from openapi_server.models.login import Login  # noqa: E501
from openapi_server.models.register_admin import RegisterAdmin  # noqa: E501
from openapi_server.models.register_user import RegisterUser  # noqa: E501
from openapi_server.test import BaseTestCase


class TestAuthController(BaseTestCase):
    """AuthController integration test stubs"""

    def test_auth_admin_register_post(self):
        """Test case for auth_admin_register_post

        Admin registrieren
        """
        register_admin = {"password":"password","name":"name","email":"email"}
        headers = { 
            'Content-Type': 'application/json',
        }
        response = self.client.open(
            '/auth/admin/register',
            method='POST',
            headers=headers,
            data=json.dumps(register_admin),
            content_type='application/json')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))

    def test_auth_login_post(self):
        """Test case for auth_login_post

        Login für Admin/User
        """
        login = {"password":"password","email":"email"}
        headers = { 
            'Content-Type': 'application/json',
        }
        response = self.client.open(
            '/auth/login',
            method='POST',
            headers=headers,
            data=json.dumps(login),
            content_type='application/json')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))

    def test_auth_user_register_post(self):
        """Test case for auth_user_register_post

        User registrieren
        """
        register_user = {"password":"password","name":"name","email":"email"}
        headers = { 
            'Content-Type': 'application/json',
        }
        response = self.client.open(
            '/auth/user/register',
            method='POST',
            headers=headers,
            data=json.dumps(register_user),
            content_type='application/json')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))


if __name__ == '__main__':
    unittest.main()
