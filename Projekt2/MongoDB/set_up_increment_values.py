import pymongo

client = pymongo.MongoClient("mongodb://localhost:27017/")
db = client["ZSBD"]
beers_col = db["beers"]
breweries_col = db["breweries"]
counters_col = db["counters"]

last_beer = beers_col.find_one(sort=[("_id", -1)])
max_beer_id = last_beer["_id"] if last_beer else 0

counters_col.update_one(
    {"_id": "beer_id"},
    {"$set": {"seq": max_beer_id}},
    upsert=True
)
print(f"Licznik 'beer_id' ustawiony na: {max_beer_id}")

last_brewery = breweries_col.find_one(sort=[("_id", -1)])
max_brewery_id = last_brewery["_id"] if last_brewery else 0

counters_col.update_one(
    {"_id": "brewery_id"},
    {"$set": {"seq": max_brewery_id}},
    upsert=True
)
print(f"Licznik 'brewery_id' ustawiony na: {max_brewery_id}")

pipeline = [
    { "$unwind": "$reviews" },
    { 
        "$group": {
            "_id": None,
            "max_id": { "$max": "$reviews.review_original_id" }
        }
    }
]

res = list(beers_col.aggregate(pipeline))
max_review_id = res[0]["max_id"] if res else 0

if not isinstance(max_review_id, (int, float)):
    max_review_id = 0

counters_col.update_one(
    {"_id": "review_id"},
    {"$set": {"seq": max_review_id}},
    upsert=True
)
print(f"Licznik 'review_id' ustawiony na: {max_review_id}")

