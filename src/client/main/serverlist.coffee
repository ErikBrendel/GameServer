ws = undefined
lastData = []
gameTypes = [{id: 'test/void', name: 'Void Game'}]

getHost = -> document.getElementById("host").value
getUsername = -> document.getElementById("username").value
getStatusBanner = -> document.getElementById("statusBanner")

randomDescription = ->
  return 'new Game'

connectToServerList = ->
  return new Promise (resolve, reject) ->
    setStatus 'Connecting...'
    ws = new WebSocket "ws://#{SERVER_HOST}/serverlist"
    ws.onerror = (error) ->
      console.log 'Error:', error
      setStatus "Connection Error: #{error}"
      ws = undefined
      reject()
    ws.onmessage = onmessage
    ws.onopen = ->
      setStatus 'Connected!'
      resolve()

ensureConnected = ->
  return if ws?
  await connectToServerList()
  await ensureConnected()

setStatus = (status) ->
  getStatusBanner().innerText = status;

onmessage = (msg) ->
  console.log "Message: #{msg.data}"
  try
    data = JSON.parse msg.data
    switch data.type
      when 'updateList' then updateList data.list
      when 'error' then setStatus "Server Error: [#{data.msg}]"
      else setStatus("Unknown server message: \"#{msg.data}\""); ws = undefined
  catch
    setStatus("Unknown server message: \"#{msg.data}\""); ws = undefined



selectedGameId = undefined
justCreatedAGame = false

updateList = (list) ->
  lastData = list
  lastId = undefined
  tableContent = '<tr><th width="120px">Game ID</th><th width="80px">Players</th><th>Description</th><th width="40px"></th></tr>'
  for game in list
    lastId = game.id
    tableContent += "<tr id='gameRow_#{game.id}' onclick='selectGame(#{game.id})' class='gameRow'>"
    tableContent += "<td>#{game.id}</td>"
    tableContent += "<td>#{game.players}/2</td>"
    tableContent += "<td>#{game.description}</td>"
    tableContent += "<td><button onclick='return deleteGame(#{game.id}, event)' style='width: 100%' class='redButton'>X</button></td>"
    tableContent += '</tr>'
  tableContent += "<tr><td colspan='4'>
                      <button id='newGameButton' onclick='tryCreateGame()' class='redButton'>Create a new Game</button>
                      <form onsubmit='return createGame()' style='margin: 0'>
                        <select name='newGameType'>
                          #{"<option value='#{type.id}'>#{type.name}</option>" for type in gameTypes}
                        </select>
                        <input id='newGameDescription' type='text'>
                        <input id='newGameSubmit' type='submit'value='Create'>
                      </form>
                   </td></tr>"
  document.getElementById('gameTable').innerHTML = tableContent

  if justCreatedAGame and lastId?
    justCreatedAGame = false
    selectGame lastId
    return
  selectGame selectedGameId

hasSelection = ->
  return document.getElementById("gameRow_#{selectedGameId}")?

window.currentSelectionFreeSlots = ->
  game = lastData.filter((g) -> g.id is (selectedGameId + ''))[0]
  return 0 if not game?
  return 2 - game.players

updateJoinButtons = ->
  joinButtonVisible = joinTwiceButtonVisible = hasSelection()

  if hasSelection()
    joinButtonVisible = currentSelectionFreeSlots() >= 1
    joinTwiceButtonVisible = currentSelectionFreeSlots() >= 2

  document.getElementById('joinButton').disabled = not joinButtonVisible
  document.getElementById('joinTwiceButton').disabled = not joinTwiceButtonVisible

window.selectGame = (gameId) ->
  oldRow = document.getElementById "gameRow_#{selectedGameId}"
  if oldRow?
    oldRow.classList.remove 'selected'
  row = document.getElementById "gameRow_#{gameId}"
  if row?
    row.classList.add 'selected'
    selectedGameId = gameId
  else
    selectedGameId = undefined
  updateJoinButtons()

window.tryCreateGame = ->
  document.getElementById('newGameButton').style.display = 'none'
  input = document.getElementById('newGameDescription')
  input.value = randomDescription()
  input.style.display = 'inline'
  input.focus()
  input.select()

window.createGame = ->
  document.getElementById('newGameButton').style.display = 'inline'
  input = document.getElementById('newGameDescription')
  input.style.display = 'none'
  description = input.value
  justCreatedAGame = true
  setTimeout (->
    await ensureConnected()
    ws.send JSON.stringify
      type: 'createGame'
      gameType: 'test/void'
      description: description
  ), 0
  return false


window.join = (twice = false) ->
  return unless selectedGameId?
  options = "?gameId=#{selectedGameId}&url=#{getHost()}&username=#{getUsername()}"
  url = (if twice then 'doubleView3D' else 'view3D') + '.html' + options
  gameWindow = window.open url, '_blank'
  gameWindow.focus()

window.joinTwice = ->
  join true

window.deleteGame = (gameId, event) ->
  event.stopPropagation()
  await ensureConnected()
  ws.send JSON.stringify
    type: 'deleteGame'
    gameId: gameId

window.onload = ->
  document.getElementById("host").value = window.location.host
  connectToServerList()
  updateJoinButtons()
