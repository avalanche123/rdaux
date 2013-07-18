# Supported Markup

RDaux allows you to use github-flavored markdown. And supports ASCII art using
powerful [Ditaa](http://sourceforge.net/projects/ditaa/) for rendering.

## Examples

### ASCII diagrams

ASCII diagrams are processed using Ditaa, for example, the following diagram:

    ```ditaa
      Front-end     :      Back-end     |    Financiele
                    |                   |   Instellingen
    /----------+    |    /---------\    :
    |   Simyo  |    |    | CDRator |    |
    |  Website |<---+--->\---------/    |
    \----------/    :          ^        |
                    |          |        |
                    |          v        |
    /----------\    |    /---------\    |
    | Simone   |    |    |cYEL     |    |    /----------\
    |  (IVR)   |<---+--->|   SMO   :<---+--->| Interpay |
    \----------/    :    |         |    :    \----------/
                    |    \---------/    | 
                    |                   |
    ```

Will looks like the following image after rendering:

```ditaa
  Front-end     :      Back-end     |    Financiele
                |                   |   Instellingen
/----------+    |    /---------\    :
|   Simyo  |    |    | CDRator |    |
|  Website |<---+--->\---------/    |
\----------/    :          ^        |
                |          |        |
                |          v        |
/----------\    |    /---------\    |
| Simone   |    |    |cYEL     |    |    /----------\
|  (IVR)   |<---+--->|   SMO   :<---+--->| Interpay |
\----------/    :    |         |    :    \----------/
                |    \---------/    | 
                |                   |
```

### Code highlighting

You can use github-flavored markdown to highligh code sections, e.g.:

    ```ruby
    require 'rdaux'

    RDaux.start
    ```

Becomes:

```ruby
require 'rdaux'

RDaux.start
```
