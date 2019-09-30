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
```

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
```

### Narrative #3

```
As an online customer
I want to restart the game
So I can start another round
```

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
```

## Use Cases

### Load Question From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Question" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates question from valid data.
5. System delivers question.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

### Start Game Use Case

#### Data:
- Time

#### Primary course:
1. Execute "Start Game" command with the above data.
2. System starts the counter.
3. Counter delivers start message.
4. Counter delivers current seconds.
5. System delivers counter current value.

### Restart Game Use Case

#### Primary course:
1. Execute "Restart Game" command.
2. System deletes old answers.
3. System deletes old answers count.
4. System creates new answers count.
5. System stops the counter.
6. System resets the counter.
7. System disable inserting guesses.

### Add Answer Use Case

#### Data:
- String

#### Primary course:
1. Execute "Add Answer" command with the above data.
2. System validates answer is not empty.
3. System removes extra spaces from answer.
4. System saves new answer.
5. System delivers all answers count from previous answers.
6. System delivers all answers already saved

#### Invalid data course (sad path):
1. System do not save empty answer.

### Validate Counter Use Case

#### Primary course:
1. Execute "Validate Counter" command with the above data.
2. System valides if all save answers is equal to the total correct answers from the question model.
3. System stop the counter.
4. System delivers success message.

#### Answers incorrect course (sad path):
1. System delivers ops message with only correct user answer count.

#### Counter ends before course (sad path):
1. System delivers ops message with only correct user answer count.


## Architecture

![Quiz Game Feature](quiz_diagram.jpg)


### Payload contract

```
GET *url* 

200 RESPONSE

{
  "question": "What are all the java keywords?",
  "answer": [
    "abstract",
    "assert",
    "boolean",
    "break",
    "byte",
    "case",
    "catch",
    "char",
    "class",
    "const",
    "continue",
    "default",
    "do",
    "double",
    "else",
    "enum",
    "extends",
    "final",
    "finally",
    "float",
    "for",
    "goto",
    "if",
    "implements",
    "import",
    "instanceof",
    "int",
    "interface",
    "long",
    "native",
    "new",
    "package",
    "private",
    "protected",
    "public",
    "return",
    "short",
    "static",
    "strictfp",
    "super",
    "switch",
    "synchronized",
    "this",
    "throw",
    "throws",
    "transient",
    "try",
    "void",
    "volatile",
    "while"
  ]
}
```
