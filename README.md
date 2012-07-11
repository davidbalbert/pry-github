# pry-github

pry-github teaches Pry about GitHub. It lets you view your methods in GitHub whether. You can also open the GitHub blame view, which I think is quite nice.

A bunch of code was taken from [pry-git](https://github.com/pry/pry-git).

## Installation

Add this line to your application's Gemfile:

    gem 'pry-github'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pry-github

## Usage

```
$ pry
[1] pry(main)> gh show Foo#bar
# opens lib/foo.rb on GitHub

[2] pry(main)> gh blame Foo#bar
# opens the blame page for lib/foo.rb on GitHub
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

pry-github is licensed under the MIT License. See LICENSE for more info. (c) 2012 David Albert.
