{CompositeDisposable} = require 'atom'

NewTabView = require './new-tab-view'
TabBarView = require './tab-bar-view'

positionToClass = (position) ->
  'new-tab-' + position.toLowerCase().replace('+', '-')

module.exports = NewTab =
  config:
    position:
      type: 'string'
      default: 'Right'
      enum: ['None', 'Left', 'Center', 'Center+Right', 'Right']

  activate: ->
    @tabBarViews = []
    @subscriptions = new CompositeDisposable

    if atom.packages.isPackageActive 'tabs'
      @addNewTabToPane(pane) for pane in atom.workspace.getPanes()

    @subscriptions.add atom.packages.onDidActivatePackage ({name}) =>
      return unless name is 'tabs'
      @subscriptions.add atom.workspace.observePanes (pane) =>
        @addNewTabToPane(pane)

  deactivate: ->
    @subscriptions?.dispose()
    tabBarView.destroy() for tabBarView in @tabBarViews if @tabBarViews?
    @tabBarViews = null

  serialize: ->

  addNewTabToPane: (pane) ->
    @tabBarViews.push tabBarView = new TabBarView(pane)

    newTabViewPrepend = new NewTabView().initialize(pane)
    newTabViewAppend = new NewTabView().initialize(pane)
    newTabViewSticky = new NewTabView().initialize(pane)

    newTabViewPrepend.classList.add('new-tab-prepend')
    newTabViewAppend.classList.add('new-tab-append')
    newTabViewSticky.classList.add('new-tab-sticky')

    tabBarView.append(newTabViewPrepend)
    tabBarView.append(newTabViewAppend)
    tabBarView.append(newTabViewSticky)

    paneSubscriptions = new CompositeDisposable

    tabBarView.addClass(positionToClass('None'))
    paneSubscriptions.add atom.config.observe 'new-tab.position', (position) =>
      for schemaPosition in @config.position.enum
        tabBarView.removeClass(positionToClass(schemaPosition))
      tabBarView.addClass(positionToClass(position))

    paneSubscriptions.add pane.onDidDestroy =>
      @tabBarViews?.splice(@tabBarViews.indexOf(tabBarView), 1)
      tabBarView.destroy()
      paneSubscriptions.dispose()
