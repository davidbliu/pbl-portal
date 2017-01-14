import requests
import json
import psycopg2 

from time_converter import TimeConverter

class TablingNotifier:
    POST_URL = 'https://wilson.berkeley-pbl.com/pablo'
    DBNAME = "'v2_development'"
    USER = "'postgres'"
    PASSWORD = "'password'"

    def __init__(self):
        self.conn = self.connect_to_db() 
        self.member_emails = self.get_tabling_times_with_members()

    def send_fb_message(self, msg, email):
        sender_id = self.get_sender_id_from_email(email)
        if not sender_id:
            print('Person not found')
            return

        data = {"entry": [{"messaging": [{"sender": {"id": str(sender_id)}, "message": {"text": msg}}]}]}

        response = requests.post(self.POST_URL, json=data)
        if response.status_code != 200:
            print('Error {0}, failed to send message: {1}, to sender {2}'.format(response.status_code, msg, sender_id))
        return response

    def connect_to_db(self):
        try:
            conn = psycopg2.connect("dbname={dbname} user={user} host='localhost' password={password}".format(dbname=self.DBNAME, user=self.USER, password=self.PASSWORD))
        except:
            print("Unable to connect to PostgreSQL database")
        return conn

    def get_tabling_times_with_members(self):
        cur = self.conn.cursor()
        cur.execute("""select time, member_emails from tabling_slots""")
        rows = cur.fetchall()

        time_slot_members = {}
        for row in rows:
            time = row[0] # retrieves time as an integer
            member_emails = row[1] # retrieves emails as a string of emails
            time_slot_members[time] = self.parse_emails(member_emails)
            
        return time_slot_members

    def parse_emails(self, members_str):
        members = []
        # TODO change parsing method, does not work for emails with '-'
        for s in members_str.split('-'):
            if '@' in s:
                members.append(s.strip())
        return members

    def notify_time_slots(self):
        self.update()
        cur = self.conn.cursor()
        converter = TimeConverter()
        for time in self.member_emails.keys():
            time_as_string = converter.get_time_string(time)
            for email in self.member_emails[time]:
                self.send_fb_message("Hi {0}, your tabling slot this week is {1}".format(member[0],time_as_string), email)  

    def get_sender_id_from_email(self, email):
        cur = self.conn.cursor()
        cur.execute("""select name from members where email = '{}'""".format(email))
        member = cur.fetchall()[0]
        cur.execute("""select sender_id from bot_members where name = '{0}'""".format(member[0]))
        fetch = cur.fetchall()
        
        return fetch[-1][0] if fetch else None

    def update(self):
        new_member_emails = self.get_tabling_times_with_members()
#        for time in new_member_emails:
#            if set(new_member_emails[time]) != set(self.member_emails[time]):
#                changed_members = [m for m in new_member_emails[time] if m not in self.member_emails[time]]
#                for member in changed_members:
#                    self.

    def remind_time_slot(self, time):
        self.update()
        cur = self.conn.cursor()
        for email in self.member_emails[time]:
            hour = time % 24
            hour = (str(hour - 12) + 'pm') if hour > 12 else (str(hour) + 'am')
            self.send_fb_message("Just a reminder that your tabling at {0} starts in an hour".format(hour), email)

