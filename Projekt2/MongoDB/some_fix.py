import pymongo
from pymongo.errors import OperationFailure

# Połączenie (direct connection jest ważne przy konfiguracji)
client = pymongo.MongoClient("mongodb://localhost:27017/", directConnection=True)

try:
    # Komenda administracyjna odpowiadająca wpisaniu rs.initiate()
    config = {'_id': 'rs0', 'members': [{'_id': 0, 'host': 'localhost:27017'}]}
    client.admin.command("replSetInitiate", config)
    print("✅ SUKCES: Replica Set 'rs0' został zainicjowany!")
    print("Teraz zrestartuj MongoDB Compass i wszystko powinno działać.")
    
except OperationFailure as e:
    if "already initialized" in str(e):
        print("ℹ️ Info: Replica Set jest już zainicjowany. Możesz działać.")
    else:
        print(f"❌ Błąd: {e}")