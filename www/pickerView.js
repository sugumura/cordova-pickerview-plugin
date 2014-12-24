var PickerView = function() {};

PickerView.prototype.show = function(options) {
  for (var i = 0; i < options.length; i++) {
    options[i].defaultIndex = options[i].options.indexOf(options[i].default);
  }
  return {
    then: function(success,fail) {
        cordova.exec(success, fail, "PickerView", "show", [options]);
    }
  }
};

var pickerView = new PickerView();
module.exports = pickerView;
