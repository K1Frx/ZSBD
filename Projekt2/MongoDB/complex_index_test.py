import pymongo
import time

client = pymongo.MongoClient("mongodb://localhost:27017/")
db = client["ZSBD"]
beers_col = db["beers"]
COLLECTION_NAME = "beers"

pipeline = [
    { "$unwind": "$reviews" },
    {
        "$project": {
            "_id": 0,
            "profilename": "$reviews.review_profilename",
            "review_overall": "$reviews.review_overall",
            "beer_name": "$name"
        }
    },
    {
        "$sort": {
            "profilename": 1, 
            "review_overall": -1 
        }
    },
    {
        "$group": {
            "_id": "$profilename",
            "top_reviews_list": {
                "$push": {
                    "beer_name": "$beer_name",
                    "rating": "$review_overall"
                }
            }
        }
    },
    {
        "$project": {
            "favorite_beers": { "$slice": ["$top_reviews_list", 10] }
        }
    }
]

try:
    beers_col.drop_indexes()
except:
    pass

start_time = time.time()
results_no_index = list(beers_col.aggregate(pipeline)) 
end_time = time.time()
time_no_index = end_time - start_time


INDEX_NAME = "idx_profile_rating_compound"
beers_col.create_index(
    [("reviews.review_profilename", 1), ("reviews.review_overall", -1)], 
    name=INDEX_NAME
)

start_time = time.time()
results_with_index = list(beers_col.aggregate(pipeline))
end_time = time.time()
time_with_index = end_time - start_time

beers_col.drop_index(INDEX_NAME)

print(f"Czas bez indeksu: {time_no_index:.6f} s")
print(f"Czas z indeksem:  {time_with_index:.6f} s")