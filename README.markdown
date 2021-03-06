## Overview
Broccoli is an app to search for movies, learn more about them and store the ones you like for later. You can lookup movies, ratings, cast, watch trailers and add them to your personalized list. This idea can be extended to support restaurants and books as well.

### What I learnt -

a. Design with the user in mind. Understand how people use their devices before jumping into code.
I used my husband as a guinea pig for a lot of designs iterations. Having a strong UI background his feedback was extremely helpful.

b. Objective C
This is a fairly easy to understand language esp. if you are coming from a C/C++ background.
However if you are coming from a Java background then there can be a few things that can get you into trouble.
The basics of the two languages are like any object oriented language, but the semantics are quite different.
Objective C is closer to C++ than it is to Java. Some of the main issues I had trouble following were -
  - Doing the allocation and then initialization of objects. Adding pointers to all statically typed variables seemed a little overwhelming.
  - Separating public/private variable/method references into header and implementation files.
  - Managing the object graph to avoid memory leaks aka garbage collection. Yes you can now enable ARC for your code, but it can be a daunting job if you are using some older non ARC based libraries in your code. You will have to selectively turn on/off ARC.

### What I liked about the language -
1. The way methods/functions are declared and called is very easy to read and write. The code can be very easy to read even by a person coming from a non programming background.
2. The notion of Delegation where 2 classed don't need to have any relationship in order to serve each other. This can be very handy if your classes don't necessarily have a hierarchical relationship.
3. Introspection, is a powerful and useful feature of Objective-C (check if an object is an instance of a particular class, responds to a particular message, conforms to a particular protocol).
4. Emphasis on following a good design pattern. Most often a simple design pattern like MVC will suffice. It is central to a good design for any iOS or Mac app.
5. Rich library of messaging mechanisms - delegation/protocols, notifications, action-target based approach, key-value observing.

### What I din't like -
1. Xcode, the IDE for writing Objective C code, does not have good debugging support! Stepping in through the code leada you to the machine level instructions which can be impossible to interpret.

c. Google's App Engine
This was again very easy to use to build web applications using Java and then run them on the Google infrastructure.
The app on the server side talks to a bunch of movie data api's like rotten tomatoes, tmdb to get movie info and with the
youtube api for trailers. All of these api's had JSON based responses which were parsed in the server.
The App Engine Java SDK also provides a low-level Datastore API with simple operations on entities, including get, put, delete, and query which I ended up using for storing/retrieving the user list. All very easy to use and with a rich feature set to handle most of the uses.

### Resources -
  - Apple's iPhone Developer library (https://developer.apple.com/library/ios/navigation/)
  - Paul Hegarty's lectures on iPhone Application development (http://www.stanford.edu/class/cs193p/cgi-bin/drupal/downloads-2011-fall)
  - Google App Engine (Java) https://developers.google.com/appengine/docs/java/

### Acknowledgement -
Jin Yao for designing the splashscreen and app thumbnail.

### INSTALLING THE APP -
Since the app is still under development, it is currently not available on App Store. However there are a few tools available on the web like Jailcoder which allow you to install the app on your jail broken device. Just download the code to Xcode and then create a patch for Xcode and the app for your iPhone. 

### Screenshots -
![Splashscreen](http://i.imgur.com/d5Nd5fD.png)

![Main Screen](http://i.imgur.com/DBhp2uR.png)

![Detail Screen1](http://i.imgur.com/xmOeph9.png)

![Detail Screen2](http://i.imgur.com/w0roIKJ.png)

![Youtube Screen](http://i.imgur.com/WRRl1RX.png)
