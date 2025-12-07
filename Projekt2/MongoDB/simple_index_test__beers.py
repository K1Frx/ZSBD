import pymongo

client = pymongo.MongoClient("mongodb://localhost:27017/")
db = client["ZSBD"]
beers_col = db["beers"]

styles_list = [
    "American Pale Ale (APA)",
    "American Pale Ale",
    "APA"
]

pipeline = [
    {"style": {"$in": styles_list } }
]

beers_col.drop_indexes() 

print("Indeks prosty na polu '_id' został utworzony.")
print("Testowanie wydajności zapytań z użyciem indeksu...")
import time
start_time = time.time()
results = list(beers_col.find({"_id": {"$in": [1, 2, 3, 4, 5]}}))
end_time = time.time()
print(f"Czas wykonania zapytania bez indeksu: {end_time - start_time:.6f} sekund.")

beers_col.create_index([("style", 1)])
print("Indeks prosty na polu 'style' został utworzony.")
print("Testowanie wydajności zapytań z użyciem indeksu na 'style'...")
start_time = time.time()
results = list(beers_col.find({"style": {"$in": styles_list}}))
end_time = time.time()
print(f"Czas wykonania zapytania z indeksem: {end_time - start_time:.6f} sekund.")

beers_col.drop_indexes()