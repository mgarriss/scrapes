# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scrapes}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Garriss", "Peter Jones", "Bob Showalter"]
  s.date = %q{2009-12-29}
  s.email = %q{mgarriss@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README"
  ]
  s.files = [
    "LICENSE",
     "README",
     "Rakefile",
     "demo/demo.rb",
     "demo/pages/about.rb",
     "demo/pages/main.rb",
     "doc/apple-touch-icon.png",
     "doc/classes/Foils.html",
     "doc/classes/GoogleAbout.html",
     "doc/classes/GoogleMain.html",
     "doc/classes/LocalHTTPServer.html",
     "doc/classes/LocalPagination.html",
     "doc/classes/LocalRedhanded.html",
     "doc/classes/LocalRedhandedEntries.html",
     "doc/classes/LocalRedhandedEntries/Entry.html",
     "doc/classes/LocalSimple.html",
     "doc/classes/RuleParserTest.html",
     "doc/classes/Scrapes.html",
     "doc/classes/Scrapes/Cache.html",
     "doc/classes/Scrapes/Cookies.html",
     "doc/classes/Scrapes/Crawler.html",
     "doc/classes/Scrapes/Hpricot.html",
     "doc/classes/Scrapes/Hpricot/Extractors.html",
     "doc/classes/Scrapes/Initializer.html",
     "doc/classes/Scrapes/Page.html",
     "doc/classes/Scrapes/RE.html",
     "doc/classes/Scrapes/RuleParser.html",
     "doc/classes/Scrapes/RuleParser/Extractor.html",
     "doc/classes/Scrapes/RuleParser/InvalidRuleException.html",
     "doc/classes/Scrapes/RuleParser/Rule.html",
     "doc/classes/Scrapes/Session.html",
     "doc/classes/Scrapes/ToProxy.html",
     "doc/classes/TestCache.html",
     "doc/classes/TestCookies.html",
     "doc/classes/TestCrawler.html",
     "doc/classes/TestInitializer.html",
     "doc/classes/TestRedhandedPage.html",
     "doc/classes/TestSession.html",
     "doc/classes/TestSimpleHTMLPage.html",
     "doc/created.rid",
     "doc/css/main.css",
     "doc/css/panel.css",
     "doc/css/reset.css",
     "doc/favicon.ico",
     "doc/files/LICENSE.html",
     "doc/files/README.html",
     "doc/files/demo/demo_rb.html",
     "doc/files/demo/pages/about_rb.html",
     "doc/files/demo/pages/main_rb.html",
     "doc/files/lib/scrapes/cache_rb.html",
     "doc/files/lib/scrapes/cookbook_rb.html",
     "doc/files/lib/scrapes/cookies_rb.html",
     "doc/files/lib/scrapes/crawler_rb.html",
     "doc/files/lib/scrapes/hpricot_rb.html",
     "doc/files/lib/scrapes/initializer_rb.html",
     "doc/files/lib/scrapes/page_rb.html",
     "doc/files/lib/scrapes/rule_parser_rb.html",
     "doc/files/lib/scrapes/session_rb.html",
     "doc/files/lib/scrapes/to_proxy_rb.html",
     "doc/files/lib/scrapes_rb.html",
     "doc/files/test/cache_rb.html",
     "doc/files/test/cookies_rb.html",
     "doc/files/test/crawler_rb.html",
     "doc/files/test/hpricot_rb.html",
     "doc/files/test/initializer_rb.html",
     "doc/files/test/lib/server_rb.html",
     "doc/files/test/page_rb.html",
     "doc/files/test/pages/foils2_rb.html",
     "doc/files/test/pages/foils_rb.html",
     "doc/files/test/pages/redhanded_entries_rb.html",
     "doc/files/test/pages/redhanded_main_rb.html",
     "doc/files/test/pages/rule_parser_rb.html",
     "doc/files/test/pages/simple_rb.html",
     "doc/files/test/public/foil72_html.html",
     "doc/files/test/public/foil73_html.html",
     "doc/files/test/public/foil74_html.html",
     "doc/files/test/public/foo_txt.html",
     "doc/files/test/public/index_html.html",
     "doc/files/test/public/redhanded_html.html",
     "doc/files/test/public/rule_parser_html.html",
     "doc/files/test/public/simple_html.html",
     "doc/files/test/rule_parser_rb.html",
     "doc/files/test/session_rb.html",
     "doc/files/test/textcontent_rb.html",
     "doc/i/arrows.png",
     "doc/i/results_bg.png",
     "doc/i/tree_bg.png",
     "doc/index.html",
     "doc/js/jquery-1.3.2.min.js",
     "doc/js/jquery-effect.js",
     "doc/js/main.js",
     "doc/js/searchdoc.js",
     "doc/panel/index.html",
     "doc/panel/search_index.js",
     "doc/panel/tree.js",
     "lib/scrapes.rb",
     "lib/scrapes/cache.rb",
     "lib/scrapes/cookbook.rb",
     "lib/scrapes/cookies.rb",
     "lib/scrapes/crawler.rb",
     "lib/scrapes/hpricot.rb",
     "lib/scrapes/initializer.rb",
     "lib/scrapes/page.rb",
     "lib/scrapes/rule_parser.rb",
     "lib/scrapes/session.rb",
     "lib/scrapes/to_proxy.rb",
     "test/cache.rb",
     "test/cookies.rb",
     "test/crawler.rb",
     "test/hpricot.rb",
     "test/initializer.rb",
     "test/lib/server.rb",
     "test/page.rb",
     "test/pages/foils.rb",
     "test/pages/foils2.rb",
     "test/pages/redhanded_entries.rb",
     "test/pages/redhanded_main.rb",
     "test/pages/rule_parser.rb",
     "test/pages/simple.rb",
     "test/public/foil72.html",
     "test/public/foil73.html",
     "test/public/foil74.html",
     "test/public/foo.txt",
     "test/public/index.html",
     "test/public/redhanded.html",
     "test/public/rule_parser.html",
     "test/public/simple.html",
     "test/rule_parser.rb",
     "test/session.rb",
     "test/textcontent.rb"
  ]
  s.homepage = %q{http://github.com/mgarriss/scrapes}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{scrape and validate HTML}
  s.test_files = [
    "test/cache.rb",
     "test/cookies.rb",
     "test/crawler.rb",
     "test/hpricot.rb",
     "test/initializer.rb",
     "test/lib/server.rb",
     "test/page.rb",
     "test/pages/foils.rb",
     "test/pages/foils2.rb",
     "test/pages/redhanded_entries.rb",
     "test/pages/redhanded_main.rb",
     "test/pages/rule_parser.rb",
     "test/pages/simple.rb",
     "test/rule_parser.rb",
     "test/session.rb",
     "test/textcontent.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
