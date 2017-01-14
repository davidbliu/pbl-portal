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
        hour_string = "{0}:00".format(h) + half
        return hour_string
    
