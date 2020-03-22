import pigpio
from websocket_server import WebsocketServer

pi = pigpio.pi()  # PiGPIO gives us control over the Raspberry Pi GPIO pins.


# Move thumb to specified angle.
def move_thumb(num):
    servo_position = (num - 0) / (100 - 0) * (2500 - 500) + 500  # Map the value of 0-100 to 500-2500
    pi.set_servo_pulsewidth(2, int(servo_position))  # Set the pulsewidth of the servo. 500 = 0°, 2500 = 180°


# Move index finger to specified angle.
def move_index(num):
    servo_position = (num - 0) / (100 - 0) * (2500 - 500) + 500
    pi.set_servo_pulsewidth(3, int(servo_position))


# Move middle finger to specified angle.
def move_middle(num):
    servo_position = (num - 0) / (100 - 0) * (2500 - 500) + 500
    pi.set_servo_pulsewidth(4, int(servo_position))


# Move ring finger to specified angle.
def move_ring(num):
    servo_position = (num - 0) / (100 - 0) * (2500 - 500) + 500
    pi.set_servo_pulsewidth(5, int(servo_position))


# Move pinky to specified angle.
def move_pinky(num):
    servo_position = (num - 0) / (100 - 0) * (2500 - 500) + 500
    pi.set_servo_pulsewidth(6, int(servo_position))


# Make a fist
def fist_gesture():
    print("Made fist gesture")


# Expand all five fingers
def five_gesture():
    print("Made five finger gesture")


# Make a peace gesture
def peace_gesture():
    print("Made peace gesture")


# Make a thumbs up gesture
def thumb_gesture():
    print("Made thumb gesture")


# Handle incoming messages
def handle_message(client, server, message):
    print('Received message:', message)  # Print that a message was received.

    # If the message contains thumb-, we know that we are going to be moving the thumb.
    if "thumb-" in message:
        num = int(float(message[6:]))  # Get the percentage that we want to open the thumb too from the message.
        move_thumb(num)  # Move the thumb to the number that we got from the message

    elif "index-" in message:
        num = int(float(message[6:]))
        move_index(int(num))

    elif "middle-" in message:
        num = int(float(message[7:]))
        move_middle(int(num))

    elif "ring-" in message:
        num = int(float(message[5:]))
        move_ring(int(num))

    elif "pinky-" in message:
        num = int(float(message[6:]))
        move_pinky(int(num))

    # If the message contains fistgesture then make a fist.
    elif "fistgesture" in message:
        fist_gesture()

    elif "fivefingersgesture" in message:
        five_gesture()

    elif "peacegesture" in message:
        peace_gesture()

    elif "thumbgesture" in message:
        thumb_gesture()

    # If the message was something other than a gesture or value, then an error most likely occured, let the user know.
    else:
        print("The message received could not be interpreted. Maybe an error.")


# Handle new client connecting.
def new_client():
    print("New client connected.")
    server.send_message_to_all("alive")  # Tell the client that the server is alive so that it will be shown in the app.


# Handle new client leaving.
def client_left():
    print("Client disconnected.")


PORT = 9030  # Port of server, change to whatever you like.
HOST = "0.0.0.0"  # IP Address of server, 127.0.0.1 is the default, 0.0.0.0 makes it available to all local devices.
server = WebsocketServer(PORT, HOST)
server.set_fn_new_client(new_client)  # Set function to call when a new client connects.
server.set_fn_client_left(client_left)  # Set function to call when a client leaves.
server.set_fn_message_received(handle_message)  # Set function to call when a message is received.
server.run_forever()  # Run the server forever.
