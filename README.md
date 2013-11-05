# EndpointBase

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'endpoint_base'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install endpoint_base

In your application, you need to set the ENDPOINT_KEY environment variable.  All requests much include it in the header.

If you wish to allow some GET requests without the header, put these paths in the PUBLIC_PATHS environment variable.

    PUBLIC_PATHS=/public/path;/public/path2

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
