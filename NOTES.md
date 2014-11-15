ROADMAP:

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
