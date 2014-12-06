define("ace/theme/yesterday",["require","exports","module","ace/lib/dom"], function(require, exports, module) {

  exports.isDark = false;
  exports.cssClass = "ace-yesterday";
  exports.cssText = ".ace-yesterday .ace_gutter {\
background: #fff;\
border-right: 1px solid #ddd;\
color: #999;\
font-size: 8pt\
}\
.ace-yesterday .ace_print-margin {\
width: 1px;\
background: #f6f6f6\
}\
.ace-yesterday {\
background-color: #FFFFFF;\
color: #4D4D4C\
}\
.ace-yesterday .ace_cursor {\
color: #AEAFAD\
}\
.ace_scroller.ace_scroll-left {\
box-shadow: none\
}\
.ace-yesterday .ace_marker-layer .ace_selection {\
background: #D6D6D6\
}\
.ace-yesterday.ace_multiselect .ace_selection.ace_start {\
box-shadow: 0 0 3px 0px #FFFFFF;\
border-radius: 2px\
}\
.ace-yesterday .ace_marker-layer .ace_step {\
background: rgb(255, 255, 0)\
}\
.ace-yesterday .ace_marker-layer .ace_bracket {\
margin: -1px 0 0 -1px;\
border: 1px solid #D1D1D1\
}\
.ace-yesterday .ace_marker-layer .ace_active-line {\
background: #EFEFEF\
}\
.ace-yesterday .ace_gutter-active-line {\
background-color : #dcdcdc\
}\
.ace-yesterday .ace_marker-layer .ace_selected-word {\
border: 1px solid #D6D6D6\
}\
.ace-yesterday .ace_invisible {\
color: #D1D1D1\
}\
.ace-yesterday .ace_keyword,\
.ace-yesterday .ace_meta,\
.ace-yesterday .ace_storage,\
.ace-yesterday .ace_storage.ace_type,\
.ace-yesterday .ace_support.ace_type {\
color: #8959A8\
}\
.ace-yesterday .ace_keyword.ace_operator {\
color: #3E999F\
}\
.ace-yesterday .ace_constant.ace_character,\
.ace-yesterday .ace_constant.ace_language,\
.ace-yesterday .ace_constant.ace_numeric,\
.ace-yesterday .ace_keyword.ace_other.ace_unit,\
.ace-yesterday .ace_support.ace_constant,\
.ace-yesterday .ace_variable.ace_parameter {\
color: #F5871F\
}\
.ace-yesterday .ace_constant.ace_other {\
color: #666969\
}\
.ace-yesterday .ace_invalid {\
color: #FFFFFF;\
background-color: #C82829\
}\
.ace-yesterday .ace_invalid.ace_deprecated {\
color: #FFFFFF;\
background-color: #8959A8\
}\
.ace-yesterday .ace_fold {\
background-color: #4271AE;\
border-color: #4D4D4C\
}\
.ace-yesterday .ace_entity.ace_name.ace_function,\
.ace-yesterday .ace_support.ace_function,\
.ace-yesterday .ace_variable {\
color: #4271AE\
}\
.ace-yesterday .ace_support.ace_class,\
.ace-yesterday .ace_support.ace_type {\
color: #C99E00\
}\
.ace-yesterday .ace_heading,\
.ace-yesterday .ace_markup.ace_heading,\
.ace-yesterday .ace_string {\
color: #718C00\
}\
.ace-yesterday .ace_entity.ace_name.ace_tag,\
.ace-yesterday .ace_entity.ace_other.ace_attribute-name,\
.ace-yesterday .ace_meta.ace_tag,\
.ace-yesterday .ace_string.ace_regexp,\
.ace-yesterday .ace_variable {\
color: #C82829\
}\
.ace-yesterday .ace_comment {\
color: #8E908C\
}\
.ace-yesterday .ace_indent-guide {\
background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAACCAYAAACZgbYnAAAAE0lEQVQImWP4////f4bdu3f/BwAlfgctduB85QAAAABJRU5ErkJggg==) right repeat-y\
}";

  var dom = require("../lib/dom");
  dom.importCssString(exports.cssText, exports.cssClass);
});
