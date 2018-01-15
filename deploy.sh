fuser -k 3000/tcp
fuser -k 3001/tcp
fuser -k 3002/tcp
nohup rails s -p 3000 -e production -b 0.0.0.0 -P tmp/pids/server1.pid &
nohup rails s -p 3001 -e production -b 0.0.0.0 -P tmp/pids/server2.pid &
nohup rails s -p 3002 -e production -b 0.0.0.0 -P tmp/pids/server3.pid &
