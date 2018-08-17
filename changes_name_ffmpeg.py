import os
path = './'

i = 1
target_directory = os.getenv('target_directory')
files = os.listdir(target_directory)

for file in files:
	if '.jpg' in file:
		os.rename(os.path.join(target_directory, file), os.path.join(target_directory, str(i)+'.jpg'))
		i = i+1