#!/usr/bin/python3

from http.server import HTTPServer,SimpleHTTPRequestHandler
from socketserver import BaseServer
import ssl

PORT = 43

httpd = HTTPServer(('', PORT), SimpleHTTPRequestHandler)
httpd.socket = ssl.wrap_socket (httpd.socket, certfile='webserver.pem', server_side=True)
httpd.serve_forever()
