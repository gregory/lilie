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

##ROADMAP:

- [x] POST / : Post images to a new album
- [x] POST /:album_id/ : Post images to an existing album
- [x] GET /:album_id.json  all the images from an album
- [x] GET/:album_id/images/:id : info about the image
- [ ] GET /:album_id  display all the images
- [ ] GET /:album_id/images/id/{thumb,small,big} : store thumb, small,big
- [ ] GET /:id/token=&name=custom&flip=true : create a new custom image and set an alias. warn: rate limits - warn: no cache the token
- [ ] POST /:id/action/delete_customs
- [ ] Call to kraken to optimise the image size - this should be a delayed job - anytime there is at least 1 new image in an album, run this task
- [ ] Manage versions
- [ ] Make sure files are cached properly
- [ ] POST / : create new album unless album_id is passed in a cookie. use before_validation block to overwrite the params[:album_id]

## Copyright

Copyright (c) 2014 gregory. See LICENSE.txt for
further details.

