#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
if sys.version_info.major == 3:
    import urllib.request as http
else:
    import urllib2 as http

import json

JDK_HOST = "https://api.github.com"
JDK_HOST_PATH = "/repos/AdoptOpenJDK/openjdk8-binaries/releases/latest"
JDK_NAME_PREFIX = "OpenJDK8U-jdk_x64_linux_hotspot_"
ASSET_CONENT_TYPE = "application/x-compressed-tar"


def parse(data):
    json_data = json.loads(data)
    assets = json_data["assets"]
    for asset in assets:
        asset_name = asset["name"]
        asset_content_type = asset["content_type"]
        if asset_name.startswith(JDK_NAME_PREFIX) \
                and asset_content_type == ASSET_CONENT_TYPE:
            print(asset["browser_download_url"])


def run(host, path):
    fd = http.urlopen("".join([host, path]))
    parse(fd.read())
    fd.close()


if __name__ == "__main__":
    run(JDK_HOST, JDK_HOST_PATH)
