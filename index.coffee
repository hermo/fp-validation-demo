R = require('ramda')
suite = require('./suite')

# ---- Helpers ----
taskBind = R.cond(
  [R.is(Error),     R.identity],
  [R.alwaysTrue,    (input, fn) -> fn(input)]
)

composeValidator = () ->
  R.curry((args, input) ->
    R.reduceRight(taskBind, input, args))(arguments)

# ---- Validators ----
isString = (input) ->
  if typeof input == "string"
    input
  else
    Error("Input is not a string")

notBlank = (input) ->
  if (input.length? and input.length > 0) or typeof input == "number"
    input
  else
    Error("Input is blank")

maxLen = R.curry((limit, input) ->
  if input.length <= limit
    input
  else
    Error("Input is longer than #{limit}"))

# ---- Usage ----
notBlankStringTrimmed = composeValidator(notBlank, R.trim, isString)
validateName = composeValidator(maxLen(10), notBlankStringTrimmed)

suite.run("Input be a string less than 10 characters long",
  ["", "   ", 42, [1, 2, 3], {a:1, b:2}, "John", "John Smith",
    "Johnny Smithson", "whitespace       "], validateName)

suite.run("Input must have .length < 5",
  [[], [1,2,3], [1,2,3,4,5], [1,2,3,4,5,6]],
  maxLen(5)
)
