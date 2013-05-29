###Setup

The iOS app should be ready to go with a couple simple steps.


Reading Robot uses an open source text-to-speech library called OpenEars for the robot’s voice synthesis. To get the latest version go here: http://www.politepix.com/openears/.


Download the OpenEars distribution to a convenient location.


Then, either:


Remove the current OpenEars framework from the project, and drag the newly downloaded framework into the project in its place.


Or


Simply copy the OpenEarsDistribution folder into the correct location in relation to the project folder, i.e. the path should be ../../OpenEarsDistribution. 


(You’ll know you’ve done this correctly if the files under the OpenEars framework folder turn from red to black.)


At this point, you should be good to go. 


Note that if you want to test the app on a device, you will have to have a valid Apple provisioning profile, which requires an active Apple Developer account.