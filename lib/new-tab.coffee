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

  activate: (state) ->
    @tabBarViews = []
    @subscriptions = new CompositeDisposable

    if atom.packages.isPackageActive 'tabs'
      @addNewTabToPane pane for pane in atom.workspace.getPanes()

    atom.packages.onDidActivatePackage (pkg) =>
      return unless pkg.name is 'tabs'
      @paneSubscription = atom.workspace.observePanes (pane) =>
        @addNewTabToPane pane

  deactivate: ->
    @paneSubscription?.dispose()
    @subscriptions?.dispose()
    tabBarView.destroy() for tabBarView in @tabBarViews if @tabBarViews?
    @tabBarViews = []

  serialize: ->

  addNewTabToPane: (pane) ->
    @tabBarViews.push tabBarView = new TabBarView(pane)

    newTabViewPrepend = new NewTabView().initialize(pane)
    newTabViewAppend = new NewTabView().initialize(pane)
    newTabViewSticky = new NewTabView().initialize(pane)

    newTabViewPrepend.classList.add('new-tab-prepend')
    newTabViewAppend.classList.add('new-tab-append')
    newTabViewSticky.classList.add('new-tab-sticky')

    tabBarView.prepend(newTabViewPrepend)
    tabBarView.append(newTabViewAppend)
    tabBarView.append(newTabViewSticky)

    tabBarView.addClass(positionToClass('None'))
    @subscriptions.add atom.config.observe 'new-tab.position', (position) =>
      for schemaPosition in @config.position.enum
        tabBarView.removeClass(positionToClass(schemaPosition))
      tabBarView.addClass(positionToClass(position))

    pane.onDidDestroy =>
      @tabBarViews.splice(@tabBarViews.indexOf(tabBarView), 1)
      tabBarView.destroy()
