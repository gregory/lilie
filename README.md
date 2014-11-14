# lilie


```bash
$ brew install httpie
```

Push your picturs to a new album and keep the slug for your new album

```bash
$ http -f http://lilie.gregory.io files[1]@./file.jpg files[2]@./file2.jpg
```

Display the pictures in your album
```bash
$ http http://lilie.gregory.io/SLUG
```

Diaplay the info about an image
```bash
$ http http://lilie.gregory.io/SLUG/images/ID
```

## Contributing to lilie

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 gregory. See LICENSE.txt for
further details.

