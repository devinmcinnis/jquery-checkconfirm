# Small jQuery plugin to extend confirm passwords
$.fn.checkConfirm = (options) ->

  # Custom settings with fallbacks
  settings =

    # Match custom setting or next input in form based on Bootstrap markup
    match:        options.match       or '#' + $(this).parents('.control-group').next().find('input')[0].id
    match_text:   options.match_text  or 'Passwords do not match'
    length:       options.length      or 8
    length_text:  options.length_text or 'Password length is too short'
    parent:       options.parent      or $(this).parent()

  # Always associate "that" with the original password input
  that = this
  match = $(settings.match)

  $(document).on
    keyup: (doc) ->
      el = doc.target
      $parent = $(el).parents '.controls'

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
      $parent = $(el).parents '.controls'

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

    $parent = $(el).closest '.controls'
    $icon = $parent.find 'i'
    $hint = $parent.find '.hint'

    # If there is no icon to notify valid input, add one
    if $icon.size() is 0 then $parent.append '<i class="icon-ok-sign"></i>'

    # If there was a error warning before, remove it
    $hint.remove() if $hint.size() > 0

    # Remove error class from parent
    $parent.removeClass 'error'

    # Add validated class to parent if it was not valid before
    $parent.addClass 'validated' if !$parent.hasClass 'validated'

  validateFail = (el, msg) ->
    # Set inputs data to invalid
    $(el).data 'valid', false

    $parent = $(el).closest '.controls'
    $icon = $parent.find 'i'
    $hint = $parent.find '.hint'

    # Remove valid icon and previous warnings
    $icon.remove() if $icon.size() > 0
    $hint.remove() if $hint.size() > 0

    # Add class to parent if it wasn't already an error
    $parent.addClass 'error' if !$parent.hasClass 'error'

    # Append new warning if supplied with msg
    $parent.append '<span class="hint">' + msg + '</span>' if msg

    # Remove validity of input if it was previously valid
    $parent.removeClass 'validated' if $parent.hasClass 'validated'