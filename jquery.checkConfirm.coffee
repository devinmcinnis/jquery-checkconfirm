# Small jQuery plugin to extend confirm passwords
$.fn.checkConfirm = (options) ->

  # Always associate "that" with the original password input
  that = this

  # Update default parent element for Bootstrap 3 RC1
  parentEl = '.form-group'

  # Custom settings with fallbacks
  settings =

    # Match custom setting or next input in form based on Bootstrap markup
    match:        (if (arguments.length is 1 and typeof arguments[0] is "string") then options else options.match or "#" + $(this).parents(parentEl).next().find("input")[0].id),
    match_text:   options.match_text  or 'Passwords do not match'
    length:       (if arguments.length is 1 then 8 else options.length or 8)
    length_text:  options.length_text or 'Password length is too short'
    parent:       options.parent      or $(this).parent()
  
  # Confirm password input
  match = $(settings.match)

  $(document).on
    keyup: (doc) ->
      el = doc.target
      $parent = $(el).parents parentEl

      # If the element is the original password input
      if that[0].id is el.id

        # And the password length is at least the minimum length
        if checkLength(el)
          validatePass el

          # If the passwords did match and user changes original password
          if match.parent().hasClass('validated') and !checkLength(settings.match)
            validateFail settings.match, settings.match_text

          # If confirm password is not validated but is now equal to the original password
          else if !match.parent().hasClass('validated') and checkLength(settings.match)
            validatePass settings.match

          # If there is a value in the confirm input but it doesn't match the original password
          else if match.val().length > 0 and !checkLength(settings.match)
            validateFail settings.match, settings.match_text

        # Or if the input has already been validated to true but the length is now too short
        if !checkLength(el) and $parent.hasClass 'validated'
          validateFail el, settings.length_text
          validateFail settings.match

      # If the element is the confirm password field
      else

        # If the length is equal to the length
        if checkLength(el)
          
          # If passwords match
          if that[0].value is el.value
            validatePass el

          else
            validateFail el, settings.match_text

        # If confirm password was validated but the length no longer meets the requirement
        if !checkLength(el) and $parent.hasClass 'validated'
          validateFail el, settings.match_text

    blur: (doc) ->
      el = doc.target
      $parent = $(el).parents parentEl

      # If the length is not long enough and the element has a value and not currently an error
      if !checkLength(el) and !$parent.hasClass('error') and $(el)[0].value.length > 0
        validateFail el, settings.length_text

      # If the confirmation password does not match the original password
      if '#' + el.id is settings.match and that[0].value != el.value
        validateFail el, settings.match_text

    # Apply keyup and blur events to supplied elements
    # There has to be a better way to do this, please create issue to let me know, thanks!
    , this.selector + ', ' + settings.match

  checkLength = (el) ->
    # If the testing element is the original password
    if el.id is that[0].id
      # Make sure it is at least the minimum
      $(el)[0].value.length >= settings.length

    # If the testing element is the confirm password
    else
      # Make sure it is equal to the length of the original password
      $(el)[0].value.length == that[0].value.length and $(el)[0].value.length >= settings.length

  validatePass = (el) ->
    # Set inputs data to valid
    $(el).data 'valid', true

    $parent = $(el).closest parentEl
    $icon = $parent.find '.glyphicon'
    $hint = $parent.find '.help-block'

    validated = $parent.hasClass('validated')

    # Remove failing icon
    if $icon.size() is 1 && !validated then $icon.remove()

    # If there is no icon to notify valid input, add one
    if !validated then $parent.append '<span class="glyphicon glyphicon-ok"></span>'

    # If there was a error warning before, remove it
    $hint.remove() if $hint.size() > 0

    # Remove error class from parent
    $parent.removeClass 'error' if $parent.hasClass 'error'

    # Add validated class to parent if it was not valid before
    $parent.addClass 'validated' if !$parent.hasClass 'validated'

  validateFail = (el, msg) ->
    # Set inputs data to invalid
    $(el).data 'valid', false

    $parent = $(el).closest parentEl
    $icon = $parent.find '.glyphicon'
    $hint = $parent.find '.help-block'

    error = $parent.hasClass('error')

    # Remove valid icon and previous warnings
    $icon.remove() if $icon.size() > 0
    $hint.remove() if $hint.size() > 0

    # If there is no icon to notify valid input, add one
    if $icon.size() is 0 or !error then $parent.append '<span class="glyphicon glyphicon-remove"></span>'

    # Add class to parent if it wasn't already an error
    $parent.addClass 'error' if !$parent.hasClass 'error'

    # Append new warning if supplied with msg
    $parent.append '<span class="help-block">' + msg + '</span>' if msg

    # Remove validity of input if it was previously valid
    $parent.removeClass 'validated' if $parent.hasClass 'validated'