import pymongo
import time

client = pymongo.MongoClient("mongodb://localhost:27017/")
db = client["ZSBD"]
beers_col = db["beers"]

pipeline_embed = [
    {
        "$project": {
            "name": 1,
            "avg_rating": { "$avg": "$reviews.review_overall" },
            "review_count": { "$size": { "$ifNull": ["$reviews", []] } }
        }
    },
    {
        "$match": {
            "review_count": { "$gt": 10 }
        }
    },
    { "$sort": { "avg_rating": -1 } },
    { "$limit": 5 }
]

results_embed = list(beers_col.aggregate(pipeline_embed))

for beer in results_embed:
    print(f"{beer['name']} | Średnia: {beer['avg_rating']:.2f} | Ilość recenzji: {beer['review_count']}")


pipeline_ref = [
    {
        "$lookup": {
            "from": "breweries",
            "localField": "brewery_id",
            "foreignField": "_id",
            "as": "brewery_info"
        }
    },
    { "$unwind": "$brewery_info" },
    {
        "$match": {
            "brewery_info.state": " CA"
        }
    },
    {
        "$project": {
            "name": 1,
            "brewery_name": "$brewery_info.name",
            "state": "$brewery_info.state"
        }
    }
]

results_ref = list(beers_col.aggregate(pipeline_ref))

for beer in results_ref:
    print(f"Piwo: {beer['name']} - Browar: {beer['brewery_name']} ({beer['state']})")
