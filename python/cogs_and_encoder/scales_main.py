from machine import Pin, SPI, I2C
import time

from hx711 import HX711
import max7219_8digit
from dhylands_1602_display import I2cLcd



OFFSET = 4650
GRAM_COEFF = 0.002912589


###########################################################
###               Display                           #######
###########################################################
#Intialize the SPI for the display
spi = SPI(0, baudrate=10000000, polarity=1, phase=0, sck=Pin(2), mosi=Pin(3))
ss = Pin(5, Pin.OUT)
# init the display
display = max7219_8digit.Display(spi, ss)

leftstr = "gr  "
display_str = "{}8  8".format(leftstr)
display.write_to_buffer(display_str)


## LCD DISPLAY ####
DEFAULT_I2C_ADDR = 0x27
i2c = I2C(id=0,scl=Pin(1), sda=Pin(0), freq=100000)
lcd = I2cLcd(i2c, DEFAULT_I2C_ADDR, 2, 16)

lcd.clear()
lcd.putstr("Zane's Scales\nIt works!")
time.sleep(3)
lcd.clear()

units = "grams"
def write_grams_LCD(weight):
    global units

    
    #lcd.clear()
    wtstr = "{0:<6}".format(weight)
    unitstr = ("{0:<10}".format(units))
    #########        ###0123456789ABCDEF#
    lcd.putstr("{w}{u}\n                ".format(w=wtstr, u = unitstr))

def write_pounds_and_ounces_LCD(pounds, ounces):
    global units

    
    #lcd.clear()
    lbs = "{0:.0f}".format(pounds)
    lbstr = "{0:<2}".format(lbs)
    ozs = "{0:.1f}".format(ounces)
    ozstr = "{0:<4}".format(ozs)

    wtstr = ("{lb} lb {oz} oz   ".format(lb=lbstr, oz=ozstr))
    #######     0123456789ABCDEF#
    lcd.putstr("{w}\n                ".format(w=wtstr))





def write_right(the_str):
    if len(the_str) > 4:
        the_str = the_str[:4]
    if len(the_str) < 4:
        for i in range(0,4-len(the_str)):
            the_str+=" "

    display.write_to_buffer("{}{}".format(leftstr,the_str))
    display.display()
    


KGLB_COEFF = 2.20462

class scales(object):
    def __init__(self,sample_size):
        self.offset = 0
        self.coeff = GRAM_COEFF
        self.sample_size = sample_size
        
        self.checking_tare = False
        
        self.adc = HX711(d_out=14, pd_sck=15)
        
        self.find_offset()

    def read_loop(self):
        global leftstr
        global units
        while(not self.checking_tare):
            
            raw_reading = self.adc.read()
            
            #print("raw={}".format(raw_reading))
            
            grams = (raw_reading - self.offset) * self.coeff
            # stop the -0 flicker
            if abs(grams) < 1:
                grams =0

            # decide units
            if unit == "grams ":
                if grams > 1000:
                    units = "kilograms"
                    write_grams_LCD("{:.3f}".format(grams/1000))
                    leftstr = "kg  "
                    write_right("{:.3f}".format(grams/1000))
                else:
                    units = "grams"
                    write_grams_LCD("{:.0f}".format(grams))
                    leftstr = "gr  "
                    write_right("{:.0f}".format(grams))
        
            else:
                pounds = (grams/1000) * KGLB_COEFF
                pound_frac = pounds % 1
                ounces = 16 * pound_frac

                write_pounds_and_ounces_LCD(pounds, ounces)
                


            
            
            #print("grams={}".format(grams))
                
            time.sleep(0.2)


    def avg_reading(self):
        sigma = 0
        
        
        for i in range(0,self.sample_size):
            sigma+= self.adc.read()
        
        avg = sigma/self.sample_size
        
        
        return( avg)


    def find_offset(self):
        self.checking_tare = True
        
        avg = self.avg_reading()
        print("zzoffset = {}".format(avg))
        
        self.offset = avg
        self.checking_tare = False
            

    def find_coeff(self, grams):
        avg_rd = self.avg_reading()
        
        self.coeff = (grams/(avg_rd-self.offset))
        print("coeff = {}".format(self.coeff))
        
    
###########################################################
###             Tare Button                          #######
###########################################################
# set up tare button
tare_button = Pin(16, Pin.IN, Pin.PULL_UP)

def tare_button_callback(p):
    global the_scales
    global tare_button
    # the tare button has been pressed
    # first handle the debounce

    print("!!!!!!!!! tare button pressed !!!!!!!!")
    write_right("8888")
    lcd.putstr(" Setting Tare   \n                ")
    tare_button.irq(handler=None)
    # there appears to be a pretty serious debounce problem
    if tare_button.value() == 0:
        # now wait for the release of the button
        # wait for button to settle
        tare_button_count = 0
        #print("tare_button_value={}".format(tare_button.value()))
        while tare_button_count < 3:
            # check if button released
            #print("tare_button_value={}".format(tare_button.value()))
            if tare_button.value() == 1:
                tare_button_count+=1
            elif tare_button.value() == 0:
                tare_button_count = 0
            time.sleep(0.05)

        ########## Do what needs to be done
        the_scales.find_offset()


    #print("!!!!!!!!! tare button released !!!!!!!!")
    tare_button.irq(trigger=Pin.IRQ_FALLING, handler=tare_button_callback)



###########################################################
###             Unit Button                          #######
###########################################################
# set up tare button
unit_button = Pin(18, Pin.IN, Pin.PULL_UP)
unit = "grams " # note extra space

def unit_button_callback(p):
    global the_scales
    global unit_button
    global unit
    # turn off irq while we are here
    unit_button.irq(handler=None)

    # the unit button has been pressed
    # first handle the debounce

    print("!!!!!!!!! unit button pressed !!!!!!!!")
    write_right("----")
    # toggle between pounds and grams
    if unit == "grams ":
        unit = "pounds"
    else:
        unit = "grams "

    lcd.clear()
    ############0123456789ABCDEF##0123456789ABCDEF#
    lcd.putstr(" Units = {unit} \n                ".format(unit=unit))
    time.sleep(2)
    lcd.clear()

    # debounce 
    while unit_button.value() == 0:
        # now wait for the release of the button
        # wait for button to settle
        unit_button_count = 0
        #print("unit_button_value={}".format(unit_button.value()))
        while unit_button_count < 3:
            # check if button released
            #print("unit_button_value={}".format(unit_button.value()))
            if unit_button.value() == 1:
                unit_button_count+=1
            elif unit_button.value() == 0:
                unit_button_count = 0
            time.sleep(0.05)

        ########## Do what needs to be done
        ##XXX


    #print("!!!!!!!!! unit button released !!!!!!!!")
    unit_button.irq(trigger=Pin.IRQ_FALLING, handler=unit_button_callback)


unit_button.irq(trigger=Pin.IRQ_FALLING, handler=unit_button_callback)
tare_button.irq(trigger=Pin.IRQ_FALLING, handler=tare_button_callback)

    
    
##################################################################
### Instantiate the scales
the_scales = scales(30)
the_scales.read_loop()





