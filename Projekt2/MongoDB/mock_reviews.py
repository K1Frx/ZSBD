import pymongo
from collections import defaultdict

# --- 1. KONFIGURACJA ---
MONGO_URI = "mongodb://localhost:27017/"
DB_NAME = "ZSBD"

# UWAGA: Sprawdź w Compassie, czy nazwy kolekcji są DOKŁADNIE takie jak poniżej:
REVIEWS_COLLECTION_NAME = "REVIEWS"
BEERS_COLLECTION_NAME = "BEERS"     # Czasem jest "beers", czasem "Beers" - sprawdź wielkość liter
BREWERIES_COLLECTION_NAME = "BREWERIES" # U Ciebie było "B", zmieniłem na "Breweries" (sprawdź to!)

# Kolekcje docelowe (po transformacji)
TARGET_BEERS_COLLECTION_NAME = "beers"
TARGET_BREWERIES_COLLECTION_NAME = "breweries"

# --- 2. POŁĄCZENIE Z BAZĄ DANYCH ---
client = pymongo.MongoClient(MONGO_URI)
db = client[DB_NAME]

# Czyścimy kolekcję docelową przed startem
db[TARGET_BEERS_COLLECTION_NAME].drop()

# Uchwyty do kolekcji
reviews_col = db[REVIEWS_COLLECTION_NAME]
beers_col = db[BEERS_COLLECTION_NAME]
breweries_col = db[BREWERIES_COLLECTION_NAME]
target_beers_col = db[TARGET_BEERS_COLLECTION_NAME]

print(f"Połączono z bazą {DB_NAME}. Rozpoczynam transformację...")

# --- 3. PRZYGOTOWANIE RECENZJI (GRUPOWANIE) ---

print("Grupowanie recenzji według ID piwa...")

reviews_by_beer_id = defaultdict(list)

# Iteracja przez wszystkie recenzje
count = 0
for review in reviews_col.find({}):
    # --- ZABEZPIECZENIE TYPÓW (Kluczowe dla poprawnego łączenia) ---
    beer_id = review.get("beer_beerid")
    # --------------------------------------------------------------
    nested_review = {
        "review_original_id": review.get("id"),
        "review_time": review.get("review_time"),
        "review_overall": review.get("review_overall"),
        "review_aroma": review.get("review_aroma"),
        # Naprawiamy literówkę: pobieramy z błędnego pola, zapisujemy do poprawnego
        "review_appearance": review.get("review_apperance"), 
        "review_palate": review.get("review_palate"),
        "review_taste": review.get("review_taste"),
        "review_profilename": review.get("review_profilename")
    }
    
    reviews_by_beer_id[beer_id].append(nested_review)
    count += 1

print(f"Przetworzono {count} recenzji dla {len(reviews_by_beer_id)} unikalnych piw.")

# --- 4. TWORZENIE ZAGNIEŻDŻONYCH DOKUMENTÓW (EMBEDDING) ---

print("Tworzenie zagnieżdżonych dokumentów Piw...")

beers_to_insert = []

for beer in beers_col.find({}):
    # --- ZABEZPIECZENIE TYPÓW DLA PIWA ---
    raw_id = beer.get("id")
    try:
        beer_id = int(raw_id) if raw_id is not None else None
    except ValueError:
        continue
    # -------------------------------------

    # 1. ZAGNIEŻDŻANIE: Pobranie listy recenzji ze słownika
    nested_reviews = reviews_by_beer_id.get(beer_id, [])
    
    # 2. REFERENCJA: Przygotowanie dokumentu Piwa
    new_beer_doc = {
        "_id": beer_id,              
        "name": beer.get("name"),
        "abv": beer.get("abv"),
        "ibu": beer.get("ibu"),
        "style": beer.get("style"),
        "ounces": beer.get("ounces"),
        "brewery_id": beer.get("brewery_id"), 
        "reviews": nested_reviews,            
        "avg_overall_rating": None            
    }
    
    beers_to_insert.append(new_beer_doc)

# Wstawianie w paczkach (batch insert) jest bezpieczniejsze
if beers_to_insert:
    try:
        target_beers_col.insert_many(beers_to_insert)
        print(f"Sukces! Wstawiono {len(beers_to_insert)} dokumentów do kolekcji '{TARGET_BEERS_COLLECTION_NAME}'.")
    except Exception as e:
        print(f"Błąd podczas wstawiania piw: {e}")

# --- 5. AKTUALIZACJA KOLEKCJI BROWARÓW ---
# Przepisanie browarów do nowej kolekcji ze zmianą id na _id

db[TARGET_BREWERIES_COLLECTION_NAME].drop()

print("Transformacja browarów...")
breweries_col.aggregate([
    {
        "$set": { "_id": "$id" } # Kopiujemy id do _id
    },
    {
        "$project": { "id": 0 }  # Usuwamy stare id
    },
    {
        "$out": TARGET_BREWERIES_COLLECTION_NAME # Zapisujemy w nowej kolekcji
    }
])

print(f"Zakończono. Twoje nowe kolekcje to '{TARGET_BEERS_COLLECTION_NAME}' i '{TARGET_BREWERIES_COLLECTION_NAME}'.")