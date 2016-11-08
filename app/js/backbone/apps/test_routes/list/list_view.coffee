@App.module "TestRoutesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Route extends App.Views.ItemView
    template: "test_routes/list/_route"

    ui:
      tooltips: "[data-toggle='tooltip']"

    modelEvents:
      "change:numResponses" : "render"

    onBeforeRender: ->
      if _.isObject(@ui.tooltips) and @ui.tooltips.length
        @ui.tooltips.tooltip("destroy")

    onRender: ->
      @ui.tooltips.tooltip({container: "body"})

    onDestroy: ->
      @ui.tooltips.tooltip("destroy")

  class List.Routes extends App.Views.CompositeView
    template: "test_routes/list/routes"
    childView: List.Route
    childViewContainer: "tbody"

    className: "instruments-container"

    collectionEvents:
      "add" : "updateTotal"

    ## TODO: refactor all of this into a behavior!

    ui:
      total:     "[data-js='total']"
      container: ".server-container"
      hook:      ".hook-name"
      caret:     "i.fa-caret-right"
      ellipsis:  "i.fa-ellipsis-h"

    events:
      "click @ui.hook" : "hideOrShow"
      "click"          : "stopProp"
      "mouseover"      : "stopProp"
      "mouseout"       : "stopProp"

    changeIconDirection: (bool) ->
      klass = if bool then "right" else "down"
      @ui.caret.removeClass().addClass("fa fa-caret-#{klass}")

    displayEllipsis: (bool) ->
      @ui.ellipsis.toggleClass "hidden", bool

    hideOrShow: (e) ->
      hidden = @ui.container.is(":hidden")

      @changeIconDirection(!hidden)
      @displayEllipsis(hidden)

      if hidden
        @ui.container.removeClass("hidden")
      else
        @ui.container.addClass("hidden")

      e.stopPropagation()

    updateTotal: ->
      @ui.total.text @collection.length

      method = if @collection.length then "show" else "hide"
      @$el[method]()

    onShow: ->
      @updateTotal()