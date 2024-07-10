from transformers import TrOCRProcessor, VisionEncoderDecoderModel
import cv2
import numpy as np
from skimage.filters import threshold_otsu
from heapq import heappush, heappop
from PIL import Image

# Load the image
img = cv2.imread("uploads/uploadHealthPrescriptions/prescription.jpg")
grayscale = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

def horizontal_projections(sobel_image):
    return np.sum(sobel_image, axis=1)

def binarize_image(image):
    threshold = threshold_otsu(grayscale)
    return image < threshold

binarized_image = binarize_image(grayscale)
hpp = horizontal_projections(binarized_image)

def find_peak_regions(hpp, threshold):
    peaks = []
    for i, hppv in enumerate(hpp):
        if hppv < threshold:
            peaks.append([i, hppv])
    return peaks

threshold = (np.max(hpp) - np.min(hpp)) / 2
peaks = find_peak_regions(hpp, threshold)
peaks_indexes = np.array(peaks)[:, 0].astype(int)

segmented_img = np.copy(grayscale)
r, c = segmented_img.shape
for ri in range(r):
    if ri in peaks_indexes:
        segmented_img[ri, :] = 0

diff_between_consec_numbers = np.diff(peaks_indexes)
indexes_with_larger_diff = np.where(diff_between_consec_numbers > 1)[0].flatten()
peak_groups = np.split(peaks_indexes, indexes_with_larger_diff)
peak_groups = [item for item in peak_groups if len(item) > 10]
print("peak groups found", len(peak_groups))

def heuristic(a, b):
    return (b[0] - a[0]) ** 2 + (b[1] - a[1]) ** 2

def astar(array, start, goal):
    neighbors = [(0, 1), (0, -1), (1, 0), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]
    close_set = set()
    came_from = {}
    gscore = {start: 0}
    fscore = {start: heuristic(start, goal)}
    oheap = []
    heappush(oheap, (fscore[start], start))
    
    while oheap:
        current = heappop(oheap)[1]
        if current == goal:
            data = []
            while current in came_from:
                data.append(current)
                current = came_from[current]
            return data
        close_set.add(current)
        for i, j in neighbors:
            neighbor = current[0] + i, current[1] + j
            tentative_g_score = gscore[current] + heuristic(current, neighbor)
            if 0 <= neighbor[0] < array.shape[0]:
                if 0 <= neighbor[1] < array.shape[1]:
                    if array[neighbor[0]][neighbor[1]] == 1:
                        continue
                else:
                    continue
            else:
                continue
            if neighbor in close_set and tentative_g_score >= gscore.get(neighbor, 0):
                continue
            if tentative_g_score < gscore.get(neighbor, 0) or neighbor not in [i[1] for i in oheap]:
                came_from[neighbor] = current
                gscore[neighbor] = tentative_g_score
                fscore[neighbor] = tentative_g_score + heuristic(neighbor, goal)
                heappush(oheap, (fscore[neighbor], neighbor))
    return []

# Load the locally saved TrOCR processor and model
processor = TrOCRProcessor.from_pretrained("./trocr_processor_large")
model = VisionEncoderDecoderModel.from_pretrained("./trocr_model_large")

def ocr_image(src_img):
    pixel_values = processor(images=src_img, return_tensors="pt").pixel_values
    generated_ids = model.generate(pixel_values)
    return processor.batch_decode(generated_ids, skip_special_tokens=True)[0]

page_text = ''
for index, sub_image_index in enumerate(peak_groups):
    sub_image = img[sub_image_index[0]:sub_image_index[-1]]
    page_text = page_text + '\n' + ocr_image(sub_image)

print(page_text)
