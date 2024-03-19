import json

with open('restaurant-trello-clean.json') as restaurant_trello:
  file_contents = restaurant_trello.read()

parsed_json = json.loads(file_contents) # Load jsson file into variable

list_name_lookup = dict([ (trello_list['id'], trello_list['name']) for trello_list in parsed_json['lists'] ]) # dict<str,str> with List id and name

all_active_cards = filter(lambda card: not card['closed'], parsed_json['cards']) # Grab the cards list inside of the json object and filter

# Initialize place dict<str, list> key is listId ("idList") and values are members of that list.
# Initialize lists to empty list
places_dict = dict([ (key, []) for key in list_name_lookup.keys() ])
for card in all_active_cards:
  places_dict[card['idList']].append(card['name'])

for key in places_dict.keys():
  print(list_name_lookup[key] + " (" + str(len(places_dict[key])) + "): \n\t" + str.join("\n\t", places_dict[key]))