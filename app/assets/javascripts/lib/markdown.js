/*global Markdown, console */

Rigidoj.Markdown = {

  /**
   Convert a raw string to a cooked markdown string.

   @method cook
   @param {String} raw the raw string we want to apply markdown to
   @param {Object} opts the options for the rendering
   @return {String} the cooked markdown string
   **/
  cook: function(raw, opts) {
    if (!opts) opts = {};

    // Make sure we've got a string
    if (!raw || raw.length === 0) return "";

    return this.markdownConverter(opts).makeHtml(raw);
  },

  /**
   Creates a Markdown.Converter that we we can use for formatting

   @method markdownConverter
   @param {Object} opts the converting options
   **/
  markdownConverter: function(opts) {
    if (!opts) opts = {};

    return {
      makeHtml: function(text) {
        var converter = new Markdown.Converter();
        text = converter.makeHtml(text);
        return !text ? "" : text;
      }
    };
  }

};
