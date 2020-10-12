# Sunrise

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/sunrise`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sunrise'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sunrise

## Usage

### Using sunrise to manage forms with Mutation pattern

In Sunrise, forms are managed with mutations (https://github.com/cypriss/mutations)

Example


### The controller

```ruby
# the helper_method to pass to the view form_helper
helper_method :view_form_param

# the action the form will post to
def the_post_action
    mutation_form.process_with_params(params)

    render :the_view_to_render
end

# instantiate the mutation form class
# pass the default form values to the constructor    
def mutation_form
    @mutation_form ||= ::CreateUser.new({})
end

private

def view_form_param
    mutation_form.form_params(create_constructor_lead_path)
end
```

### The view

```html
<%= bootstrap_form_with view_form_param do |f| %>
    <%= f.text_field :name %>
    <%= f.text_field :email %>
    <%= f.text_field :phone %>
    <%= f.button 'Submit' %>
<% end %>
```

### The mutation

```ruby
class CreateUser < Sunrise::Mutations::ProcessForm
    # define the required fields
    required do
        string :name
        string :email
        string :gender
    end
    
    # define the optional fields
    optional do
        string :phone 
    end
    
    scope :user
    
    # define the validations for the form
    def validate
        # user input is a available option
        validate_in_options(:gender)
        
        # add a custom error on the field you want
        if error_on_the_name?
            add_error(:name, :custom, 'There is an error !')
        end
    end
    
    # define what happen once the form is submitted and validated
    def execute
        # get the submitted values for those fields
        values = user_inputs_for_fields(:name, :email, :phone)
        
        # do something with them
        User.create!(values)
    end
end

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sunrise. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/sunrise/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sunrise project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sunrise/blob/master/CODE_OF_CONDUCT.md).
