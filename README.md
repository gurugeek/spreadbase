SpreadBase!!
============

... because Excel IS a database.

What is SpreadBase©?
--------------------

SpreadBase© is a set of APIs for programmatically accessing spreadsheets.

Technically, they could be used as a SQL parser backend (in conjunction with a minimal engine) for accessing a spreadsheet like a database.

Why this project?
-----------------

The first reason is that is well known that Real Programmers(©) use spreadsheets as databases.

The second reason is that there are a few use cases where it's effective/efficient to use a spreadsheet as a small database.

In my specific case, I need to visually access a dataset for quick changes, but also access it programmatically; SQLite wouldn't be efficient for the quick changes.

Actually there is a third reason, which is that there aren't ruby libraries for writing to openoffice spreadsheets.

Which is the SpreadBase(©) Mission(©)?
--------------------------------------

The mission is:

    To write a set of APIs supporting some spreadsheet formats, in order to allow programmatic read/write access,
    oriented to data storage more than presentation.

The sub-mission is to write funky markdown documents and abuse the copyright symbol.

Which formats and features are [going to be] supported?
-------------------------------------------------------

The focus of the current development is OpenDocument Spreadsheet 1.2 (used in the modern versions of OpenOffice).

Features that belong to the office suite domain (e.g. sheet visual splitting) are unlikely to be implemented, or they will be low priority.

About the author.
-----------------

I use Sublime Text 2 for editing, on a Thinkpad W520 with Ubuntu.  
I work for an Irish startup, but I'm based in Berlin (Germany); once in a while I spend a month (working holiday!!) in another country that I find interesting.  
I like to do the most minimal thing possible that works, and I consider more important to have a stable code, rather than adding new features.
