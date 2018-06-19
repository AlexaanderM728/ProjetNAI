import turicreate as tc

# 1. ladowanie modelu
data = tc.SFrame('turi.sframe')

# 2. dzielenie zbioru na treninowy i testowy
train_data, test_data = data.random_split(0.9)

# 3. tworzenie modelu
model = tc.image_classifier.create(train_data, target='food')

# 4. pokazanie prognozy oceny
predictions = model.predict(test_data)

# 5. ocenianie modelu i pokazanie metryk
metrics = model.evaluate(test_data)
print(metrics['accuracy'])

# 6. zapis modelu
model.save('turi.model')

# 7. przekonwertuj na mlmodel
model.export_coreml('TuriCreate.mlmodel')