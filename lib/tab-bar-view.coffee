module.exports =
class TabBarView
  constructor: (pane) ->
    paneElement = atom.views.getView(pane)
    @element = paneElement.querySelector('.tab-bar')
    @children = []

  prepend: (tab) ->
    @children.push @element.insertBefore(tab, @element.firstChild)

  append: (tab) ->
    @children.push @element.appendChild(tab)

  addClass: (className...) ->
    @element.classList.add(className...)

  removeClass: (className...) ->
    @element.classList.remove(className...)

  destroy: ->
    child.destroy() for child in @children
