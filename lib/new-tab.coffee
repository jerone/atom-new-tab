{$, View}  = require 'atom-space-pen-views'
_ = require 'underscore-plus'
{CompositeDisposable} = require 'atom'

NewTabView = require './new-tab-view'

class TestView extends View
  @deserialize: -> new TestView()
  @content: -> @div ''
  initialize: ->
  getTitle: -> null
  getLongTitle: -> null
  getIconName: -> null
  serialize: -> { deserializer: 'TestView' }
  onDidChangeTitle: (callback) ->
    @titleCallbacks ?= []
    @titleCallbacks.push(callback)
    dispose: => _.remove(@titleCallbacks, callback)
  emitTitleChanged: ->
    callback() for callback in @titleCallbacks ? []
  onDidChangeIcon: (callback) ->
    @iconCallbacks ?= []
    @iconCallbacks.push(callback)
    dispose: => _.remove(@iconCallbacks, callback)
  emitIconChanged: ->
    callback() for callback in @iconCallbacks ? []
  onDidChangeModified: -> # to suppress deprecation warning
    dispose: ->

module.exports = NewTab =
  newTabView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    console.log 'new-tab'
    window.setTimeout ->
      pane = atom.views.getView(atom.workspace.getActivePane())
      tabBar = pane.firstChild

      icon = document.createElement 'span'
      icon.classList.add 'icon', 'icon-plus'

      div = document.createElement 'div'
      div.classList.add 'title'
      div.appendChild icon

      li = document.createElement 'li'
      li.classList.add 'tab', 'new-tab'
      li.appendChild div
      li.addEventListener 'mouseover', ->
        li.classList.add 'active'
      li.addEventListener 'mouseout', ->
        li.classList.remove 'active'
      li.addEventListener 'mousedown', (e) ->
        console.log 'new-tab li.mousedown', arguments
        atom.commands.dispatch(atom.views.getView(atom.workspace.getActivePane()), 'application:new-file')
        e.preventDefault()
        e.stopPropagation()
        return false

      li.item = new TestView 'Dummy'
      li.handleEvents = -> console.log 'new-tab.handleEvents', arguments
      li.updateDataAttributes = -> console.log 'new-tab.updateDataAttributes', arguments
      li.updateTitle = -> #console.log 'new-tab.updateTitle', arguments
      li.updateIcon = -> console.log 'new-tab.updateIcon', arguments
      li.updateModifiedStatus = -> console.log 'new-tab.updateModifiedStatus', arguments
      li.setupTooltip = -> console.log 'new-tab.setupTooltip', arguments
      li.destroyTooltip = -> console.log 'new-tab.destroyTooltip', arguments
      li.destroy = -> console.log 'new-tab.destroy', arguments
      li.getTabs = -> console.log 'new-tab.getTabs', arguments
      li.updateIconVisibility = -> console.log 'new-tab.updateIconVisibility', arguments
      li.updateModifiedStatus = -> console.log 'new-tab.updateModifiedStatus', arguments

      liDummy = li.cloneNode(true)
      liDummy.addEventListener 'mouseover', ->
        liDummy.classList.add 'active'
      liDummy.addEventListener 'mouseout', ->
        liDummy.classList.remove 'active'
      liDummy.addEventListener 'mousedown', (e) ->
        console.log 'new-tab li.mousedown', arguments
        atom.commands.dispatch(atom.views.getView(atom.workspace.getActivePane()), 'application:new-file')
        e.preventDefault()
        e.stopPropagation()
        return false
      liDummy.item = new TestView 'Dummy'
      liDummy.handleEvents = -> console.log 'new-tab.handleEvents', arguments
      liDummy.updateDataAttributes = -> console.log 'new-tab.updateDataAttributes', arguments
      liDummy.updateTitle = -> #console.log 'new-tab.updateTitle', arguments
      liDummy.updateIcon = -> console.log 'new-tab.updateIcon', arguments
      liDummy.updateModifiedStatus = -> console.log 'new-tab.updateModifiedStatus', arguments
      liDummy.setupTooltip = -> console.log 'new-tab.setupTooltip', arguments
      liDummy.destroyTooltip = -> console.log 'new-tab.destroyTooltip', arguments
      liDummy.destroy = -> console.log 'new-tab.destroy', arguments
      liDummy.getTabs = -> console.log 'new-tab.getTabs', arguments
      liDummy.updateIconVisibility = -> console.log 'new-tab.updateIconVisibility', arguments
      liDummy.updateModifiedStatus = -> console.log 'new-tab.updateModifiedStatus', arguments

      li.style.top = tabBar.getBoundingClientRect().top + 'px'

      window.addEventListener 'resize', ->
        li.style.top = tabBar.getBoundingClientRect().top + 'px'

      tabBar.appendChild liDummy
      tabBar.appendChild li
    , 3000

    #@newTabView = new NewTabView(state.newTabViewState)
    #@modalPanel = atom.workspace.addModalPanel(item: @newTabView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    #@subscriptions = new CompositeDisposable

    # Register command that toggles this view
    #@subscriptions.add atom.commands.add 'atom-workspace', 'new-tab:toggle': => @toggle()

  deactivate: ->
    #@modalPanel.destroy()
    #@subscriptions.dispose()
    #@newTabView.destroy()

  serialize: ->
    #newTabViewState: @newTabView.serialize()

  toggle: ->
    console.log 'NewTab was toggled!'

    #if @modalPanel.isVisible()
    #  @modalPanel.hide()
    #else
    #  @modalPanel.show()
