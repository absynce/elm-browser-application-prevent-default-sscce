# [SSCCE](http://www.sscce.org/) - prevent default on `a` tag in `Browser.application` page does not stop link URL change

## Issue

[`Browser.application`](https://package.elm-lang.org/packages/elm/browser/1.0.2/Browser#application) ignores [`Html.Events.preventDefaultOn`](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#preventDefaultOn) for a `click` handler within a link. Instead, it always returns a `onUrlRequest` message.

`preventDefaultOn` works as expected in `Browser.element`. See the `working-element` directory for the expected behavior.

## Run

At command prompt with Elm 0.19.1 installed:

    elm make src/Main.elm --output=elm.js
    elm reactor

Open browser to http://localhost:8000/index.html. Click the button inside the link box.

## Use case

I am building a PWA with Elm. On a page there's a list of items with the option to favorite each or drill in for more details. The favorite button is inside each item.

Links are ideal in case the user wants to open new tabs for items in the list without navigating away from the list, either with a right-click menu option or Ctrl + click on the link.

## Workaround

My workaround for now is to change the outer link to an `onClick` event and use [`Browser.Navigation.pushUrl`](https://package.elm-lang.org/packages/elm/browser/1.0.2/Browser-Navigation#pushUrl) from within the event message handler. This uses [`Html.Events.stopPropagationOn`](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#stopPropagationOn) instead of `Html.Events.preventDefaultOn` from within the inner button.

    onClickStopPropagation : msg -> Html.Attribute msg
    onClickStopPropagation tagger =
        Html.Events.stopPropagationOn "click" <|
            Json.Decode.map alwaysStop
                (Json.Decode.succeed tagger)


    alwaysStop : a -> ( a, Bool )
    alwaysStop x =
        ( x, True )

### Further workaround potential

Although I have not tried it, I assume there might be a couple of additional workarounds to get the intended behavior:

1. Look for the specific URL request in question within the `onUrlRequest` handler and ignore it with some state detection.
2. Expand the current workaround (button click handler) to check if the `Ctrl` key is pressed and call some JS ([`Window.open()`](https://developer.mozilla.org/en-US/docs/Web/API/Window/open)) from a port.
