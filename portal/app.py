import tornado.ioloop
import tornado.web

import re
import sqlite3

from subprocess import Popen,PIPE

def get_mac_address(ip):
    cmd = Popen(
        ("arp -n %s" %ip).split(),
        stdout=PIPE,
    )
    result = re.search(
        r"([0-9a-fA-F]{2}[:-]){5}[0-9a-fA-F]{2}", 
        cmd.communicate()[0].decode()
    )
    if result:
        return result.group(0)

def get_wifi_credits(macaddr):
    return 0

class PortalHandler(tornado.web.RequestHandler):

    def get(self):
        IP_ADDRESS = self.request.remote_ip
        MAC_ADDRESS = get_mac_address(IP_ADDRESS)
        WIFI_CREDITS = get_wifi_credits(MAC_ADDRESS)

        self.write("""
        <pre>
            IP Address: %s
            MAC Address: %s
            Wifi Credits: %s
        </pre>
        """ %(IP_ADDRESS, MAC_ADDRESS, WIFI_CREDITS))

def make_app():
    return tornado.web.Application([
        (r"/", PortalHandler),
    ])

if __name__ == "__main__":
    print("Running app.py!!!")
    app = make_app()
    app.listen(8000)
    tornado.ioloop.IOLoop.current().start()
