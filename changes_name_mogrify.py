import os
import shutil
i = 1
divisor=int(os.getenv('numprocessors'))
source_directory = os.getenv('source_directory')
target_directory = os.getenv('target_directory')
if(divisor < 5):
    	divisor = 5
elif divisor > 10:
    	divisor = 10

files = os.listdir(source_directory)
print len(files)//10 + 1
for file in files:
	if '.jpg' in file:
		shutil.copy(os.path.join(source_directory, file), os.path.join(target_directory, str(i//divisor)+ '-' + str(i)+'.jpg'))
		i = i+1