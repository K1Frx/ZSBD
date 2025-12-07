import pymongo
import time
from pprint import pprint

client = pymongo.MongoClient("mongodb://localhost:27017/")
db = client["ZSBD"]
beers_col = db["beers"]

pipeline = [
    { "$unwind": "$reviews" },
    {
        "$group": {
            "_id": "$reviews.review_profilename",
            "total_reviews": { "$sum": 1 }
        }
    },
    { "$sort": { "total_reviews": -1 } }
]

print("Bez indeksu:")

start_time = time.time()
results_no_index = list(beers_col.aggregate(pipeline))
end_time = time.time()
time_no_index = end_time - start_time

INDEX_NAME = "idx_review_profilename"
beers_col.create_index([("reviews.review_profilename", 1)], name=INDEX_NAME)

print("Z indeksem:")

start_time = time.time()
results_with_index = list(beers_col.aggregate(pipeline))
end_time = time.time()
time_with_index = end_time - start_time

beers_col.drop_indexes()

print(f"Czas bez indeksu: {time_no_index:.6f}")
print(f"Czas z indeksem: {time_with_index:.6f}")