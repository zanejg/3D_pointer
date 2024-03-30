from machine import Pin, SPI, I2C
import time

from dhylands_1602_display import I2cLcd
from rotary_irq_rp2 import RotaryIRQ

###########################################################
###               Display                           #######
###########################################################


## LCD DISPLAY ####
DEFAULT_I2C_ADDR = 0x27
i2c = I2C(id=0,scl=Pin(1), sda=Pin(0), freq=100000)
lcd = I2cLcd(i2c, DEFAULT_I2C_ADDR, 2, 16)

lcd.clear()
lcd.putstr(
"""String Measure
It works!""")
# time.sleep(3)
# lcd.clear()
BASE_VALUE = 0
LEN_COEFF = 449 # ticks per meter

rotary_val = BASE_VALUE


###########################################################
###             Rotary Switch                       #######
###########################################################
# init the rotary switch
rotary = RotaryIRQ(pin_num_clk=19, 
        pin_num_dt=21, 
        min_val=0, 
        max_val=10000, 
        reverse=True, 
        range_mode=RotaryIRQ.RANGE_UNBOUNDED)
rotary.set(value=BASE_VALUE)

###########################################################

def rotary_listener():
    global rotary_val
    rotary_val = rotary.value()
    print("ctr moved")

#     lcd.clear()
#     rotary_valstr = "{0:<9}".format(rotary_val)
#     ############0123456789ABCDEF#
#     lcd.putstr(
# """value={}
#               """.format(rotary_valstr))

rotary.add_listener(rotary_listener)

###########################################################
look_button = Pin(3, Pin.IN, Pin.PULL_UP)
def look_button_callback(p):
    global rotary_val
    # turn off irq while we are here
    look_button.irq(handler=None)

    print("button pressed")
    lcd.clear()
    rotary_valstr = "{0:<9}".format(rotary_val)
    ############0123456789ABCDEF#
    measurement = int((rotary_val * 1000)/LEN_COEFF)
    measurement_str = "{0:>11}".format(measurement)
    lcd.putstr(
"""value={}
{} mm""".format(rotary_valstr, measurement_str))
    time.sleep(0.2)
    look_button.irq(trigger=Pin.IRQ_FALLING, handler=look_button_callback)

look_button.irq(trigger=Pin.IRQ_FALLING, handler=look_button_callback)

###########################################################
zero_button = Pin(12, Pin.IN, Pin.PULL_UP)
def zero_button_callback(p):
    global rotary_val
    # turn off irq while we are here
    zero_button.irq(handler=None)

    print("zero button pressed")
    rotary_val = BASE_VALUE
    rotary.set(value=BASE_VALUE)

    lcd.clear()
    rotary_valstr = "{0:<9}".format(rotary_val)
    ############0123456789ABCDEF#
    lcd.putstr(
"""value={}
              """.format(rotary_valstr))
    time.sleep(0.2)
    zero_button.irq(trigger=Pin.IRQ_FALLING, handler=zero_button_callback)

zero_button.irq(trigger=Pin.IRQ_FALLING, handler=zero_button_callback)

