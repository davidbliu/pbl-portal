import datetime
from pytz import timezone, utc
from datetime import datetime

class TimeConverter:
    DAY_STRINGS = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    
    def get_time_string(self, time):
        return self.get_day(time) + ' at ' + self.get_hour(time)

    def get_day(self, time):
        day = time // 24
        day_strings = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
        day_string = day_strings[day]
        return day_string

    def get_hour(self, time):
        hour = time % 24
        h = hour % 12
        if h == 0:
            h = 12
        half = 'pm' if hour >= 12 else 'am'
        hour_string = str(h) + half
        return hour_string

    def utc_to_pacific(self, time):
        tz = timezone('America/Los_Angeles')
        return utc.localize(time).astimezone(tz)
    
    def eastern_to_pacific(self, time):
        pacific = timezone('America/Los_Angeles')
        eastern = timezone('America/New_York')
        return eastern.localize(time).astimezone(pacific)

    def now(self):
        return datetime.now()
    
    def has_passed(self, time):
        hour, week_day = time % 24, time // 24
        # Change utc_to_pacific to eastern_to_pacific if the server runs on eastern time, or if the server is one pacific time, set current = self.now()
        # current = self.utc_to_pacific(self.now())
        current = self.now()
        current_h, current_d = current.hour, current.weekday()
        return week_day == 6 or  week_day < current_d or (hour < current_h and week_day == current_d)
