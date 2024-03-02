_How to bypass otherwise compulsory user registration with Kobos that have factory settings._
_More details can be found [here](https://wiki.mobileread.com/wiki/Kobo_Touch_Hacking#Fake_registration)_
_The instructions below are just what worked for me on my Kobo Libra 2 (software version: 4.33.19747 (7/13/22))._

_Basically you have to edit the sqlite database file found on the Kobo._

# Dependencies:
`sqlite3`

# Instructions:
- Set your command line working directory as the root directory on the Kobo.
- Backup your sqlite database file first before working on it:

`$ cp KoboReader.sqlite KoboReader.sqlite.orig`


- Start sqlite3

`$ sqlite3 ./KoboReader.sqlite`

### Method 1:
- Run the following commands inside sqlite3:
```
> .open KoboReader.sqlite
> .mode line
> select * from user;
UPDATE "user" SET UserID ='';
UPDATE "user" SET UserKey ='';
UPDATE "user" SET UserDisplayName ='';
UPDATE "user" SET UserEmail ='';
UPDATE "user" SET ___DeviceID ='';
UPDATE "user" SET HasMadePurchase ='';
UPDATE "user" SET IsOneStoreAccount ='';
UPDATE "user" SET RefreshToken ='';
UPDATE "user" SET AuthToken ='';
UPDATE "user" SET SyncContinuationToken ='';
UPDATE "user" SET LibrarySyncType =' ';
```

### Method 2:
Method from [here](https://www.mobileread.com/forums/showthread.php?t=319853)
- Run the following commands inside sqlite3:
```
> INSERT INTO user(UserID,UserKey) VALUES('1','');
> .quit
```

# Note:
With some firmware updates, Kobo has apparently now allowed users to [use their devices without registering them online](https://gizmodo.com/kobo-finally-introduces-a-sideload-mode-for-more-privac-1848410517)