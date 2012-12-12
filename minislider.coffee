# minislider: minimal javascript slider
# author: Federico Ramírez <fedra.arg@gmail.com>
# licence: MIT

# for compatibility
if not String.prototype.trim
    String.prototype.trim = ->
        this.replace(/(\s*)(.*?)(\s*)/mi, '$2')

class MiniSlider
    # private attributes
    constructor: (conf) ->
        # default configuration
        @options = 
            delay: 3 # ammount of seconds between animation of images
            slideStep: 5

        if typeof(conf) == 'string'
            @el = document.getElementById(conf)
        else 
            @el = document.getElementById(conf['element'])
            # parse custom configuration if exists
            @options = extend(@options, conf)
        throw new Exception('Could not find element with given ID') if not @el?

        # assign current to the first image
        images = @el.getElementsByTagName('img')
        throw new Exception('Cannot initiate minislider with less than two images') if images.length < 2

        i = 0
        totalImages = images.length
        while i < totalImages
            images[i].style.zIndex = '0'
            images[i].style.left = '0px'
            images[i].next = images[(i + 1) % totalImages]
            i++

        @currentImage = images[0]
        @currentImage.style.zIndex = '100'
        @currentImage.next.style.zIndex = '50'

        @el.setAttribute('class', (@el.getAttribute('class') or '' + ' minislider').trim())

        f = animation_fade
        if(@options.animation == 'slide')
            f = animation_slide

        setTimeout(
            () => f({ current: @currentImage, options: @options }), 
            @options.delay * 1000
        )

    # helper private methods

    # effect methods
    animation_slide = (data) ->
        left = parseInt(data.current.style.left.replace('px'), 10)

        if(left > data.current.width * -1)
            data.current.style.left = (left - data.options.slideStep) + 'px'
            setTimeout(
                () -> animation_slide(data), 
                5
            )
        else
            data.current.style.zIndex = '0'
            data.current.style.left = '0px'
            data.current.next.style.zIndex = '100'
            data.current = data.current.next
            data.current.next.style.zIndex = '50'
            setTimeout(
                () -> animation_slide(data), 
                data.options.delay * 1000
            )

    animation_fade = (data) ->
        if(data.opacity?)
            opacity = data.opacity
        else
            data.opacity = opacity = 100

        fadeStep = 5
        fadeSpeed = 15

        if(opacity - fadeStep >= 0)
            opacity -= fadeStep
            # set the opacity
            data.current.style.opacity = opacity / 100
            data.current.style.filter = 'alpha(opacity=' + opacity + ')'
            data.opacity = opacity

            # recursive call
            setTimeout(
                () -> animation_fade(data),
                fadeSpeed
            )
        else
            data.current.style.zIndex = '0'
            data.current.style.opacity = 1
            data.current.style.filter = 'alpha(opacity=100)'
            data.current.next.style.zIndex = '100'
            data.current = data.current.next
            data.current.next.style.zIndex = '50'
            data.opacity = 100
            setTimeout(
                () -> animation_fade(data), 
                data.options.delay * 1000
            )
        
    # end of effect methods

    extend = (a, b) ->
        output = {}

        for key, value of a
            output[key] = value

        for key, value of b
            output[key] = value

        output

window.minislider = (conf) -> new MiniSlider conf