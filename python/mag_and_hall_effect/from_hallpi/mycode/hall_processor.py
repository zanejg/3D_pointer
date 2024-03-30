## this is a class that processes the hall encoder data
## it will be instantiated by the hall_reader.py script
## and will maintain a running state of the encoder data
## it will calculate the rotation of the magnet from the X and Y values
## and will store the data in a memcache instance


import memcache
import json
import time
import math


class hall_processor:
    def __init__(self,mc):
        self.mc = mc
        self.peak_x_value = 0
        self.trough_x_value = 0
        self.peak_y_value = 0
        self.trough_y_value = 0
        self.calculated_X_angle = 0
        self.calculated_Y_angle = 0
        self.calculated_rotation = 0
        self.delta_time = 0

    def process_data(self):
        # we are going keep track of where the magnet is
        # in the X and Y dimensions
        # we will use the peak and trough values to determine
        # the rotation of the magnet
        if self.peak_x_value == 0:
            self.peak_x_value = self.mc.get("peak_x_value")
            self.trough_x_value = self.mc.get("trough_x_value")
            self.peak_y_value = self.mc.get("peak_y_value")
            self.trough_y_value = self.mc.get("trough_y_value")
        




