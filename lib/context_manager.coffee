chalk = require 'chalk'
commands = require './commands'

defaultPrompt = chalk.blue "¯\\_(ツ)_/¯> "

class ContextManager
    replServer: null
    ctxStack: []
    defaultPrompt: defaultPrompt
    defaultContext:
        ###
        # The default handler simply extracts the command from the arguments
        # and attempts to execute the command using the commands module. No
        # post-execution processing takes place here.
        ###
        handler: (args, context, callback) ->
            c = args.shift()
            commands.getExec(c) args, context, callback
        prompt: defaultPrompt

    setServer: (server) ->
        @replServer = server
        @replServer.eval = @getEvalFn()

    ###
    # Prototype replContext
    ###
    #replContext =
    #    handler: someFn
    #    prompt: "My ctx prompt> "

    parseCmd: (cmd) ->
        cmd.split /\s+/

    replaceREPLContext: (newCtx) ->
        @ctxStack.pop()
        @ctxStack.push()
        @refreshREPL()

    popREPLContext: () ->
        if @ctxStack.length == 0 then process.exit()
        @ctxStack.pop()
        @refreshREPL()

    pushREPLContext: (newCtx) ->
        @ctxStack.push(newCtx)
        @refreshREPL()

    getREPLContext: () ->
        if @ctxStack.length > 0 then @ctxStack[@ctxStack.length - 1] else @defaultContext

    setPrompt: (prompt) ->
        @getREPLContext().prompt = prompt
        @refreshREPL()

    refreshREPL: () ->
        @replServer.setPrompt("#{@getREPLContext().prompt} ")

    evalFn: (cmd, dataCtx, filename, callback) =>
        args = @parseCmd(cmd)
        @getREPLContext().handler args, dataCtx, (result, newEvalCtx, isDone, prompt) =>
            if isDone and newEvalCtx?
                @replaceREPLContext(newEvalCtx)
            else if isDone
                @popREPLContext()
            else if newEvalCtx
                @pushREPLContext(newEvalCtx)

            # Setting a prompt will override the prompt provided in the newEvalCtx
            if prompt? then @setPrompt("#{prompt} ")
            callback(result)

    getEvalFn: () ->
        @evalFn

    getDefaultPrompt: () ->
        @defaultPrompt

module.exports = new ContextManager()
