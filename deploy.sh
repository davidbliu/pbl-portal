fuser -k 3000/tcp
fuser -k 3001/tcp
fuser -k 3002/tcp
nohup rails s -p 3000 -e production &
nohup rails s -p 3001 -e production &
nohup rails s -p 3002 -e production &
