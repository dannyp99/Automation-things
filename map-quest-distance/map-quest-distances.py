from os import getenv
import requests
import urllib.parse as url_parser
import json
from dotenv import load_dotenv

load_dotenv() # load contents of .env
KEY = getenv('KEY') # Necessary API key
LOC_FILE = open("./loc.json", "r+") # File containing location information
JSON_DATA = json.load(LOC_FILE)
START = url_parser.quote_plus(JSON_DATA["start"])

class Location:

    def __init__(self, name: str, addr: str, dist: float = 0.0, desc: str = ''):
        self.name = name
        self.addr = addr
        self.url_addr = url_parser.quote_plus(addr)
        self.dist = dist
        self.desc = desc
    
    def __repr__(self):
        return str.format("{} located at: {} is {} miles from your location\n  {}", self.name, self.addr, self.dist, self.desc)
    def __str__(self):
        return str.format("{} located at: {} is {} miles from your location\n  {}", self.name, self.addr, self.dist, self.desc)

json_locations = JSON_DATA["locations"] # Get locations array

# List comprehension to convert to python class
locations = [ Location(json_loc['name'], json_loc['addr'], json_loc['distance'], json_loc['description']) for json_loc in json_locations ]

for loc in locations:
    request_str = str.format('https://www.mapquestapi.com/directions/v2/route?key={}&from={}&to={}', KEY, START, loc.url_addr)

    # print(request_str)
    r = requests.get(request_str)
    print("response status:", r.status_code)
    info = json.loads(r.text)
    distance_to_loc = float(info['route']['distance'])
    # print(distance_to_loc) # print distance in miles
    loc.dist = float(distance_to_loc)

print()
locations.sort(key=lambda loc: loc.dist) # Sort locations by distancs
for item in locations:
    print(item, end="\n\n")