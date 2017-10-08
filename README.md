# Life_Tracker

This project is the second assignment for COMP90018 Mobile Computing Systems Programming 2017_SM2. It is an ios app named Life_Tracker. 
In our socisity, there is a group of people who are encouraged to walk out, while it`s unsafe for them to walk out alone. they may be little children or people with disease such as high blood pressure. Especially, those suffer from AD. As reported ,More than 60 percent of those with Alzheimer’s or another form of dementia will wander, Due to confusion, they are often unable to ask for help,and if a person is not found within 24 hours, up to half of them will suffer serious injury or death. 
To mitigate this issue, we designed and implemented a ios app to help guardians such as family members of that group of people to track their real-time locations and get their motion information. 

If guardians can track dependents location in real time, they would be able to tell whether the dependent has been wandering or was caught in some emergency situation and know where to find them in case they can’t find their way home. So, it`s safer for dependents to walk out alone. 

Besides, motion informaiton help users to monitor the level of exercise done by their dependents, and thus would promote them to maintain a heathier life style.

The main funciton of this app is that one user can trace the location and motion information of another user who has connection with this user. The location will be shown on the map and motion informaiton are listed in the home page. If an user does not have any connection with aother user, the home page will show this user`s own location and motion information.  

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

To install this application on your own computer, your operating system should be ios. You need to download Xcode 8.3.3 and Swift 3. 
Due to the assignment starts before the release of Xcode 9. So, the project does not support Xcode 9. 
This application compatible with ios 10.3 and you need to allow this application to access to your gps and motion informaiton to work properly. 
Getting motion information and real-time location information are only workable on the physical phone, because it has to access the phone`s sensor.


### Installing

Downloading the project into your computer, open the file named Life_Tracker.xcworkspace with Xcode 8.3.3 and then you can run the project.


## Details
This applicaiton has serveral pages.

The first page is MainPage, the user can choose login or register in this page. This  will be shown as the first page. If the user has login before, then this page will no longer be shown until the user log out. 

The second page is SignInPage. User can register his own account in this page. This page will check some constraints of the text that user enterred. The phone number has to be a valid phone number and the password should contain at least one UpperCase character, one LowerCase character,one number and one special character like "!". Also, if the phone number has been registerred,then user can not use this phone number to register again. We use the phone number to identify an unique user.If these constraints are not satisfied, then there will be an alert. After successfully registerred, the application will back to the MainPage.

The third page is LogInPage.  User has to enter their phone number and password to see their home page. The phone number and password needs to be valid.

The forth page is HomePage. In this page, user will see the location map and the motion information. If user has no connection with other users, then he will see his own location and motion information. User can also choose to see other user`s informaiton or back to his own information. 

The fifth page is AccountPage. In this page, user will be provided with many options to set their account. He can change his personal image profile, reset his password, set his verfication code which will allow other user connect to him, manage his connected dependents to choose a user`s information to be shown on the HomePage, connect to other user and log out.

In the connection subPage, user should enter the phone number of the user he want to connect and enter that user`s verification code to connect with him. 

This app also has a loading page. If there is any loading between the transaction of the pages, this page will be shown. 


## Authors

Developer :  Junwen Zhang 791773
             Ziyi Zhang   798838
             Mingyan Wei  280744

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

code from https://github.com/bahlo/SwiftGif for showing gif on the 
code from https://github.com/raulriera/TextFieldEffects for editing text field
code from http://www.hangge.com/blog/cache/detail_927.html for editing sign in page


