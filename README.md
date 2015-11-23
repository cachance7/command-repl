# Basic command REPL

## Design

* REPL Front end
    * Context stack for commands that require additional input. Allows for alternate `eval` function.
    * List available commands.
    * Suggestions when command is unrecognized and maybe misspelled.
    * Defaul `eval` uses command parser to then dispatch to command handler.

* Command Parser
