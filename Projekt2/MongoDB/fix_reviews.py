import pandas as pd
import random

beer_csv = 'Projekt2/Mongo/datasets/beers.csv'
review_csv = 'Projekt2/Mongo/datasets/beer_reviews.csv'

beers = pd.read_csv(beer_csv)
reviews = pd.read_csv(review_csv)

output_file = 'Projekt2/Mongo/datasets/fixed_reviews.csv'

for review in reviews.itertuples():
    try:
        beer_name = review.beer_name
        beer_id = beers.loc[beers['name'] == beer_name, 'id'].values
        if len(beer_id) == 0:
            beer_id = random.choice(beers['id'].values)
        else:
            beer_id = beer_id[0]
            
        new_record = {
            "id": review.Index,
            "review_time": review.review_time,
            "review_overall": review.review_overall,
            "review_aroma": review.review_aroma,
            "review_appearance": review.review_appearance,
            "review_palate": review.review_palate,
            "review_taste": review.review_taste,
            "review_profilename": review.review_profilename,
            "beer_beerid": beer_id
        }

        with open(output_file, 'a') as f:
            f.write(','.join(map(str, new_record.values())) + '\n')
        
    except Exception as e:
        print(f"Error processing review ID {review.Index}: {e}")
