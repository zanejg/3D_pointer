## This code is used to read the data from the 
## MLX90393 sensor and store it in memcache
## The data is stored in a JSON object with the
## an incrementing integer index as the key and the
## time stamp and the data as the value
## The peak and trough values are also stored in memcache

import time
import board
import adafruit_mlx90393
import memcache
import json





MC_EXPIRY = 300; # five minutes should be heaps of time to get any data

mc = memcache.Client(["localhost:11211"])


i2c = board.I2C()  # uses board.SCL and board.SDA
# i2c = board.STEMMA_I2C()  # For using the built-in STEMMA QT connector on a microcontroller
SENSOR = adafruit_mlx90393.MLX90393(i2c, 
                                    gain=adafruit_mlx90393.GAIN_1X,
                                    filt=2,oversampling=0)

peak_x_value = 0
trough_x_value = 0
peak_y_value = 0
trough_y_value = 0

current_idx = 1

while True:
    # get the sensor data
    MX, MY, MZ = SENSOR.magnetic
    #[MX, MY, MZ] = SENSOR.read_data
    #print(f"[{time.monotonic():<20}]--X: {MX:<25} uT||Y: {MY:<25} uT||Z: {MZ:<25} uT")

    # keep track of the time
    this_time = time.monotonic()
    
    # the key for the memcache is the current index in a str
    idx_key = f"{current_idx}"

    

    # store the current index in memcache
    mc.set("CURRENT_IDX",current_idx,time=MC_EXPIRY)

    # we will store the data in a JSON object
    this_data = json.dumps({
        "time":this_time,
        "measurements":{"X":MX,"Y":MY,"Z":MZ}
    })

    # and store it in memcache keyed on current index
    mc.set(idx_key,this_data,time=MC_EXPIRY)
    
    # keep track of peaks and troughs for the salient dimensions
    if MX > peak_x_value or peak_x_value == 0:
        peak_x_value = MX
        mc.set("peak_x_value",this_data)
    if MX < trough_x_value or trough_x_value == 0:
        trough_x_value = MX
        mc.set("trough_x_value",this_data)
    if MY > peak_y_value or peak_y_value == 0:
        peak_y_value = MY
        mc.set("peak_y_value",this_data)
    if MY < trough_y_value or trough_y_value == 0:
        trough_y_value = MY
        mc.set("trough_y_value",this_data)

    # Display the status field if an error occured, etc.
    if SENSOR.last_status > adafruit_mlx90393.STATUS_OK:
        SENSOR.display_status()
    
    if current_idx == 1:
        print(f"Starting rolling data at {this_time}")
        
     
    # increment the index
    current_idx += 1
