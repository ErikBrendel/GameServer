# An OptionList is basically a Map with default / fallback value

optionList = (options, fallback) ->
  return new Proxy options,
    get: (target, name) ->
      option = target[name]
      return option if option?
      return fallback

module.exports = optionList
