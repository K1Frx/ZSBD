import pymongo
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure, OperationFailure
from functions import *

client = MongoClient("mongodb://localhost:27017/")
db = client["ZSBD"]
beers_col = db["beers"]
breweries_col = db["breweries"]

def delete_brewery_safely(brewery_id_to_delete):
    with client.start_session() as session:
        with session.start_transaction():
            try:
                delete_beers_result = beers_col.delete_many(
                    {"brewery_id": brewery_id_to_delete}, 
                    session=session
                )
                print(f"Usunięto {delete_beers_result.deleted_count} piw.")

                delete_brewery_result = breweries_col.delete_one(
                    {"_id": brewery_id_to_delete}, 
                    session=session
                )
                
                if delete_brewery_result.deleted_count == 0:
                    raise Exception("Nie znaleziono browaru! Wycofuję transakcję.")

                print(f"Usunięto browar {brewery_id_to_delete}.")

                raise Exception("Symulowany błąd krytyczny!")
            
            except Exception as e:
                print(f"BŁĄD: {e}")
                session.abort_transaction()
                print("ROLLBACK: Wszystkie zmiany zostały cofnięte.")


add_brewery_id = add_brewery("Transakcyjny Browar", "CA", "Los Angeles")
beer1 = add_beer("Transakcyjne Piwo 1", "APA", 0.06, add_brewery_id)
beer2 = add_beer("Transakcyjne Piwo 2", "IPA", 0.07, add_brewery_id)

delete_brewery_safely(add_brewery_id)

print("\n--- WERYFIKACJA ---")
print("Czy browar istnieje?", breweries_col.find_one({"_id": add_brewery_id}))
print("Ile zostało piw tego browaru?", beers_col.count_documents({"brewery_id": add_brewery_id}))