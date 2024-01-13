from PIL import Image
import os

# Define the input directory and the desired output filename
input_dir = "C:\Projects\Rift Program\inputs"
output_filename = "Rift Program\output.png"

# Load the input images
images = []
for filename in os.listdir(input_dir):
    if filename.endswith(".png"):
        filepath = os.path.join(input_dir, filename)
        image = Image.open(filepath)
        images.append(image)

# Crop 175 pixels off the bottom of each image
cropped_images = []
for image in images:
    width, height = image.size
    cropped_image = image.crop((0, 0, width, height))#-175))
    cropped_images.append(cropped_image)

# Create a new image to hold the final composition
num_images = len(cropped_images)
composition_width = cropped_images[0].width * min(num_images, 4)
composition_height = cropped_images[0].height * ((num_images + 3) // 4)
composition = Image.new("RGB", (composition_width, composition_height))

# Place the cropped images in the composition
for i, cropped_image in enumerate(cropped_images):
    x = (i % 4) * cropped_image.width
    y = (i // 4) * cropped_image.height
    composition.paste(cropped_image, (x, y))

# Save the final composition
composition.save(output_filename)