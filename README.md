# Language Shelf

### Table of Contents

1. [Description](#description)
2. [Functionalities](#functionalities)
    1. [Bookshelf Tab](#bookshelf)
    2. [Game Tab](#game)
    3. [User Profile Tab](#profile)
3. [Technologies](#technologies)

<a name="description"></a>
### Description

---

Language Shelf is a vocabulary learning note taking app specially geared towards learning new vocabulary encountered while reading books. 

<a name="functionalities"></a>
### Main Functionalities

---

The app is made up of three main tabs:

<a name="bookshelf"></a>
1. Bookshelf tab
    * Once signed in, the bookshelf tab shows a list of all of the user's bookshelves. 
    * The user can add, delete, rename, and add a cover image to a bookshelf.
    * Inside a bookshelf, the user can add books.
    * The user can add, delete, edit book information, and add a cover image to a book.
    * Inside a book, the user can create vocabulary (word, definition, notes) and sentence (example sentence) entries.
    * The user can link related vocabularies and sentences together. 
    * The user can click on a vocabulary entry, which will bring up a definition from a Dictionary API if available.
    * The user can add, delete, and edit vocabulary and sentence entries.
    * All bookshelves, books, vocabularies, and sentnces are ordered in alphabetical order.

<a name="game"></a>
2. Game tab
    * The game tab is where the user can have fun while learning vocabularies
    * Upon starting the game, five random vocabulary cards and their matching definition cards are shown on the screen. 
    * The user taps on two matching cards to make them disapear.
    * The game completes upon all cards disappearing.
    * At the end of a game, a result screen shows the game result and some user statistics.

<a name="profile"></a>
3. User Profile tab
    * The user profile tab shows the user's profile, including an username and a profile picture.
    * The user can also change the theme of the app on the user profile tab. 
    * If not signed in, the profile tab shows the sign in or sign up views. 

<a name="technologies"></a>
### Technologies Used

---

* Swift and SwiftUI - Language used for writing the app and for building the user interface
* Firebase Authentication - Used for user authentication
* Firebase Storage - Used for storing user profile pictures and bookshelves/books cover pictures
* Firestore Database - Used for storing data for the app (user, bookshelf, book, vocabulary, sentence)
* [Dictionary API](https://dictionaryapi.dev/) - Used to show phonetics and additional definitions for a vocabulary
