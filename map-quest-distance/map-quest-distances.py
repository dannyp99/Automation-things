from os import getenv
import requests
import urllib.parse as url_parser
import json
from dotenv import load_dotenv

load_dotenv() # load contents of .env
KEY = getenv('KEY') # Necessary API key
START = url_parser.quote_plus('100 E 77th St, New York, NY')

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

locations = [
    Location("Plue", "1575 Lexington Ave, New York, NY", 
        desc="Thai restaurant, seasonal food with a good price"),
    Location("Ferns", "166 1st Ave., New York, NY", 
        desc="Comfort food restaurant"),
    Location("Seoul Salon", "28 W 33rd St, New York, NY", 
        desc="Korean restaurant that may be good for seafood and rice dishes"),
    Location("Lou Yau Kee", "124 E 14th St, New York, NY", 
        desc="Great Hainanese chicked rice, great portions, half off a second bowl weekends after 7pm & weekdays after 5pm"),
    Location("Omusubi", "370 Lexington Ave., New York, NY", 
        desc="Japanese snack station"),
    Location("Urban Hawker", "135 W 50th St, New York, NY", 
        desc="Singaporian restaurant with multiple stalls and shops")
]

for loc in locations:
    request_str = str.format('https://www.mapquestapi.com/directions/v2/route?key={}&from={}&to={}', KEY, START, loc.url_addr)

    # print(request_str)
    r = requests.get(request_str)
    print("response status:", r.status_code)
    info = json.loads(r.text)
    distance_to_loc = float(info['route']['distance'])
    # print(distance_to_loc) # print distance in miles
    loc.dist = float(distance_to_loc)

locations.sort(key=lambda loc: loc.dist) # Sort locations by distancs
for item in locations:
    print(item, end="\n\n")