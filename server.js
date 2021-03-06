'use strict';

/**
 * Serves the schema documentation with docson.
 */
var express     = require('express');
var serveStatic = require('serve-static');
var app         = express();
var fs          = require('fs');
var path        = require('path');
var docson      = require('node-docson');
var showdown    = require('showdown');
var info        = require('./package.json');
var template;
var rendered    = false;
var webserverPort = process.env.WUNDERBON_JSON_SCHEMAS_PORT || 8080;

/**
 * Live reload middleware of JSON schemes below "schema" directory.
 */
app.use(
  function (req, res, next) {

    if ((req.originalUrl === '/' || req.originalUrl.indexOf('index.html') >= 0) && false === rendered) {
      // Find schemas
      var files = fromDir('./schema', '.schema.json');

      if (files.length > 0) {
        // Prepare templating
        template           = fs.readFileSync('./template/navigation.html', 'utf8');
        var navigationHtml = '';

        // Build HTML docson for schemas found
        files.forEach(function (file) {
          var docsonObject = new docson();
          var schema       = fs.readFileSync(file, 'utf8');
          var element      = docsonObject.doc(schema);
          var newFile      = path.basename(file) + '.html';

          var html       = element.ownerDocument.documentElement.outerHTML;
          var injectHtml = '<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous"> <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script> <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script> <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script> <style>body {margin: 20px;}</style>';
          fs.writeFileSync('./public/' + newFile, html.replace('</script></head><body>', '</script>' + injectHtml + '</head><body>'));

          var htmlLink   = '<p><a href="' + newFile + '" target="content">' + nameFromFileName(path.basename(file)) + '</a></p>';
          navigationHtml = navigationHtml + htmlLink;
        });

        fs.writeFileSync('./public/navigation.html', template.replace('<noscript>navigation</noscript>', navigationHtml));
      }

      rendered = true;

      next(); // Continue on to the next middleware/route handler

    } else if (req.originalUrl === '/readme.html') {
      var converter = new showdown.Converter();
      var markdown  = fs.readFileSync('./README.md', 'utf8');
      var html      = converter.makeHtml(markdown);
      template      = fs.readFileSync('./template/readme.html', 'utf8');

      res.set('Content-Type', 'text/html');
      res.end(new Buffer(template.replace('<noscript>readme</noscript>', html)));

    } else {
      next(); // Continue on to the next middleware/route handler
    }
  }
);

/**
 * Provide generic static access to all files below root directory.
 */
app.use(
  express.static('./')
);

/**
 * Provide static access to assets below public directory.
 */
app.use(
  serveStatic('./public', {'index': ['index.html', 'index.htm']})
);

/**
 * Listen and tell ...
 */
app.listen(webserverPort, function () {
  console.log(info.name + ' server listening on port ' + webserverPort + ' (HTTP) ...');
});

/**
 * Returns name by filename (e.g. ddd).
 *
 * @param {string} filename
 *
 * @return {string}
 */
function nameFromFileName(filename)
{
  var parts = filename.replace('.schema.json', '').split('.');
  var name  = parts[0];
  return name[0].toUpperCase() + name.substring(1);
}

/**
 * Resolves files recursive from entryPath by pattern.
 *
 * @param {string} entryPath Path to start
 * @param {string} pattern   Extension pattern to look for
 * @param {array}  result    Result used for recursion
 *
 * @return {array} Resulting files
 */
function fromDir(entryPath, pattern, result)
{
  result = typeof result !== 'undefined' ? result : [];

  if (!fs.existsSync(entryPath)) {
    return;
  }

  // Fetch all files
  var files = fs.readdirSync(entryPath);

  // Iterate found files and filter by pattern
  for (var i = 0; i < files.length; i++) {

    var filename = path.join(entryPath, files[i]);
    var stat     = fs.lstatSync(filename);

    if (stat.isDirectory()) {
      // recurse
      result = fromDir(filename, pattern, result);
    } else if (filename.indexOf(pattern) >= 0) {
      result.push(filename);
    }
  }

  return result;
}
