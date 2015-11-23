_     = require 'underscore'
chalk = require 'chalk'

commands =
    use: (args, dataCtx, callback) ->
        toUse = args?[0]
        spec = args?[1]
        if toUse? and toUse.length > 0
            callback("Changing the prompt", null, false, if toUse? then chalk.blue toUse else null)
        else
            callback(chalk.red('use requires at least one argument'),)
    exit: (args, dataCtx, callback) ->
        callback(null,null, true)

    list: (args, dataCtx, callback) ->
        callback(_.chain(commands).keys().sort().map((cmd) -> chalk.blue cmd).value().join('\t'))

    pick: (args, dataCtx, callback) ->
        options = ['A thing', 'Another thing', 'A third thing']
        message = "Pick one:\n#{_.map(options, (item, idx) -> " #{idx+1}. #{item}").join('\n')}"
        context =
            prompt: '?>'
            handler: (args, context, cb) ->
                selection = parseInt(args.shift())
                if selection >= 1 and selection <= options.length
                    cb("You picked #{options[selection-1]}", null, true)
                else
                    cb("Invalid selection")
        callback(message, context)

notFound = (cmd, args, dataCtx, callback) ->
    callback(chalk.red "'#{cmd}' is not a recognized command")

module.exports =
    getExec: (cmd) ->
        if cmd in Object.keys(commands) then commands[cmd] else notFound.bind(@, cmd)
