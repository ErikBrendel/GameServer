findGetParam = (param) ->
  window.location.search
    .substr 1
    .split "&"
    .map (item) -> item.split "="
    .filter (item) -> item[0] is param
    .map (item) -> item[1]
    .pop()

module.exports = findGetParam
