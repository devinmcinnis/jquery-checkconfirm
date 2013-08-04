# jQuery Password Confirmation Validation

jQuery plugin made specifically to work alongside Bootstrap for password confirmation validation.

## Getting started

This plugin was made to work with Bootstrap 3 RC1 but will also work without it with a small markup adjustment.  
To use the example, make sure to have [CoffeeScript](http://coffeescript.org) installed globally and run `make`. This will compile and watch the CoffeeScript file as you make changes but will not minify the JavaScript file.

### HTML

#### With Bootstrap
Here is a basic form label/input setup within Bootstrap.

```
<div class="form-group">
  <label for="inputPassword">Password</label>
  <input type="password" class="form-control" id="inputPassword" placeholder="Password">
</div>
<div class="form-group">
  <label for="inputPasswordConfirm">Confirm Password</label>
  <input type="password" class="form-control" id="inputPasswordConfirm" placeholder="Confirm Password">
</div>
```

#### Without Bootstrap
All you need is to wrap your input elements in another element, preferably a `<div>` or `<span>` for semantic reasons.

```
<div>
  <input type="password" id="inputPassword" placeholder="Password">
</div>
<div>
  <input type="password" id="inputPasswordConfirm" placeholder="Confirm Password">
</div>
```

### Javascript

Supply a single argument and it will take it as the confirm password input field.
```
$('#inputPassword').checkConfirm('#inputPasswordConfirm');
```

Or supply any or all of the following arguments to customize the plugin.
```
$('#inputPassword').checkConfirm({
  match: '#inputPasswordConfirm',
  match_text: 'Does not match password!',
  length: 10,
  length_text: 'Does not match preferred length',
  parent: '.form-group'
});
```

## Settings
There are a few options to tamper with to give you a little customization.

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Type</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>match</td>
      <td>ID of confirm password input element</td>
      <td>String</td>
      <td>$(this).parents('.form-group').next().find('input')</td>
    </tr>
    <tr>
      <td>match_text</td>
      <td>Text to display if passwords do not match</td>
      <td>String</td>
      <td>"Passwords do not match"</td>
    </tr>
    <tr>
      <td>length</td>
      <td>Minimum length of password</td>
      <td>Number</td>
      <td>8</td>
    </tr>
    <tr>
      <td>length_text</td>
      <td>Text to display if password is too short</td>
      <td>String</td>
      <td>"Passwords length is too short"</td>
    </tr>
    <tr>
      <td>parent</td>
      <td>Parent element of password input elements</td>
      <td>String</td>
      <td>$(this).parent()</td>
    </tr>
  </tbody>
</table>

## Contributing

Feel free to send pull requests and please use Google's [Closure Compiler](http://closure-compiler.appspot.com/home) to minify your file.