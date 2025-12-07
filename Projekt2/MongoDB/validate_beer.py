from functions import *
import pymongo

client = pymongo.MongoClient("mongodb://localhost:27017/")
db = client["ZSBD"]

validator = {
    "$jsonSchema": {
        "bsonType": "object",
        "required": ["name", "abv"],
        "properties": {
            "name": {
                "bsonType": "string",
                "description": "musi byc stringiem i jest wymagane"
            },
            "abv": {
                "bsonType": "double",
                "minimum": 0.0,
                "maximum": 100.0,
                "description": "musi byc double w zakresie 0-100"
            }
        }
    }
}

db.command("collMod", "beers", validator=validator, validationLevel="strict")

add_brewery_id = add_brewery("Transakcyjny Browar", "CA", "Los Angeles")
try:
    beer1 = add_beer("Transakcyjne Piwo 1", "APA", 0.06, add_brewery_id)
    print("Dodano piwo 1 pomyślnie.")
    beer2 = add_beer("Transakcyjne Piwo 2", "IPA", -0.07, add_brewery_id)
    print("Dodano piwo 2 pomyślnie.")
except Exception as e:
    print("Błąd podczas bloku dodawania piwa, reszta operacji została przerwana.")
    print("Szczegóły błędu:", e)