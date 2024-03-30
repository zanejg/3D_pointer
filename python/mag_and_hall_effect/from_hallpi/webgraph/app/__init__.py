import os
import json
import time
import hashlib


import path
import sys

# # directory reach
# directory = path.path(__file__).abspath()
# # setting path
# sys.path.append(directory.parent.parent)
import board
# import adafruit_mlx90393
import memcache



from flask import Flask
from flask import render_template
from flask import request
from flask import send_from_directory


FIRST_CHUNK_SIZE = 1000

mc = memcache.Client(["localhost:11211"])

class chunk_getter:
    
    def __init__(self):
        self.last_idx = 0
        pass

    def reset(self):
        self.last_idx = 0


    def get_data_chunk(self):
        #import pdb;pdb.set_trace()
        current_idx = mc.get("CURRENT_IDX")
        if current_idx is None:
            return json.dumps({"error":"no data yet"})
        current_idx = int(current_idx)
        if current_idx == 1:
            start_idx = 1
        else:
            start_idx = self.last_idx +1
        if start_idx < 1:
            start_idx = 1
        chunk = []

        # check for first read
        if self.last_idx == 0:
            reverse_chunk = []
            current_val = json.loads(mc.get(f"{current_idx}"))


            #import pdb;pdb.set_trace()


            read_idx = current_idx
            current_time = float(current_val['time'])
            start_time = current_time - (FIRST_CHUNK_SIZE/1000)
            this_time = current_time
            print(f"start_time:{start_time} current_time:{current_time}")

            while this_time > start_time:
                reverse_chunk.append(current_val)
                read_idx -= 1
                current_val = json.loads(mc.get(f"{read_idx}"))
                this_time = float(current_val['time'])
            
            chunk = reverse_chunk[::-1]
            # for i in range(len(reverse_chunk)-1,-1,-1):
            #     chunk.append(reverse_chunk[i])

            
        else: # other wise just get the chunk
            for i in range(start_idx,current_idx):
                idx_key = f"{i}"
                data = mc.get(idx_key)
                if data is not None:
                    chunk.append(data)
            
        self.last_idx = current_idx
        return json.dumps(chunk)




chunker = chunk_getter()

def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True, static_folder='/webgraph/colorjoe')
    

    app.config.from_mapping(
        SECRET_KEY='$#@% much more secrety squirrely key thingy GHHFGTfaf4rg%#$@%$#@',
        DATABASE=os.path.join(app.instance_path, 'flaskr.sqlite'),
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    key_hasher = hashlib.sha256()
    salt = app.config.get('SECRET_KEY')
    key_hasher.update(b"{salt}")
    realtoken = key_hasher.hexdigest()
    curdir = os.getcwd()

    
    
    #import pdb;pdb.set_trace()

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass
    
    
    # i2c = board.I2C()  # uses board.SCL and board.SDA
    # SENSOR = adafruit_mlx90393.MLX90393(i2c, gain=adafruit_mlx90393.GAIN_1X)

    # a simple page that says hello
    @app.route('/')
    def index():
        chunker.reset()
        return render_template('rolling_graph.html')
    # @app.route('/getdata/')
    # def getdata():
    #     MX, MY, MZ = SENSOR.magnetic
    #     return json.dumps({"x":MX,"y":MY,"z":MZ})
        
        #return json.dumps(acc.get_accel())
        #return json.dumps(acc.get_gyro())
    
    @app.route('/getdatachunk/')
    def getdatachunk():
        """
        This will return a chunk of data from the memcache
        The size of the chunk will depend on a state variable
        that remembers what time the last chunk was sent.
        At the start the chunk will be FIRST_CHUNK_SIZE 
        milliseconds worth.
        """
        print("About to get chunk")
        chunk = chunker.get_data_chunk()
        print("Got chunk")
    
        return json.dumps(chunk)
    

    


    @app.route('/gettoken/')
    def gettoken():
        key_hasher = hashlib.sha256()
        
        salt = app.config.get('SECRET_KEY')
        key_hasher.update(b"{salt}")
        return json.dumps({"key":key_hasher.hexdigest()})

    
   

    return app


