## MDWA - A MDD Approach for Ruby on Rails

MDWA is a model-driven approach, built by Marcelo Theodoro, to ease the process of develop web applications.
MDD gem includes a set of code generation tools to automate repetitive task during Rails development, such as:

* Sandbox environment: Provides a clean environment with user authentication, namespace separation and more;
* CSS templating: YUI3 grid system and beautiful styling
* Multiple layouts
* Smart scaffold generator

## How to start?

MDD is based on top of Rails 3.1, including asset pipeline feature.
Add it to your Gemfile with:

```ruby
gem 'mdd'
```

Run the bundle command to install it.

After you install MDD and add it to your Gemfile, you need to run the generator:

```console
rails generate mdwa:sandbox
```
This generator will setup the clean sandbox environment with:

* Multiple layouts;
* Assets ready to be customized;
* User based authentication with Devise (https://github.com/plataformatec/devise);
* Login;
* Public pages - for simple website development.

Check the result:

* Public pages: http://localhost:3000
* Private area: http://localhost:3000/a

The private area requires user authentication.
The generator will create a default user:

```console
User: admin@admin.com
Password: admin123
```
