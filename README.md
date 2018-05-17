# Boggle
Simple boggle game implementation using Ruby on Rails

### Usage
1. Clone this repository by running `git clone https://github.com/sooyang/boggle_game.git`
2. Enter this repository directory using `cd boggle_game`
3. Run `bundle install` to install all the required gems.
4. Start the server `rails s`
5. Open your browser and go to `http://localhost:3000/`
5. To run automated tests `rspec`

### LIVE DEMO
This app is hosted on https://simple-boggle-game.herokuapp.com/

### Short Explanation
Ruby on Rails was selected for this simple implementation due to its ability in fast prototyping. As Ruby on Rails promotes convention over configuration, this implementation was being built quickly while keeping the code clean and following conventions.

In this application, players can start a boggle game. One game lasts for 3minutes. Players will have to get as many correct words as possible from the board generated. Players can select any tiles on the board and subsequently adjacent tiles. Once the time is up, the game ends. During the game, players can also choose to reset the game.

Taking advantage of Ruby on Rails MVC framework (separation of concerns), each action (home, start game, selecting a tile, adding a word and reset the game) initiated by the players are separated into individual controller actions. A module named `Boggle` was created which handles all the logic for the `Board` creation and the `Game` logic which checks the selection of character and checking if the word is valid in the dictionary. The actual `Board` and buttons that players interact with are handled in the view files.  

A lot of JavaScript was used to handle the player interaction in the game. Ruby on Rails facilitates the use of Javascript thus it was a breeze in implementing. Ruby on Rails also facilitates the use of CSS. Bootstrap was installed in this application to give a neat look and feel to the board game for players.

Ruby on Rails was also selected for ease in doing rspec testing.

It is worth noting that front-end frameworks such as React can deliver a better user experience for this exercise. It also have the ability to perform unit-testing using Jasmine. Placing time factor as a priority, Ruby on Rails is a winner.
