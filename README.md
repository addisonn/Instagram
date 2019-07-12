# Project 4 - *Instagram*

**Instagram** is a photo sharing app using Parse as its backend.

Time spent: **24** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [x] Run your app on your phone and use the camera to take the photo
- [x] Style the login page to look like the real Instagram login page.
- [x] Style the feed to look like the real Instagram feed.
- [x] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user. AKA, tabs for Home Feed and Profile
- [x] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [x] Show the username and creation time for each post
- [x] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- User Profiles:
- [x] Allow the logged in user to add a profile photo
- [x] Display the profile photo with each post
- [x] Tapping on a post's username or profile photo goes to that user's profile page (in timeline)
- [x] User can comment on a post and see all comments for each post in the post details screen.
- [x] User can like a post and see number of likes for each post in the post details screen.
- [ ] Implement a custom camera view.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!
- [x] User Profiles:
    Tapping on post pictures goes to that post's detail view


Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Infinite scroll glitch with reload tata
2. Data organization with Parse

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/XbBzUrBvEC.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

link: http://g.recordit.co/XbBzUrBvEC.gif

GIF created with [RecordIt](https://recordit.co/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [Bolts](https://github.com/BoltsFramework/Bolts-ObjC) - collection of low-level libraries helpful for database
- [DateTools](https://github.com/MatthewYork/DateTools) - date formatter helper
- [MBProgressHUD](https://github.com/matej/MBProgressHUD) - an iOS activity indicator view
- [Parse](https://cocoapods.org/pods/Parse) - helper for storing backend data


## Notes

Describe any challenges encountered while building the app.

I had a lot of challenges with infinite scroll/reloading the data within the app that deals with synchronization and was hard to debug. Although the UI is not completely smooth still, the logic with fetching more data at the correct time is working now. In addition, it was unclear for me how to best organize data in the database (such as if replies should be a new table or part of post objects) and when to use objects, dictionaries, or simple arrays. 


## License

Copyright [yyyy] [name of copyright owner]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
