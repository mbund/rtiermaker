import requests
import os.path
request = requests.get("https://api.github.com/repos/mbund/rtiermaker/commits")

previous_commits = 0
if os.path.isfile("prev.txt"):
    f = open("prev.txt")
    lines = f.readlines()
    if len(lines) != 0:
        previous_commits = int(lines[0])

if len(request.json()) != previous_commits:
    print(len(request.json()))
    print("A new commit to rtiermaker has been made!")
    f = open("prev.txt", "w");
    f.write(str(len(request.json())))
else:
    print("No new commits have been made to rtiermaker, it wallows, lonely and dejected.")
