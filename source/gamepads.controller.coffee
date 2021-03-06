Gamepads.Controller = (I={}) ->
  Object.reverseMerge I,
    debugColor: "#000"

  MAX_BUFFER = 0.03
  AXIS_MAX = 1 - MAX_BUFFER
  DEAD_ZONE = AXIS_MAX * 0.25
  TRIP_HIGH = AXIS_MAX * 0.75
  TRIP_LOW = AXIS_MAX * 0.5

  BUTTON_THRESHOLD = 0.5

  buttonMapping =
    "A": 0
    "B": 1

    "X": 2
    "Y": 3

    "LB": 4
    "RB": 5

    "LT": 6
    "RT": 7

    "SELECT": 8
    "BACK": 8

    "START": 9

    "TL": 10
    "TR": 11

    "HOME": 16

  currentState = ->
    I.state.current?[I.index]

  previousState = ->
    I.state.previous?[I.index]

  axisTrips = []
  tap = Point(0, 0)

  processTaps = ->
    [x, y] = [0, 1].map (n) ->
      if !axisTrips[n] && self.axis(n).abs() > TRIP_HIGH
        axisTrips[n] = true

        return self.axis(n).sign()

      if axisTrips[n] && self.axis(n).abs() < TRIP_LOW
        axisTrips[n] = false

      return 0

    tap = Point(x, y)

  self = Core().include(Bindable).extend
    buttonDown: (buttons...) ->
      if state = currentState()
        buttons.inject false, (down, button) ->
          down || if button is "ANY"
            state.buttons.inject false, (down, button) ->
              down || (button > BUTTON_THRESHOLD)
          else
            state.buttons[buttonMapping[button]] > BUTTON_THRESHOLD
      else
        false

    # true if button was just pressed
    buttonPressed: (button) ->
      buttonId = buttonMapping[button]

      return (self.buttons()[buttonId] > BUTTON_THRESHOLD) && !(previousState()?.buttons[buttonId] > BUTTON_THRESHOLD)

    buttonReleased: (button) ->
      buttonId = buttonMapping[button]

      return !(self.buttons()[buttonId] > BUTTON_THRESHOLD) && (previousState()?.buttons[buttonId] > BUTTON_THRESHOLD)

    position: (stick=0) ->
      if state = currentState()
        p = Point(self.axis(2*stick), self.axis(2*stick+1))

        magnitude = p.magnitude()

        if magnitude > AXIS_MAX
          p.norm()
        else if magnitude < DEAD_ZONE
          Point(0, 0)
        else
          ratio = magnitude / AXIS_MAX

          p.scale(ratio / AXIS_MAX)

      else
        Point(0, 0)

    axis: (n) ->
      self.axes()[n] || 0

    axes: ->
      if state = currentState()
        state.axes
      else
        []

    buttons: ->
      if state = currentState()
        state.buttons
      else
        []

    tap: ->
      tap

    update: ->
      processTaps()

    drawDebug: (canvas) ->
      lineHeight = 18

      self.axes().each (axis, i) ->
        canvas.drawText
          color: I.debugColor
          text: axis
          x: 0
          y: (i + 1) * lineHeight

      self.buttons().each (button, i) ->
        canvas.drawText
          color: I.debugColor
          text: "#{i}:"
          x: 230
          y: (i + 1) * lineHeight

        canvas.drawText
          color: I.debugColor
          text: button
          x: 250
          y: (i + 1) * lineHeight
