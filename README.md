# Robot-Hand

Control a robot hand through web sockets with an iOS app, Raspberry Pi and Servos.

The robot hand we have created uses 6 servos to control individual finger movement as well as hand rotation. The servos will interface with a Raspberry Pi running a Python websockets server. 

This repo contains the Python code for controlling the hand (well most of it, its not done yet) as well as a SwiftUI app that contains a websockets client and lets you control the hand in multiple ways. These include:
- Manual Control (Allows you to manually control each finger precicely.)
- Gesture Control (Allows you to place your hand on the screen and move it to control the hand. *Doesn't work well right now, really only good on an iPad. Still a WIP*)
- AR Control (Uses an Image Classifier to recognise set gestures. These gestures include **Fist ✊**, **Five Fingers 🤚**, **Thumbs Up 👍**, **Peace ✌️** and **None ❌** )


