import os,random

image_files = []
valid_files = []
os.chdir(os.path.join("data", "obj"))
for filename in os.listdir(os.getcwd()):
    if filename.endswith(".jpg") or filename.endswith(".png"):
        image_files.append("data/obj/" + filename)
        if random.random() > 0.7:
            valid_files.append("data/obj/" + filename)
os.chdir("..")
with open("train.txt", "w") as outfile:
    for image in image_files:
        outfile.write(image)
        outfile.write("\n")
    outfile.close()
with open("valid.txt", "w") as outfile:
    for image in valid_files:
        outfile.write(image)
        outfile.write("\n")
    outfile.close()
os.chdir("..")