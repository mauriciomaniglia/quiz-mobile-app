# Quiz Mobile App

## BDD Specs

### Story: Customer requests to load the game

### Narrative #1

```
As an online customer
I want the app to automatically load the quiz game
So I can always be ready to start the game
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
 When the customer requests to load the game
 Then the app should display the question from remote
  And the game should be ready to start

### Narrative #2

```
As an online customer
I want to start the game
So I can start to guess the answers before the time runs out
```

#### Scenarios (Acceptance criteria)

```
Given the app has already loaded the question
 When the customer requests to start the game
 Then the timer should start to count
  And the game should be ready to play

Given the app has already loaded the question
 When the customer has not requested to start the game
 Then the timer should not start to count
  And the app should not allow the customer to type the answers

Given the customer has already requested to start the game
 When the customer type the guess and hit
 Then the app should display the answer typed by the customer
  And the app should update the remaining answers

Given the customer has already requested to start the game
 When the customer finished answering all the guesses
  And the timer has not finished yet
 Then the app should display a message showing how many answers do customer hit
  And the option to try another round

Given the customer has already requested to start the game
 When the customer do not finished answering all the guesses
  And the timer ends
 Then the app should display a message indicate the time is over and how many answers the customer hit
  And the option to try another round


### Narrative #3

```
As an online customer
I want to restart the game
So I can start another round


#### Scenarios (Acceptance criteria)

```
Given the customer has already requested to start the game
 When the customer requests to reset the game
 Then the timer should stop and reset 
  And all previous answers should be deleted

Given the customer finished answering all guesses before the timer ends
 When the customer request to try another round from the message shown by the app
 Then the timer should stop and reset 
  And all previous answers should be deleted

Given the customer has not finished answering all guesses and the timer ends
 When the customer request to try another round from the message shown by the app
 Then the timer should stop and reset 
  And all previous answers should be deleted


