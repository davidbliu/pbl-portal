import requests
import json
import psycopg2 

from time_converter import TimeConverter

class TablingNotifier:
    # Change here to correct post url
    POST_URL = 'https://wilson.berkeley-pbl.com/pablo/send/{id}'
    DBNAME = "'v2_development'"
    USER = "'postgres'"
    PASSWORD = "'password'"

    def __init__(self):
        self.conn = self.connect_to_db() 
        self.time_converter = TimeConverter()
        self.member_emails = self.get_tabling_times_with_members()

    def send_fb_message(self, msg, email):
        member_id = self.get_id_from_email(email, boolean_attribute='subscribed_to_tabling')
        if not member_id:
            return

        data = {"msg": msg}

        response = requests.post(self.POST_URL.format(id=member_id), json=data)
        if response.status_code != 200:
            print('Error {0}, failed to send message: {1}, to sender {2}, email {3}'.format(response.status_code, msg, member_id, email))
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
        for s in members_str.split(' '):
            if '@' in s:
                if s[-1] == '-':
                    s = s[:-1]
                members.append(s.strip())
        return members

    def notify_time_slots(self):
        self.member_emails = self.get_tabling_times_with_members()
        cur = self.conn.cursor()
        for time in self.member_emails.keys():
            time_as_string = self.time_converter.get_time_string(time)
            for email in self.member_emails[time]:
                self.send_fb_message("Hi {0}, your tabling slot this week is {1}".format(member[0],time_as_string), email)  

    def get_id_from_email(self, email, boolean_attribute=''): 
        cur = self.conn.cursor()
        cur.execute("""select name from members where email = '{}'""".format(email))
        member = cur.fetchall()[0]

        if boolean_attribute:
            cur.execute("""select {} from bot_members where name = '{}'""".format(boolean_attribute, member[0]))
            fetch = cur.fetchall()
            if not fetch or not fetch[-1][0]:
                return None

        cur.execute("""select id from bot_members where name = '{}'""".format(member[0]))
        fetch = cur.fetchall()
        return fetch[-1][0]

    def update(self):
        new_member_emails = self.get_tabling_times_with_members()
        for time in new_member_emails:
            if set(new_member_emails[time]) != set(self.member_emails[time]):
                changed_members = [m for m in new_member_emails[time] if m not in self.member_emails[time]]
                for member in changed_members:
                    if not self.time_converter.has_passed(time):
                        time_str = self.time_converter.get_time_string(time)
                        self.send_fb_message("Your tabling slot has been changed to {}".format(time_str), member)
        self.member_emails = new_member_emails

    def remind_time_slot(self, time):
        cur = self.conn.cursor()
        for email in self.member_emails[time]:
            hour_str = self.time_converter.get_hour(time)
            self.send_fb_message("Just a reminder that your tabling at {} starts in an hour".format(hour_str), email)
