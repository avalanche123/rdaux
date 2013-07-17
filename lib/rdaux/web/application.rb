require 'posix/spawn'
require 'sinatra/base'

module RDaux
  module Web
    class Application < Sinatra::Base
      attr_reader :current_section

      enable :logging, :inline_templates

      get '/img/ditaa/:id.png/?' do |id|
        txt_path = settings.public_folder + "/img/ditaa/#{id}.txt"
        png_path = settings.public_folder + "/img/ditaa/#{id}.png"

        halt(404) unless File.exists?(txt_path)

        Process::waitpid(POSIX::Spawn.spawn("java", '-jar', settings.ditaa_jar, txt_path, png_path))
        File.unlink(txt_path)

        send_file(png_path, :status => 201)
      end

      get '/' do
        erb(:site)
      end

      def site
        settings.site || halt(500)
      end

      def markdown
        settings.markdown || halt(500)
      end

      def render_markdown(markup)
        markdown.render(markup)
      end
    end
  end
end

__END__

@@ site
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title><%= site.title %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="<%= site.description %>">
    <meta name="author" content="<%= site.author %>">

    <!-- Le styles -->
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/pygments.css" rel="stylesheet">
    <link href="/css/bootstrap-responsive.min.css" rel="stylesheet">

    <style>
    body {
      margin: 20px 0;
    }
    .header {
    }
    .contents {
    }
    .footer {
    }
    .docs-sidenav {
      margin: 30px 0 0;
      padding: 0;
      background-color: #fff;
    }
    .docs-sidenav .nav-list {
      padding-right: 0;
    }
    .docs-sidenav > li > a {
      padding: 8px 14px 8px 14px;
    }
    .docs-sidenav .nav-list > li > a {
      padding: 8px 14px 8px 14px;
    }
    .docs-sidenav .icon-chevron-right {
      float: right;
      margin-top: 2px;
      margin-right: -6px;
      opacity: .25;
    }
    .docs-sidenav > li > a:hover {
      background-color: #f5f5f5;
    }
    .docs-sidenav a:hover .icon-chevron-right {
      opacity: .5;
    }
    .docs-section {
      padding-top: 30px;
    }
    </style>

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="/js/html5shiv.js"></script>
    <![endif]-->

    <!-- Fav and touch icons -->
    <!-- <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="/ico/apple-touch-icon-57-precomposed.png">
    <link rel="shortcut icon" href="/ico/favicon.png"> -->
  </head>

  <body>
    <div class="container-fluid">

      <header class="header">
        <h1><%= site.title %></h1>
        <p class="lead"><%= site.description %></p>
      </header>

      <article class="row-fluid contents">
        <nav class="span3 navigation">
          <ul class="nav nav-list docs-sidenav">
            <%= erb(:nav, :locals => { :sections => site.sections, :base => '' }) %>
          </ul>
        </nav>

        <div class="span9 documentation">
          <%= erb(:docs, :locals => { :sections => site.sections, :base => '' }) %>
        </div>
      </article>

      <footer class="footer">
        <p class="text-center">Automatically generated with <a href="https://github.com/avalanche123/rdaux">RDaux, beautiful markdown docs</a></p>
      </footer>

    </div> <!-- /container -->

    <script src="/js/jquery.min.js"></script>
    <script src="/js/bootstrap.min.js"></script>

  </body>
</html>

@@ docs
<% for key, section in sections %>
<a name="<%= base %><%= section.key %>"></a>
<% if section.has_contents? %>
<section class="docs-section">
  <%= render_markdown(section.contents) %>
</section>
<% end %>
<% if section.has_children? %>
<%= erb(:docs, :locals => { :sections => section.sections, :base => section.key + '.' }) %>
<% end %>
<% end %>

@@ nav
<% for key, section in sections %>
  <li<% if section == current_section %> class="active"<% end %>>
    <a href="#<%= base %><%= section.key %>" title="<%= section.title %>"><i class="icon-chevron-right"></i><%= section.title %></a>
    <% if section.has_children? %>
    <ul class="nav nav-list">
      <%= erb(:nav, :locals => { :sections => section.sections, :base => section.key + '.' }) %>
    </ul>
    <% end %>
  </li>
<% end %>
