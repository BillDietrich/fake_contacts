# fake_contacts

Create fake phone contacts, that will be stored on your phone along with your real contacts.  The idea is to feed fake data to any apps or companies who are copying our private data to use or sell it.  This is called "data-poisoning".

Nothing about these fake contacts will interfere with your normal use of your phone or your real contacts.

[BEING DEVELOPED; WORKS ON ANDROID, NOT DANGEROUS, BUT NOT READY FOR USE !!!]

<img src="https://www.billdietrich.me/AbnormalBrain.jpg" width="250" height="131" />

## Functionality
The user can set lists of last names and first names for fake contacts, and phone-number and email-address templates for them.  Then click buttons to create or delete fake contacts with all combinations of the first and last names.


## Use

<img src="UsingTheApp.jpg" width="190" height="400" />

The default values should be sensible.  All of the first and last names start with "Z", to try to keep them from colliding with names of real contacts, and to keep them out of the way (at the end of the Contacts list).

So, just install and launch the application, and click the "Create Fake Contacts" button.  The system should ask you to grant Contacts permission to the application.  Then the contacts (one for each firstname-lastname combination) will be created.  Launch your usual Contacts app and scroll to the end to see the new contacts.

If you wish, click the "Delete Fake Contacts" button to delete them.  You also could use your normal Contacts app to delete them manually at any time, without causing any problem.


### Customizing

* The list of last names is just a comma-separated list.  You can edit it to have any names.  Best not to have any spaces.

* The list of first names is similar.

* The phone-number template is a single value used for all contacts.  Any character "n" in it will be replaced by a digit 0-9, derived from the contact's last name.  The default format is ```+21345678nnn```, which is intended to use an unassigned country code "21".  You could delete the contents of this field if you wish, and no phone numbers will be generated.

* The email-address template is a single value used for all contacts.  Any string "FIRST" in it will be replaced by the contact's first name.  Any string "LAST" in it will be replaced by the contact's last name.  The default format is ```FIRST.LAST@example.com```, which is intended to be an unused email domain.  You could delete the contents of this field if you wish, and no email addresses will be generated.


### Quirks

* The app is designed to be very simple and fail silently.  If you deny permission to access contacts, the app will not complain, it just will not work.  If you click the "Create" button multiple times, you just get one set of fake contacts.  If you click the "Create" button multiple times while changing templates between clicks, you will get duplicate-name fake contacts (harmless).  If you click the "Delete" button and the specified contacts don't exist, nothing is done, and no error message is shown.

* Don't create any fake contacts with the same full name as one of your real contacts.  If you delete fake contacts, the real one with same name will be deleted too.

* Replacements for "n" digits in phone numbers are calculated deterministicly (repeatably) from contact's last name.  So for example if 5 users of this app all just leave everything set at defaults, the same contacts will show up on each of their phones with the same names, phone numbers, and email addresses.  This is good, for data-poisoning purposes.  Further, all fake contacts with same last name will have same phone number (debatable whether this is good or bad).


---


## Releases
### 1.0.0


---

## Development
### To-Do list
* Settings are not stored persistently.
* Test on iOS.
* Profiler complains that app is doing too much work on main thread sometimes.  Could be an issue if someone puts in many names ?
* Massive inefficiency in the "react to every char changed in field" events.

### Development Environment
I'm no expert on this stuff, this is my first phone app, maybe I'm doing some things stupidly.

Now using:
* Android Studio
* Flutter
* Dart
* Linux

https://github.com/BillDietrich/fake_contacts.git

---

## Privacy Policy
This application doesn't collect, store or transmit your identity or personal information in any way.  It contains no advertising and no trackers.


## License

See LICENSE.md file.  MIT license.  Copyright 2021 Bill Dietrich.
