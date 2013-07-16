require 'posix/spawn'
require 'sinatra/base'

module RDaux
  module Web
    class Application < Sinatra::Base
      attr_reader :current_section

      enable :logging, :inline_templates

      get '/img/diagrams/:id.png/?' do |id|
        txt_path = settings.public_folder + "/img/diagrams/#{id}.txt"
        png_path = settings.public_folder + "/img/diagrams/#{id}.png"

        halt(404) unless File.exists?(txt_path)

        Process::waitpid(POSIX::Spawn.spawn("java", '-jar', settings.ditaa_jar, txt_path, png_path))

        redirect request.path_info
      end

      get '/' do
        redirect '/' + site.sections.keys.first
      end

      get '/*/?' do |path|
        section = path.split('/').inject(site) do |section, segment|
          break nil if section.nil?
          section.sections[segment]
        end

        halt(404) if section.nil?

        @current_section = section

        if section.has_contents?
          erb(:page, :locals => { :section => @current_section })
        else
          redirect '/' + path + '/' + section.sections.keys.first
        end
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

@@ layout

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
      margin: 20px 0;
    }
    .footer {
    }
    .docs-sidenav {
      padding-right: 0;
    }
    .docs-sidenav > li > span {
      display: block;
      margin: 0 -15px;
    }
    .docs-sidenav > li > a,
    .docs-sidenav > li > span {
      padding: 8px 14px;
    }
    .docs-sidenav .icon-chevron-right {
      float: right;
      margin-top: 2px;
      margin-right: -6px;
      opacity: .25;
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

      <section class="row-fluid contents">
        <nav class="span2">
          <%= erb(:sections, :locals => { :sections => site.sections, :base => '/' }) %>
        </nav>

        <article class="span10">
          <%= yield %>
        </article>
      </section>

      <footer class="footer">
        <p class="text-center">Automatically generated with <a href="https://github.com/avalanche123/rdaux">RDaux, beautiful markdown docs</a></p>
      </footer>

    </div> <!-- /container -->

    <script src="/js/jquery.min.js"></script>
    <script src="/js/bootstrap.min.js"></script>

  </body>
</html>

@@ page
<%= render_markdown(section.contents) %>

@@ sections
<ul class="nav nav-list docs-sidenav">
<% for key, section in sections %>
  <li<% if section == current_section %> class="active"<% end %>>
    <% if section.has_contents? %>
    <a href="<%= base %><%= section.key %>" title="<%= section.title %>"><i class="icon-chevron-right"></i><%= section.title %></a>
    <% else %>
    <span><%= section.title %></span>
    <% end %>
    <% if section.has_children? %>
    <%= erb(:sections, :locals => { :sections => section.sections, :base => base + section.key + '/' }) %>
    <% end %>
  </li>
<% end %>
</ul>