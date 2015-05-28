_ = require 'underscore-plus'
{$, View}  = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'

NewTabView = require './new-tab-view'

module.exports = NewTab =
  newTabView: null
  modalPanel: null
  subscriptions: null

  config:
    position:
      type: 'string'
      default: 'Right'
      enum: ['Left', 'Right']
    behavior:
      type: 'string'
      default: 'Both'
      enum: ['Sticky', 'Overflow', 'Both']

  activate: (state) ->
    console.log 'new-tab.activate'

    @newTabViews = []

    @paneSubscription = atom.workspace.observePanes (pane) =>
      newTabView = new NewTabView()
      newTabViewRight = new NewTabView()

      paneElement = atom.views.getView(pane)

      window.setTimeout =>
        newTabView.initialize(pane)
        newTabViewRight.initialize(pane, alignRight: true)

        tabBarElement = paneElement.firstChild
        tabBarElement.appendChild(newTabView)
        tabBarElement.appendChild(newTabViewRight)

        @newTabViews.push(newTabView, newTabViewRight)
        pane.onDidDestroy =>
          _.remove(@newTabViews, newTabView)
          _.remove(@newTabViews, newTabViewRight)
      , 100

    #@subscriptions = new CompositeDisposable
    #@subscriptions.add atom.commands.add 'atom-workspace', 'new-tab:toggle': => @toggle()

  deactivate: ->
    @paneSubscription.dispose()
    newTabView.destroy() for newTabView in @newTabViews

  serialize: ->
    #newTabViewState: @newTabView.serialize()

  toggle: ->
    console.log 'NewTab was toggled!'

    #if @modalPanel.isVisible()
    #  @modalPanel.hide()
    #else
    #  @modalPanel.show()
