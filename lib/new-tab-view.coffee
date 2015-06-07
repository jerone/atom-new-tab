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
      if e.which is 1
        atom.commands.dispatch(atom.views.getView(@pane), 'application:new-file')
        e.stopPropagation()
        false
      else if e.which is 2
        e.stopPropagation()
        false

    DummyView = require './dummy-view'
    @item = new DummyView('')
    this

  handleEvents: ->
  updateDataAttributes: ->
  updateTitle: ->
  updateIcon: ->
  updateIconVisibility: ->
  updateModifiedStatus: ->
  setupTooltip: ->
  destroy: -> @remove()
  destroyTooltip: ->
  getTabs: ->

module.exports = document.registerElement('tabs-new-tab', prototype: NewTabView.prototype, extends: 'li')
