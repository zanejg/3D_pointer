import smbus
import math
import time
import pdb


class accelerometer(object):
    # Register
    power_mgmt_1 = 0x6b
    power_mgmt_2 = 0x6c
    bus = smbus.SMBus(1) # bus = smbus.SMBus(0) fuer Revision 1
    address = 0x68       # via i2cdetect
    
    
    def __init__(self):
        
        # Activate to be able to address the module
        self.bus.write_byte_data(self.address, self.power_mgmt_1, 0)
            
        
    
    def read_byte(self, reg):
        return self.bus.read_byte_data(self.address, reg)
    
    def read_word(self, reg):
        h = self.bus.read_byte_data(self.address, reg)
        l = self.bus.read_byte_data(self.address, reg+1)
        value = (h << 8) + l
        return value
    
    def read_word_2c(self, reg):
        val = self.read_word(reg)
        #pdb.set_trace()
        if (val >= 0x8000):
            return -((65535 - val) + 1)
        else:
            return val
    
    def dist(self, a,b):
        return math.sqrt((a*a)+(b*b))
    
    def get_y_rotation(self, x,y,z):
        radians = math.atan2(x, dist(y,z))
        return -math.degrees(radians)
    
    def get_x_rotation(self, x,y,z):
        radians = math.atan2(y, dist(x,z))
        return math.degrees(radians)

    def get_z_rotation(self, x,y,z):
        radians = math.atan2(z, dist(x,y))
        return math.degrees(radians)
    
    def get_rot(self):
        acc = self.get_accel()
        
        return {
            'x': get_x_rotation(acc['x'], acc['y'], acc['z']),
            'y': get_y_rotation(acc['x'], acc['y'], acc['z']),
            'z': get_z_rotation(acc['x'], acc['y'], acc['z']),
        }
    
    
    def get_accel(self):
        """
        Returns dict of the 3 accelerations
        """
        acceleration_xout = self.read_word_2c(0x3b)
        acceleration_yout = self.read_word_2c(0x3d)
        acceleration_zout = self.read_word_2c(0x3f)
        #denom = 16384.0
        denom = 1
            
        return {
            'x': acceleration_xout / denom,
            'y': acceleration_yout / denom,
            'z': acceleration_zout / denom,
            }
    
    def get_gyro(self):
        
        gyro_x = self.read_word_2c(0x43)
        gyro_y = self.read_word_2c(0x45)
        gyro_z = self.read_word_2c(0x47)
        
        return {
            "x":gyro_x,
            "y":gyro_y,
            "z":gyro_z,
        }
    

