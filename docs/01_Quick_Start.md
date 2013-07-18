# Quick Start

RDaux creates beautiful documentation websites from markdown files.
It is inspired by [daux.io](http://daux.io/) and uses redcarpet and pygments.rb
to process github-flavored markdown files into beautiful documentation websites
and supports ASCII art with help of [Ditaa](http://sourceforge.net/projects/ditaa/).

## Installation

RDaux is a rubygem, install it by running the following in your shell:

```bash
> gem install rdaux
```

### Requirements

RDaux requires Python 2.5+ for its pygments dependency and Java 1.5+ for ditaa.
Make sure those tools are installed and available in the `$PATH`

## Usage

After RDaux has been installed, you can begin using it from your cli:

```bash
> rdaux -h
Usage: rdaux [--version] [--help] command [options] [args]

Available rdaux commands are:
  serve      Dynamically serve html documentation from a given directory
  generate   Generates static html site using docs from given directory

Common options:
    -h, --help                       Show this message
    -v, --version                    Show version
```

As you can see, RDaux can dynamically serve documentation from your markdown
sources or it can generate a static documentation website. You can determine
options available to each subcommand by running:

```bash
> rdaux <subcommand> -h|--help
```
