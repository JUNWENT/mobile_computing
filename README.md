# Life_Tracker

This project is assignment for COMP90018 Mobile Computing Systems Programming 2017_SM2. It is an ios app named Life_Tracker. The main funciton of this app is that one user can trace the location and motion information of another users who have connected with this user. The location will be shown on the map and motion informaiton are listed in the home page. If user do not has any connection with other user, the home page will show this user`s location and motion information.  

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

To install this application on your own computer, your operating system should be ios. You need to download Xcode 8.3.3 and Swift 3. 
This application compatible with ios 10.3 and you need to allow this application to access to your gps and motion informaiton to work properly. 


### Installing

Downloading the project into your computer, open it with Xcode 8.3.3 and then you can run the project.


## Details
This applicaiton has serveral pages.

The first page is MainPage, the user can choose login or register in this page. The app will show this page first. If the user can login before, then this page will no longer be shown until the user log out. 

The second page is SignInPage. User can register their account in this page. This page will check some constranits of the text that user enterred. The phone number has to be a valid phone number and the password should contain at least one UpperCase character, one LowerCase character,one number and one special character like !. Also, the phone number has been registerred,then user can not use this phone number to register again. If these constraints are not satisfied, then there will be an alert. After successfully registering, the application will back to the MainPage.

The third page is LogInPage.  User has to enter their phone number and password to see their home page. The phone number and password has to be valid.

The forth page is HomePage. In this page, user will see the location map and the motion information. If user has no connection with other users, then he will see his own location and motion information. User can also choose to see other user`s informaiton or back to his own information. 

The fifth page is AccountPage. In this page, user will be provided many options to set their account. He can change his personal profile, reset his password, set his verfication code which will allow other user can connect to him, manage his dependents to choose a user`s information to be shown on the HomePage, connect to other user and log out.
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


