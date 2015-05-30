_ = require 'underscore-plus'
{$, View}  = require 'atom-space-pen-views'

module.exports =
class NewTabView extends HTMLElement
  initialize: (@pane) ->
    @classList.add('tab', 'new-tab')

    itemTitle = document.createElement('div')
    itemTitle.classList.add('title')
    @appendChild(itemTitle)

    itemTitleIcon = document.createElement('div')
    itemTitleIcon.classList.add('icon', 'icon-plus')
    itemTitle.appendChild(itemTitleIcon)

    @addEventListener 'mouseover', =>
      @classList.add('active')
    @addEventListener 'mouseout', =>
      @classList.remove('active')
    @addEventListener 'mousedown', (e) =>
      console.log 'new-tab.initialize.mousedown', arguments
      atom.commands.dispatch(atom.views.getView(@pane), 'application:new-file')
      e.preventDefault()
      e.stopPropagation()
      return false

    @_attachDummyPaneItem()
    @_attachDummyEvents()

  destroy: ->
    @remove()

  _attachDummyPaneItem: ->
    @item = new DummyView('')

  _attachDummyEvents: ->
    @handleEvents = -> console.log 'new-tab.handleEvents', arguments
    @updateDataAttributes = -> console.log 'new-tab.updateDataAttributes', arguments
    @updateTitle = -> #console.log 'new-tab.updateTitle', arguments
    @updateIcon = -> console.log 'new-tab.updateIcon', arguments
    @updateModifiedStatus = -> console.log 'new-tab.updateModifiedStatus', arguments
    @setupTooltip = -> console.log 'new-tab.setupTooltip', arguments
    @destroyTooltip = -> console.log 'new-tab.destroyTooltip', arguments
    @destroy = -> console.log 'new-tab.destroy', arguments
    @getTabs = -> console.log 'new-tab.getTabs', arguments
    @updateIconVisibility = -> console.log 'new-tab.updateIconVisibility', arguments
    @updateModifiedStatus = -> console.log 'new-tab.updateModifiedStatus', arguments

module.exports = document.registerElement('tabs-new-tab', prototype: NewTabView.prototype, extends: 'li')

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
