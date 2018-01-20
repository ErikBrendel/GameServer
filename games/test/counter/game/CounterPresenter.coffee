class CounterPresenter
  constructor: (@game, @player) ->

  getInitialDataIds: -> ['counter_value']

  getPresentation: (dataId) ->
    if dataId is 'counter_value'
      return @game.counterValue
    return "Unknown data id: #{dataId}"

module.exports = CounterPresenter
