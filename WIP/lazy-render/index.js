// Generated by CoffeeScript 1.3.3
var container, content, scroll, text;

content = "/**\n * Module dependencies.\n */\n\nvar express = require('../../lib/express')\n  , hash = require('./pass').hash;\n\nvar app = module.exports = express();\n\n// config\n\napp.set('view engine', 'ejs');\napp.set('views', __dirname + '/views');\n\n// middleware\n\napp.use(express.bodyParser());\napp.use(express.cookieParser('shhhh, very secret'));\napp.use(express.session());\n\n// Session-persisted message middleware\n\napp.use(function(req, res, next){\n  var err = req.session.error\n    , msg = req.session.success;\n  delete req.session.error;\n  delete req.session.success;\n  res.locals.message = '';\n  if (err) res.locals.message = '<p class=\"msg error\">' + err + '</p>';\n  if (msg) res.locals.message = '<p class=\"msg success\">' + msg + '</p>';\n  next();\n});\n\n// dummy database\n\nvar users = {\n  tj: { name: 'tj' }\n};\n\n// when you create a user, generate a salt\n// and hash the password ('foobar' is the pass here)\n\nhash('foobar', function(err, salt, hash){\n  if (err) throw err;\n  // store the salt & hash in the \"db\"\n  users.tj.salt = salt;\n  users.tj.hash = hash;\n});\n\n\n// Authenticate using our plain-object database of doom!\nfunction authenticate(name, pass, fn) {\n  if (!module.parent) console.log('authenticating %s:%s', name, pass);\n  var user = users[name];\n  // query the db for the given username\n  if (!user) return fn(new Error('cannot find user'));\n  // apply the same algorithm to the POSTed password, applying\n  // the hash against the pass / salt, if there is a match we\n  // found the user\n  hash(pass, user.salt, function(err, hash){\n    if (err) return fn(err);\n    if (hash == user.hash) return fn(null, user);\n    fn(new Error('invalid password'));\n  })\n}\n\nfunction restrict(req, res, next) {\n  if (req.session.user) {\n    next();\n  } else {\n    req.session.error = 'Access denied!';\n    res.redirect('/login');\n  }\n}\n\napp.get('/', function(req, res){\n  res.redirect('login');\n});\n\napp.get('/restricted', restrict, function(req, res){\n  res.send('Wahoo! restricted area');\n});\n\napp.get('/logout', function(req, res){\n  // destroy the user's session to log them out\n  // will be re-created next request\n  req.session.destroy(function(){\n    res.redirect('/');\n  });\n});\n\napp.get('/login', function(req, res){\n  if (req.session.user) {\n    req.session.success = 'Authenticated as ' + req.session.user.name\n      + ' click to <a href=\"/logout\">logout</a>. '\n      + ' You may now access <a href=\"/restricted\">/restricted</a>.';\n  }\n  res.render('login');\n});\n\napp.post('/login', function(req, res){\n  authenticate(req.body.username, req.body.password, function(err, user){\n    if (user) {\n      // Regenerate session when signing in\n      // to prevent fixation \n      req.session.regenerate(function(){\n        // Store the user's primary key \n        // in the session store to be retrieved,\n        // or in this case the entire user object\n        req.session.user = user;\n        res.redirect('back');\n      });\n    } else {\n      req.session.error = 'Authentication failed, please check your '\n        + ' username and password.'\n        + ' (use \"tj\" and \"foobar\")';\n      res.redirect('login');\n    }\n  });\n});\n\nif (!module.parent) {\n  app.listen(3000);\n  console.log('Express started on port 3000');\n}";

container = void 0;

text = void 0;

scroll = function() {
  var amountScrolled, endLine, height, howMany, lines, paddingBottom, paddingTop, startLine, viewport;
  lines = content.split('\n');
  height = lines.length * 16;
  amountScrolled = container[0].scrollTop;
  viewport = {
    height: container.height()
  };
  howMany = viewport.height / 16;
  if (amountScrolled + viewport.height >= height) {
    paddingTop = height - viewport.height;
    paddingBottom = 0;
    startLine = lines.length - howMany;
  } else {
    startLine = amountScrolled / 16;
    paddingTop = amountScrolled;
    paddingBottom = (height - amountScrolled) - viewport.height;
  }
  endLine = startLine + howMany;
  text.css({
    paddingTop: paddingTop,
    paddingBottom: paddingBottom
  });
  text.text(lines.slice(startLine, endLine + 2).join('\n'));
  return text.html(text.html() + '<div class="clear"></div>');
};

$(function() {
  container = $('#container');
  text = $('#text', container);
  scroll();
  container.scroll(scroll);
  return $(window).resize(scroll);
});
