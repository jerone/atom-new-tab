{$, View}  = require 'atom-space-pen-views'

module.exports =
class DummyView extends View
  @deserialize: -> new DummyView()
  @content: -> @div ''
  initialize: ->
  getTitle: -> null
  getLongTitle: -> null
  getIconName: -> null
  serialize: -> deserializer: 'DummyView'
  onDidChangeTitle: -> dispose: ->
  emitTitleChanged: ->
  onDidChangeIcon: -> dispose: ->
  emitIconChanged: ->
  onDidChangeModified: -> dispose: ->
