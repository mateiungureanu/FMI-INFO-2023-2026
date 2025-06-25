import numpy as np
import matplotlib.pyplot as plt

train_images = np.loadtxt('train_images.txt')
train_labels = np.loadtxt('train_labels.txt').astype('int')

test_images = np.loadtxt('test_images.txt')
test_labels = np.loadtxt('test_labels.txt').astype('int')

class KnnClasifier:

    def __init__(self, train_images, train_labels):
        self.train_images = train_images
        self.train_labels = train_labels

    def classify_image(self, test_image, num_neighbors = 3, metric = 'l2'):
        distances = []
        if metric == 'l2':
            distances = np.sqrt(np.sum((self.train_images - test_image) ** 2, axis=1))
        if metric == 'l1':
            distances = np.sum(np.abs(test_image - self.train_images), axis=1)
        array = np.argsort(distances)[:num_neighbors]
        labels = self.train_labels[array]
        return np.argmax(np.bincount(labels))

    def accuracy(self, test_images, test_labels, num_neighbors = 3, metric = 'l2'):
        acc = 0
        for i in range(len(test_images)):
            if obj.classify_image(test_images[i], num_neighbors, metric) == test_labels[i]:
                acc += 1
        acc /= len(test_images)
        return acc

obj = KnnClasifier(train_images, train_labels)
print(obj.classify_image(test_images[1]))
print(obj.accuracy(test_images, test_labels))

x = [1, 3, 5, 7, 9]
y_l2 = [obj.accuracy(test_images, test_labels, num_neighbors = i) for i in x]
y_l1 = [obj.accuracy(test_images, test_labels, num_neighbors = i, metric = 'l1') for i in x]
plt.plot(x, y_l2)
plt.plot(x, y_l1)
plt.xlabel('Number of neighbors')
plt.ylabel('Accuracy')
plt.legend(['L2', 'L1'])
plt.show()