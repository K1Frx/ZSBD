import pymongo
from datetime import datetime

client = pymongo.MongoClient("mongodb://localhost:27017/")
db = client["ZSBD"]
beers_col = db["beers"]
breweries_col = db["breweries"]
counters_col = db["counters"] # Nowa kolekcja techniczna


def get_next_sequence(sequence_name):
    counter = counters_col.find_one_and_update(
        {"_id": sequence_name},
        {"$inc": {"seq": 1}},
        upsert=True,
        return_document=pymongo.ReturnDocument.AFTER
    )
    return counter["seq"]

def avg(*args):
    sum = 0
    count = 0
    for val in args:
        try:
            sum += float(val)
            count += 1
        except:
            continue
        
    return sum / count if count > 0 else None

def add_review_logic(beer_id, username, review_aroma=None, review_apperance=None, review_palate=None, review_taste=None):
    new_review_id = get_next_sequence("review_id")
    
    rating = avg(
        review_aroma,
        review_apperance,
        review_palate,
        review_taste
    )
    
    new_review = {
        "review_id": new_review_id,
        "review_time": datetime.now().timestamp(),
        "review_overall": float(rating),
        "review_profilename": username,
        "review_aroma": review_aroma,
        "review_appearance": review_apperance,
        "review_palate": review_palate,
        "review_taste": review_taste
    }

    result = beers_col.update_one(
        {"_id": beer_id},
        {"$push": {"reviews": new_review}}
    )

    if result.modified_count == 0:
        print(f"Błąd: Nie znaleziono piwa o ID {beer_id}")
        return

    print(f"Dodano recenzję ID: {new_review_id} dla piwa {beer_id}.")
    return new_review_id

def add_brewery(name, city, state):
    new_id = get_next_sequence("brewery_id")
    
    doc = {
        "_id": new_id,
        "name": name,
        "city": city,
        "state": state
    }
    breweries_col.insert_one(doc)
    print(f"Dodano browar: {name} (ID: {new_id})")
    return new_id

def add_beer(name, style, abv, brewery_id):
    if not breweries_col.find_one({"_id": brewery_id}):
        print("Błąd: Taki browar nie istnieje!")
        return

    new_id = get_next_sequence("beer_id")
    doc = {
        "_id": new_id,
        "name": name,
        "style": style,
        "abv": abv,
        "brewery_id": brewery_id,
        "reviews": [],
        "avg_overall_rating": 0
    }
    beers_col.insert_one(doc)
    print(f" Dodano piwo: {name} (ID: {new_id})")
    return new_id

def delete_beer_by_id(beer_id: int):
    beer_to_delete = beers_col.find_one({"_id": beer_id})
    
    if not beer_to_delete:
        print(f"Blad: Piwo o ID {beer_id} nie zostalo znalezione.")
        return 0

    result = beers_col.delete_one({"_id": beer_id})
    
    if result.deleted_count > 0:
        print(f"Sukces: Piwo '{beer_to_delete['name']}' (ID: {beer_id}) wraz z recenzjami zostalo usuniete.")
        return result.deleted_count
    else:
        print(f"Blad: Nie udalo sie usunac piwa o ID {beer_id}.")
        return 0

def update_brewery(brewery_id: int, name:str = None, city:str = None, state:str = None):
    update_fields = {}
    
    if name is not None:
        update_fields["name"] = name
    if city is not None:
        update_fields["city"] = city
    if state is not None:
        update_fields["state"] = state

    try:
        result = breweries_col.update_one(
            {"_id": brewery_id},
            {"$set": update_fields}
        )
    except Exception as e:
        print(f"Wystąpił błąd podczas aktualizacji: {e}")
        return 0

    print(f"Sukces: Zaktualizowano browar ID {brewery_id}.")
    return 1

update_brewery(31, name="Politechnika Polska Browarnictwo S.A.", city="Malutkie miasto za bugiem", state="PL")
