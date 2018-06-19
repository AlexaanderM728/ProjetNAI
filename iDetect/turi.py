import turicreate as tc
import os

# 1. ladowanie zdjec
data = tc.image_analysis.load_images('dataset', with_path=True)

# 2. tworzenie kolumn na podstawie nazw folderow obiektorw
data['food'] = data['path'].apply(lambda path: os.path.basename(os.path.dirname(path)))

# 3. zapis na .sframe
data.save('turi.sframe')

# 4. przejrzenie zbioru
data.explore()
