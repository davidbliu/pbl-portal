Installation

- Python 3
- Run 'pip install -r requirements.txt' to install all needed libraries

USING

In tabling_notifications.py, change POST_URL to the correct URL
In time_converter.py, in the 'has_passed' function, use the correct 'utc_to_pacific' or 'easter_to_pacific' function depending on your server time

In order to change the server time to Pacific:

cd /etc
rm localtime
ln -s /usr/share/zoneinfo/America/Los_Angeles localtime


To start the program

Run 'python scheduler.py'
