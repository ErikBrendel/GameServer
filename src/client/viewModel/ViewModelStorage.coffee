# This class manages the data structures of
# The ViewModel, that the View can access directly

class ViewModelStorage
  constructor: () ->
    @data = {}

  getData: -> @data

  update: (dataId, newData) ->
    @data[dataId] = newData

module.exports = ViewModelStorage
