# Android-Kid-Magazine-V3-2023

In this age of mobility, people migrate across regions or countries for jobs. The children of these immigrant parents are reared up away from their home provinces. Though they often speak and understand their mother tongues fluently, a majority of them can not read and write in their mother tongue. They do not get the chance to learn the script for want of infrastructure (enough number of students/teachers) in their schools in a non-home province. And, that creates a disconnect of a generation with their root culture.

We developed an Android app that can transliterate the literary text from one’s native language to the Roman script (English is the lingua franca in India and, the Roman script is taught across the country). The app will display contents in both native script and Roman script along with an audio feature to listen to the story so that the user can follow in either and even learn the script as well. Presently, the app has quite a few stories in Bengali, Gujarati, and Telugu. We may even add more languages in the future. The users can access all the content without login. 

This app is specifically for adults(parents) who can register for an account to upload stories along with reading stories. 

We are short on content at the moment. Therefore, one can enrich us with content by uploading the content. Any human user can write or upload a .txt file.  The uploaded content will then be verified and if found appropriate for users, will be made available for all. Enjoy free stories of great authors with amazing morals.

# FEW THINGS TO KEEP IN MIND FOR FUTURE DEVELOPMENTS:-
* Android embedding issue was resolved by updating v1 to v2. Guide can be found here: https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects
* Another task was to correspond the plugin version, sdk version and gradle version with each other . They all are inter-dependent.
    * These versions can be changed manually in build.gradle file(present in android/app folder).
    * Any dependencies issue can be resolved manually (or use android studio for removing these issues ) in build.gradle file in android folder.
* Open only android folder in android studio to run the app on the emulator.
* Android studio is better than VS-code for those who are new in this field.
* Setup both Android studio and VS code with patience . Do the coding part in VS code and testing part in Android Studio.
