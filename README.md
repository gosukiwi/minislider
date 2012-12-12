# minislider
minislider is a **vanilla javascript** slider, meaning it does not require
jQuery nor any library, it's coded on [CoffeScript](http://coffeescript.org/)
and it was tested on IE 8, 9, 10 and latest Chrome.

# Usage
Using minislider is as easy as including the .js and the .css file in your
HTML, and then simply invoking minislider with a configuration object

```
minislider({
    element: 'slide',   // the id of the list containing the images
    delay: 2,           // the delay in seconds between each animation
    animation: 'fade'   // it can be 'fade', 'slide' or a custom animation function
});
```

For a full example see ```demo.html```. 