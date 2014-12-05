R = require('ramda')
sprintf = require('sprintf')
colors = require('colors')

colorizeResult = R.cond(
  [R.is(Error),     (e) -> e.message.red],
  [R.alwaysTrue,    (r) -> JSON.stringify(r).green]
)

formatResult = (input, inputOrError) ->
  sprintf("%5s%20s %s",
    (typeof input).yellow,
    JSON.stringify(input),
    colorizeResult(inputOrError))

run = (title, suite, validator) ->
  console.log("\n#{title}".magenta)
  suite.forEach (input) ->
    console.log(formatResult(input, validator(input)))

module.exports = {run}
