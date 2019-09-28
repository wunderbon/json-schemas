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

var webserverPort = process.env.WUNDERBON_DATA_STRUCTURE_MODELS_PORT || 8080;

/**
 * Live reload middleware of JSON schemes below "schema" directory.
 */
app.use(
  function (req, res, next) {

    if (req.originalUrl === '/' || req.originalUrl.indexOf('index.html') >= 0) {
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
          var injectHtml = '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous"> <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous"><script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script> <style>body {margin: 20px;}</style>';
          fs.writeFileSync('./public/' + newFile, html.replace('</script></head><body>', '</script>' + injectHtml + '</head><body>'));

          var htmlLink   = '<p><a href="' + newFile + '" target="content">' + nameFromFileName(path.basename(file)) + ' JSON Schema</a></p>';
          navigationHtml = navigationHtml + htmlLink;
        });

        fs.writeFileSync('./public/navigation.html', template.replace('<noscript>navigation</noscript>', navigationHtml));
      }

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
