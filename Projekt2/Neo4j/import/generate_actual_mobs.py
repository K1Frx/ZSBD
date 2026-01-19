import csv
import math
import random
from faker import Faker
from datetime import datetime, timedelta

MAP_COORDINATES_SCOPE = (-500, 500)
HAS_ITEM_CHANCE = 0.5

### GENERATE ACTUAL DIMENSIONS
dimensions = csv.DictReader(open('import/Dimensions.csv', encoding='utf-8'))
identifier = 1
for dimension in dimensions:
    dimension_name = dimension['name']
    dimension_id = dimension['ID']
    dimension_size_x = math.fabs(MAP_COORDINATES_SCOPE[0]) + math.fabs(MAP_COORDINATES_SCOPE[1])
    dimension_size_y = math.fabs(MAP_COORDINATES_SCOPE[0]) + math.fabs(MAP_COORDINATES_SCOPE[1])
    
    with open('import/ActualDimensions.csv', mode='a', encoding='utf-8', newline='') as file:
        writer = csv.writer(file)
        writer.writerow([identifier, dimension_id, dimension_size_x, dimension_size_y])
        identifier += 1
        
### GENERATE ACTUAL BIOMES
biomes = csv.DictReader(open('import/Biomes.csv', encoding='utf-8'))
biomes_1_count = 0
biomes_2_count = 0
biomes_3_count = 0

for biome in biomes:
    if biome['dimensionID'] == '1':
        biomes_1_count += 1
    elif biome['dimensionID'] == '2':
        biomes_2_count += 1
    elif biome['dimensionID'] == '3':
        biomes_3_count += 1
        
biomes_1_iterator = 0
biomes_2_iterator = 0
biomes_3_iterator = 0

biomes = csv.DictReader(open('import/Biomes.csv', encoding='utf-8'))
identifier = 1
for biome in biomes:
    dimension = biome['dimensionID']
    count = biomes_1_count if dimension == '1' else biomes_2_count if dimension == '2' else biomes_3_count
    iterator = biomes_1_iterator if dimension == '1' else biomes_2_iterator if dimension == '2' else biomes_3_iterator
    biome_high = math.fabs(MAP_COORDINATES_SCOPE[0]) + math.fabs(MAP_COORDINATES_SCOPE[1])
    biome_width = 1000 // count
    biome_width = int(biome_width)
    start_x = MAP_COORDINATES_SCOPE[0] + (biome_width * iterator)
    start_y = MAP_COORDINATES_SCOPE[0]
    end_x = start_x + biome_width - 1
    end_y = MAP_COORDINATES_SCOPE[1]
    
    if dimension == '1':
        biomes_1_iterator += 1
    elif dimension == '2':
        biomes_2_iterator += 1
    elif dimension == '3':
        biomes_3_iterator += 1
    
    if (iterator + 1) == count:
        end_x = MAP_COORDINATES_SCOPE[1]
        
    with open('import/ActualBiomes.csv', mode='a', encoding='utf-8', newline='') as file:
        writer = csv.writer(file)
        writer.writerow([identifier, biome['ID'], start_x, start_y, end_x, end_y])
        identifier += 1
        
### GENERATE ACTUAL MOBS
mobs = csv.DictReader(open('import/Mobs.csv', encoding='utf-8'))
identifier = 1

for mob in mobs:
    mobs_ingredients = csv.DictReader(open('import/MobIngredientDrops.csv', encoding='utf-8'))
    spawnBehavior = mob['spawnBehavior']
    
    if spawnBehavior == 'Player Summoned':
        continue
    
    ingredients_possible_to_drop = []
    for mob_ingredient in mobs_ingredients:
        if mob_ingredient['mobID'] == mob['ID']:
            ingredients_possible_to_drop.append(mob_ingredient['ingredientID'])
            
    for i in range(20, random.randint(40, 60)):
        id = mob['ID']
        max_health = int(mob['healthPoints'])
        actual_health = random.randint(int(max_health * 0.25), max_health)
        coordinates_x = random.randint(MAP_COORDINATES_SCOPE[0], MAP_COORDINATES_SCOPE[1])
        coordinates_y = random.randint(MAP_COORDINATES_SCOPE[0], MAP_COORDINATES_SCOPE[1])
        
        has_item = random.random() < HAS_ITEM_CHANCE
        item_dropped_id = None
        if has_item and len(ingredients_possible_to_drop) > 0:
            item_dropped_id = random.choice(ingredients_possible_to_drop)
            
        with open('import/ActualMobs.csv', mode='a', encoding='utf-8', newline='') as file:
            writer = csv.writer(file)
            writer.writerow([identifier, id, actual_health, coordinates_x, coordinates_y, item_dropped_id])
            identifier += 1