class DomView
  constructor: (@viewModel) ->
    window.onload = @setupDom
    @balanceElement = undefined
    @viewModel.onUpdateDo 'counter_value', @updateBalance
    @setupDom()

  setupDom: =>
    document.body.innerHTML = 'Balance: <span id="currentBalance">0</span><br><button onclick="window.click()">Click!</button>'
    window.click = @click
    @balanceElement = document.getElementById 'currentBalance'

  click: =>
    @viewModel.onEvent
      type: 'count'

  updateBalance: =>
    return unless @balanceElement?
    @balanceElement.innerText = "#{@viewModel.getData().counter}"


module.exports = DomView
