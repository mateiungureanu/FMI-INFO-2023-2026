"""
l = [(160, F), (165, F), (155, F), (172, F), (175, B), (180, B), (177, B), (190, B)]
l_150_160 = [(155, F), (160, F)]
l_161_170 = [(165, F)]
l_171_180 = [(172, F), (175, B), (177, B), (180, B)]
l_181_190 = [(190, B)]

p_f = 1/2 # p(X)
p_b = 1/2
p_171_180 = 1/2 # p(Y)
p_b_171_180 = 3/4 # p(X|Y)
p_f_171_180 = 1/4

p_178_b = 3/4 * (1/2) / (1/2) # p(Y|X)
p_178_f = 1/2 * (1/2) / (1/2)
"""


import numpy as np
import matplotlib.pyplot as plt
from sklearn.naive_bayes import MultinomialNB
naive_bayes_model = MultinomialNB()

train_images = np.loadtxt('train_images.txt')
train_labels = np.loadtxt('train_labels.txt').astype('int')

test_images = np.loadtxt('test_images.txt')
test_labels = np.loadtxt('test_labels.txt').astype('int')

num_bins = 7
bins = np.linspace(start=0, stop=256, num=num_bins)

def values_to_bins(matrix, bins):
    return np.digitize(matrix, bins) - 1

train_images = values_to_bins(train_images, bins)
test_images = values_to_bins(test_images, bins)

naive_bayes_model.fit(train_images, train_labels)
array = naive_bayes_model.predict(test_images)
naive_bayes_model.score(test_images, test_labels)
for i in range(len(array)):
    if array[i] != test_labels[i]:
        image = train_images[i, :]
        image = np.reshape(image, (28, 28))
        plt.imshow(image.astype(np.uint8), cmap='gray')
        print("Aceasta iamgine a fost clasificata ca ", array[i], ".")
        plt.show()