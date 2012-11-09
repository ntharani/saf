#RoR-Tutorial Redo.

1. RoR Tutorial - Complete (Sample App)
2. Book - Well Informed Rubyist
3. Course - Ruby Monk
4. Design Patterns in Ruby
5. Ruby Bastards - some great stuff here.
6. [This] -> Nothing like a litle review to make sure I grasped it all.

#Going forward from this:

* Clone this project and rip out the authentication and test with Singly.  Singly handles social authentication.  Still need the cookie caching for session management.  (eg: If you close the browser, you'll still have to reauthenticate, but once you do Twitter et all remembers you.  We need to augement this with cookie session management)
* Experiment with the new user/registration process beta that Singly offers
* Add social login icons to the login form

# Make sure modelling logic makes sense
# Consider trying a different database - MongoDB.
# Connect to our API to render table views