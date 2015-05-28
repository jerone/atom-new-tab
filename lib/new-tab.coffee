_ = require 'underscore-plus'
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
      enum: ['Left', 'Center', 'Center+Right', 'Right']
      #TODO: Add none to hide;

  activate: (state) ->
    console.log 'new-tab.activate'

    @newTabViews = []
    @subscriptions = new CompositeDisposable

    #FIXME Detect if tabs is active and tabs element is attached;
    window.setTimeout =>
      @paneSubscription = atom.workspace.observePanes (pane) =>
        newTabViewInline = new NewTabView()
        newTabViewSticky = new NewTabView()

        paneElement = atom.views.getView(pane)

        newTabViewInline.initialize(pane)
        newTabViewSticky.initialize(pane)

        newTabViewInline.classList.add('new-tab-inline')
        newTabViewSticky.classList.add('new-tab-sticky')

        tabBarElement = paneElement.firstChild

        tabBarElement.insertBefore(newTabViewSticky, tabBarElement.firstChild)
        tabBarElement.appendChild(newTabViewInline)

        @subscriptions.add atom.config.observe 'new-tab.position', (position) =>
          tabBarElement.classList.remove('new-tab-left', 'new-tab-center', 'new-tab-center-right', 'new-tab-right')
          positionClass = position.toLowerCase().replace('+', '-')
          tabBarElement.classList.add("new-tab-#{positionClass}")

        @newTabViews.push(newTabViewInline, newTabViewSticky)
        pane.onDidDestroy =>
          _.remove(@newTabViews, newTabViewInline)
          _.remove(@newTabViews, newTabViewSticky)
      , 100

  deactivate: ->
    @paneSubscription.dispose()
    @subscriptions?.dispose()
    newTabView.destroy() for newTabView in @newTabViews

  serialize: ->
    #newTabViewState: @newTabView.serialize()
