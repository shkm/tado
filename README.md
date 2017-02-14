# Tado

Really simple gem for interacting with Tado's V2 API. The API is still officially closed, so I followed [this excellent blog post](http://blog.scphillips.com/posts/2017/01/the-tado-api-v2/) by @scp93ch.

Note that the auth response is cached to `~/.tado_auth`.

## Basic usage

Set up a new Tado object:

```
tado = Tado.new(username: ..., password: ...)
```

Get some info about you and your home with `tado.me`. You might want to grab your home ID. You'll find it in `tado.me.homes`.

Now set your home_id. You can also pass `home_id` to the initializer.

```
tado.home_id = ...
```

Now you can get some info about your home using the other methods.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

