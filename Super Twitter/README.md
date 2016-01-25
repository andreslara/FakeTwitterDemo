Andres Lara

Login info
username = username
password = password

A fake Twitter API was implemented in TwitterAPI.h. It simulates login, sending tweets and fetching 
tweets. It simulates server errors in 20% of the calls. It stores the identifier of the last tweet
in user defaults. 

DataManager takes care of all the data. It uses core data to store tweets received from fake Twitter
API. I wrote some unit tests to cover the basic funcionality. Core data is used because it makes
storing data very easy. When logging out data is not deleted. In a real world situation this data
should be deleted and fetched from server on next login. 

I did not include an avatar in the UI because this app only displays the locan user's tweets so it
would be kind of pointless to have an avatar.

Tweets are limited to 140 characters in the compose screen and in core data. In a reall app I would
get this number from the server so that it could be easily modifed.