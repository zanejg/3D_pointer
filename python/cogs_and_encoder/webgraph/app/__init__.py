import os
import json
import time
import hashlib
from pymemcache.client import base

import path
import sys

# # directory reach
# directory = path.path(__file__).abspath()
# # setting path
# sys.path.append(directory.parent.parent)


from flask import Flask
from flask import render_template
from flask import request
from flask import send_from_directory


from .accel import accelerometer
import LED_control as LC 

from hardware import channels

LED_driver = LC.four_LED_driver(channels)



def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True, static_folder='/webgraph/colorjoe')
    memcacheclient = base.Client(('localhost', 11211))

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
    
    acc = accelerometer()
    

    # a simple page that says hello
    @app.route('/')
    def index():
        return render_template('rolling_graph.html')
    @app.route('/getdata/')
    def getdata():
        return json.dumps(acc.get_accel())
        #return json.dumps(acc.get_gyro())

    @app.route('/control/')
    def control_ball():
        """
        Provide the UI for controlling the ball
        """
        return render_template('colour_chooser.html')

    @app.route('/coljoedist/colorjoe.js')
    def get_coljoe_dist():
        
        the_dir = f"{curdir}/webgraph/colorjoe"
        #print(f"dir={the_dir}")
        return send_from_directory(the_dir, 'colorjoe.js')
    @app.route('/coljoedist/colorjoe.js.map')
    def get_coljoemap_dist():
        
        the_dir = f"{curdir}/webgraph/colorjoe/dist/"
        #print(f"dir={the_dir}")
        return send_from_directory(the_dir, 'colorjoe.js.map')

    @app.route('/coljoecss/colorjoe.css')
    def get_coljoe_css():
        the_dir = f"{curdir}/webgraph/colorjoe"
        return send_from_directory(the_dir, 'colorjoe.css')
    


    @app.route('/gettoken/')
    def gettoken():
        key_hasher = hashlib.sha256()
        
        salt = app.config.get('SECRET_KEY')
        key_hasher.update(b"{salt}")
        return json.dumps({"key":key_hasher.hexdigest()})

    @app.route('/set-all-lamps/')
    def set_all_lamps():
        """
        Light all of the ball LEDs to the same colour
        """

        key = request.args.get('key', default = None, type = str)
        lamp_hex = request.args.get('hex', default = '*', type = str)
        #import pdb;pdb.set_trace()

        
        if key == realtoken and lamp_hex != '*':
            """
            Then we have authenticated (well enough for now)
            """
            # take control
            memcacheclient.set("lamp_control","web")
            # and wait for the ball to respond
            time.sleep(0.1)
            
            LED_driver.all_same_RGB(lamp_hex)
        
        return({"response":"done"})

    
    @app.route('/set-one-lamp/')
    def set_one_lamp():
        """
        Light one of the ball LEDs to a given colour
        """
        key = request.args.get('key', default = None, type = str)
        lamp_hex = request.args.get('hex', default = '*', type = str)
        facet_num = request.args.get('facet', default = None, type = int)

        if key == realtoken and lamp_hex != '*' and facet_num>=0 and facet_num <= 3:
            """
            Then we have authenticated (well enough for now). 
            And the parms check out
            """
            # take control
            memcacheclient.set("lamp_control","web")
            # and wait for the ball to respond
            time.sleep(0.1)
            # init array with Nones because we don't want to effect them
            control_array = [None for i in range(0,4)]
            # set the correct one to the clour we want
            control_array[facet_num] = lamp_hex
            
            LED_driver.set_each_RGB(control_array)
        
        return({"response":f"set LED{facet_num} to {lamp_hex}"})










    

    return app


