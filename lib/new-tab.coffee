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
    atom.packages.activatePackage('tabs').then (pkg) =>
      @tabBarViews = []
      @subscriptions = new CompositeDisposable
      @paneSubscription = atom.workspace.observePanes (pane) =>
        @tabBarViews.push tabBarView = new TabBarView(pane)

        newTabViewInline = new NewTabView().initialize(pane)
        newTabViewSticky = new NewTabView().initialize(pane)

        newTabViewInline.classList.add('new-tab-inline')
        newTabViewSticky.classList.add('new-tab-sticky')

        tabBarView.prepend(newTabViewSticky)
        tabBarView.append(newTabViewInline)

        tabBarView.addClass(positionToClass('None'))
        @subscriptions.add atom.config.observe 'new-tab.position', (position) =>
          for schemaPosition in @config.position.enum
            tabBarView.removeClass(positionToClass(schemaPosition))
          tabBarView.addClass(positionToClass(position))

        pane.onDidDestroy =>
          @tabBarViews.splice(@tabBarViews.indexOf(tabBarView), 1)
          tabBarView.destroy()

  deactivate: ->
    @paneSubscription?.dispose()
    @subscriptions?.dispose()
    tabBarView.destroy() for tabBarView in @tabBarViews if @tabBarViews?
    @tabBarViews = []

  serialize: ->
