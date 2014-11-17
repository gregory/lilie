# lilie


## Clients

* Go at http://lilie.gregory.io to explore the Swager Doc
* Ruby: [HyperClient](https://github.com/codegram/hyperclient)
* Browser: [JSONView Plugin](https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc?hl=en)

```bash
$ brew install httpie
```

Push your picturs to a new album and keep the slug for your new album

```bash
http --session=uesr1 -f http://lilie.gregory.io/albums files[1]@images/chuck.jpg files[2]@images/file2.jpg
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

- [x] POST /                                     Post images to a new album
- [x] POST /                                     create new album unless album_id is passed in a cookie. use before_validation block to overwrite the params
- [x] POST /:album_id/                           Post images to an existing album
- [x] GET /:album_id.json                        all the images from an album
- [x] GET /:album_id                             DISPLAY all the images as an album
- [x] GET /:album_id/images/:uuid                DISPLAY all the variants of the original image as an album
- [x] GET /:album_id/images/:uuid.json           all the variants of the original image + details
- [x] GET /:album_id/images/:uuid/filename-timestamp.json    info about the image(size, weight etc)
- [x] GET /:album_id/images/:uuid/filename-timestamp.ext     The actual image
- [x] GET /:album_id/images/:uuid/filter:contrast(40),crop(10)/filename-timestamp.ext     The transformation of the image (cache result and sort params to avoid cache miss from fragonfly)
- [x] POST /:album_id/images/:uuid/filter:contrast(40),crop(10)/filename-timestamp.ext     Store the transformed image in the album
- [ ] Call to kraken to optimise the image size this should be a delayed job - anytime there is at least 1 new image in an album, run this task - we'll update the stored image
- [ ] Load balance the all shit with nginx and make master/slave mysql
- [x] On the fly manipulations
- [x] Cache
- [x] Add Swagger
- [ ] Fix HAL - it doesn't make any sens now

## Credits

My wife lilie that let me do this. <3

## Copyright

Copyright (c) 2014 gregory. See LICENSE.txt for
further details.

