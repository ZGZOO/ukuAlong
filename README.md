# Original App Design Project - README Template

# Uku Along (can still be changed)

## Table of Contents

1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
1. [Schema](#Schema)

## Overview

### Description

Uku Along is an app that users can create the chords of their original songs or cover other songs, and record themselves singing the songs. Users can comment on both themselves and on other users.

### App Evaluation


[Evaluation of your app across the following attributes]

- **Category:** Social Networking / Music
- **Mobile:** This app would be primarily developed for mobile but would perhaps be just as viable on a tablet, such as spotify or other similar apps. Functionality wouldn't be limited to mobile devices, however mobile version could potentially have more features.
- **Story:** The user can view the chords data posted by other users. The users can record themselves. The user can also comment/chat on other users.
- **Market:** Any individual could choose to use this app.
- **Habit:** This app could be used as often as the user wants to learn or practice the chords of songs.
- **Scope:** First we start with the original or the cover songs produced by the users and they can input the chords of the songs, then this could evolve into a music-tabs sharing community application as well to broaden its usage. Large potential for use with spotify, apple music, or other music streaming applications.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- User can sign up, sign in, stay signed in
- User can create a song that they want to cover
  - The title of the song
  - The artist
  - The chords
- User can search the songs that they want to learn
- User can record him/herself while playing along
- User can comment on other users' covers
- User can see other people's comment
- User can chat with other users

**Optional Nice-to-have Stories**

- User can see the lyrics
- User can leave notes for him/herself (only visible to the user)

### 2. Screen Archetypes

- Login screen
  - Allow user to input username and password
- Home screen
  - A search bar for user to search songs
    - All the covers of the songs
  - Feeds of the songs that have been recently uploaded and recorded
- Song screen
  - Detail of the songs (chords and lyrics)
  - A record button for users if they want to record themselves
    - toggle (red/grey), the user gets notified by the recording button
  - User can go back to Home screen
- Profile screen (for the user)
  - User can see the history of the songs he/she posted
    - can go to Song screen to view the details of the songs
  - User can see the history of the songs he/she bookmarked
    - can go to Song screen to view the details of the songs
  - User can see the history of the songs he/she recorded
    - present modally a screen that contains the recording
- Chat screen
  - The user can do a one-on-one chat or a group chat with other users
- Chords screen
  - The guide of all the ukulele chords (pictures)

### 3. Navigation

**Tab Navigation** (Tab to Screen)

- Home
- Profile
- Chords

**Flow Navigation** (Screen to Screen)

- Login/Sign-in screen
  - Home screen
- Home screen
  - Song screen
  - Profile screen
  - Chat screen
  - Chords screen
  - Logout
    - Login/Sign-in screen
- Song screen
  - Home screen
- Profile screen
  - Song screen
  - Home screen
  - Chat screen
  - Chords screen
- Chat screen
  - Home screen
- Chords screen
  - Home screen
  - Profile screen
  - Chat screen


## Wireframes

[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema

[This section will be completed in Unit 9]

### Models

[Add table of models]

### Networking

- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
