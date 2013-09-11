require
  urlArgs: "b=#{(new Date()).getTime()}"
  paths:
    jquery: 'vendor/jquery/jquery'
    bootstrap: 'vendor/bootstrap/bootstrap'
    bootstrap_select: 'vendor/bootstrap/bootstrap-select'
    OpenLayers: 'vendor/openlayers-2.12/openlayers'
  shim:
    bootstrap: deps: ['jquery'], exports : '$.fn.popover'
    bootstrap_select: deps: ['bootstrap'], exports : '$.fn.selectpicker'
  , ['jquery', 'bootstrap', 'bootstrap_select', 'OpenLayers']
  , ($) ->
    $ ->
      $('select.classification').each ->
        this.add(new Option('U', 'Unclassified'))
        this.add(new Option('S', 'Secret'))
        $(this).selectpicker()
            
      class MapUtil
        @defaultMapConfig: (defaultLayers = [@defaultBaseLayer()]) ->
          config =
            theme: null # because we include the CSS ourselves
            projection: new OpenLayers.Projection("EPSG:4326")
            displayProjection: new OpenLayers.Projection("EPSG:4326")
            units:'degrees'
            center: new OpenLayers.LonLat(0,0)
            maxExtent: new OpenLayers.Bounds(-180.0,-90.0,180.0,90.0)

            #restrictedExtent: new OpenLayers.Bounds(-180.0,-90.0,180.0,90.0)
            resolutions : [0.703125, 0.3515625, 0.17578125, 0.087890625, 0.0439453125, 0.02197265625, 0.010986328125, 0.0054931640625, 0.00274658203125, 0.00137329101563, 0.00068664550782, 0.00034332275391, 0.00017166137696, 0.00008583068848]

            controls: [
              new OpenLayers.Control.Navigation(
                dragPanOptions:
                  enableKinetic: true
                ),
              new OpenLayers.Control.MousePosition(),
              new OpenLayers.Control.PanZoom(),
              # new OpenLayers.Control.LayerSwitcher()
            ]
            layers: defaultLayers

        @defaultBaseLayer: (name = 'bluemarble', url = "https://tbrdevelopment.tradoc.bericotechnologies.com//geoserver/gwc/service/wms") ->
          params =
            layers: name
            format: 'image/png'
          options =
            serverResolutions: [0.703125, 0.3515625, 0.17578125,0.087890625, 0.0439453125, 0.02197265625, 0.010986328125, 0.0054931640625, 0.00274658203125, 0.00137329101563, 0.00068664550782, 0.00034332275391, 0.00017166137696, 0.00008583068848]
            wrapDateLine: true
            transitionEffect: 'resize'
          new OpenLayers.Layer.WMS(name, url, params, options)

        @newWmsLayer: (name, params = {}, options = {}) ->
          defaultParams =
            layers: name
            format: 'image/png'
          defaultOptions = {}
          new OpenLayers.Layer.WMS(
            name,
            NavIndex.mapServerPath,
            _.extend(defaultParams, params),
            _.extend(defaultOptions, options)
          )

        @newKmlLayer: (name, url, options) ->
          defaultOptions =
            strategies: [new OpenLayers.Strategy.Fixed()]
            protocol: new OpenLayers.Protocol.HTTP({
              url: url
              format: new OpenLayers.Format.KML({
                extractStyles: true
                extractAttributes: true
                maxDepth: 2
              })
            })
          new OpenLayers.Layer.Vector(
            name,
            _.extend(defaultOptions, options)
          )

      config = MapUtil.defaultMapConfig()
      @map = new OpenLayers.Map(config)
      @map.render($.find('.secondary')[0])
