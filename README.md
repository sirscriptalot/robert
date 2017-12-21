# Robert

Robert is an implementation of the builder pattern that first runs the given
arguments through a validation process.

## Installation

`gem install robert`

## Usage

Robert is helpful in creating form objects (validating Rack params),
implementing business logic (service objects, if you will) and much more.
Basically if you do not trust the data, run it through Robert.

```ruby
  class Post
    attr_accessor :title, :body

    def initialize(attributes)
      attributes.each do |key, value|
        send(:"#{key}=", value)
      end
    end
  end

  class PostBuilder < Robert
    attr_accessor :title, :body

    private

    def validate
      error :title, :is_empty { empty? }
      error :body,  :is_empty { empty? }
    end
  end

  builder = PostBuilder.new(title: 'Title', body: '')

  result = builder.build(Post)

  result # false

  builder.errors # { body: [:is_empty] }

  builder.body = 'body'

  result = builder.build(Post)

  result.is_a?(Post) # true
```

Check out the tests for more examples.

## API

`::build` - Convenience for `::new(params).build(klass)`

`::build!` - Convenience for `::new(params).build!(klass)`

`#attributes` - Hash of attributes that have been validated (successfully) and "cleaned".

`#errors` - Hash of errors.

`#build` - Initializes the given class if valid or returns false.

`#build!` - Initializes the given class if valid or raises.

`#clean` - Template method for cleaning values before assigning them the attributes hash.

`#error` - Bread and butter of the library. For a given attribute, adds error if the given block returns false. The block is evaluated in context of the attribute itself.

`#validate` - Template method for implementing your validation logic.

`#valid?` - Checks to see if the builder is valid.

### Gotchas

Sending `#errors` before `#valid?` will return the default errors
(an empty Hash by default), which will give the appearance of a valid object.
The reason for this is that if you have an html view and are rendering
a form/builder's errors, you don't want to `#errors` to trigger validation
on the initial page load.

## Prior Art

Robert is inspired by the following libraries:

* [Scrivener](https://github.com/soveran/scrivener)
* [Hatch](https://github.com/tonchis/hatch)
* [Django's Forms](https://www.djangoproject.com)
