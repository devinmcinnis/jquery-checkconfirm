jQuery(function($) {
  return $.fn.checkConfirm = function(options) {
    var checkLength, match, settings, that, validateFail, validatePass;
    settings = {
      match: options.match || '#' + $(this).parents('.control-group').next().find('input')[0].id,
      match_text: options.match_text || 'Passwords do not match',
      length: options.length || 8,
      length_text: options.length_text || 'Password length is too short',
      parent: options.parent || $(this).parent()
    };
    that = this;
    match = $(settings.match);
    $(document).on({
      keyup: function(doc) {
        var $parent, el;
        el = doc.target;
        $parent = $(el).parents('.controls');
        if (that[0].id === el.id) {
          if (checkLength(el)) {
            validatePass(el);
            if (match.parent().hasClass('validated') && !checkLength(settings.match)) {
              validateFail(settings.match, settings.match_text);
            } else if (!match.parent().hasClass('validated') && checkLength(settings.match)) {
              validatePass(settings.match);
            } else if (match.val().length > 0 && !checkLength(settings.match)) {
              validateFail(settings.match, settings.match_text);
            }
          }
          if (!checkLength(el) && $parent.hasClass('validated')) {
            validateFail(el, settings.length_text);
            return validateFail(settings.match);
          }
        } else {
          if (checkLength(el) && that[0].value === el.value) {
            validatePass(el);
          }
          if (!checkLength(el) && $parent.hasClass('validated')) {
            return validateFail(el, settings.match_text);
          }
        }
      },
      blur: function(doc) {
        var $parent, el;
        el = doc.target;
        $parent = $(el).parents('.controls');
        if (!checkLength(el) && !$parent.hasClass('error') && $(el)[0].value.length > 0) {
          validateFail(el, settings.length_text);
        }
        if ('#' + el.id === settings.match && that[0].value !== el.value) {
          return validateFail(el, settings.match_text);
        }
      }
    }, this.selector + ', ' + settings.match);
    checkLength = function(el) {
      if (el.id === that[0].id) {
        return $(el)[0].value.length >= settings.length;
      } else {
        return $(el)[0].value.length === that[0].value.length && $(el)[0].value.length >= settings.length;
      }
    };
    validatePass = function(el) {
      var $hint, $icon, $parent;
      $(el).data('valid', true);
      $parent = $(el).closest('.controls');
      $icon = $parent.find('i');
      $hint = $parent.find('.hint');
      if ($icon.size() === 0) {
        $parent.append('<i class="icon-ok-sign"></i>');
      }
      if ($hint.size() > 0) {
        $hint.remove();
      }
      $parent.removeClass('error');
      if (!$parent.hasClass('validated')) {
        return $parent.addClass('validated');
      }
    };
    return validateFail = function(el, msg) {
      var $hint, $icon, $parent;
      $(el).data('valid', false);
      $parent = $(el).closest('.controls');
      $icon = $parent.find('i');
      $hint = $parent.find('.hint');
      if ($icon.size() > 0) {
        $icon.remove();
      }
      if ($hint.size() > 0) {
        $hint.remove();
      }
      if (!$parent.hasClass('error')) {
        $parent.addClass('error');
      }
      if (msg) {
        $parent.append('<span class="hint">' + msg + '</span>');
      }
      if ($parent.hasClass('validated')) {
        return $parent.removeClass('validated');
      }
    };
  };
});