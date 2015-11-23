#!/usr/bin/env coffee
repl       = require 'repl'
contextMgr = require './lib/context_manager'

# Suppress tab completion until I know more about how contexts
# work.
repl.REPLServer.prototype.complete = (line, callback) ->
    callback(null, [[], line])

replServer = repl.start
    prompt: contextMgr.getDefaultPrompt()
    ignoreUndefined: true

contextMgr.setServer(replServer)
