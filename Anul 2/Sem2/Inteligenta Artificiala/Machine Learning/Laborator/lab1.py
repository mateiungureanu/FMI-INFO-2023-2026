import numpy as np
from skimage import io
import matplotlib.pyplot as plt

suma_totala = 0
suma_max = 0
index = 0
l = []
print("c.")
for i in range(9):
    image = np.load(f"car_{i}.npy")
    suma = np.sum(image, axis=(0,1))
    l.append(image)
    print("Imaginea ", i, "= ", suma)
    suma_totala += np.sum(image)
    if suma > suma_max:
        suma_max = suma
        index = i

mean_image = np.mean(l, axis=0)
plt.imshow(mean_image.astype(np.uint8))

print("b. Suma totala = ", suma_totala)
print("d. Indexul imaginii cu suma maxima = ", index)

deviatia_standard = np.std(l, axis=0)
print("f. Deviatia standard = ", deviatia_standard)
for image in l:
    image = image.astype(np.float64)
    image -= mean_image
    image /= deviatia_standard

for image in l:
    image = image[200:300, 280:400]