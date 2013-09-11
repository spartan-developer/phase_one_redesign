require
  urlArgs: "b=#{(new Date()).getTime()}"
  paths:
    jquery: 'vendor/jquery/jquery'
    bootstrap: 'vendor/bootstrap/bootstrap'
    bootstrap_select: 'vendor/bootstrap/bootstrap-select'
  shim:
    bootstrap: deps: ['jquery'], exports : '$.fn.popover'
    bootstrap_select: deps: ['bootstrap'], exports : '$.fn.selectpicker'
  , ['jquery', 'bootstrap', 'bootstrap_select']
  , ($) ->
    $ ->
      $('select.classification').each ->
        this.add(new Option('U', 'Unclassified'))
        this.add(new Option('S', 'Secret'))
        $(this).selectpicker()
