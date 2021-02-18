library(hexSticker)
library(magick)
imglocation <- "images/axe7.png"
mgkimage <- image_read(imglocation)
mgkimage_blur <- image_blur(mgkimage, 10, sigma = 1)

mgkimage_blur_location <- "images/axe7-blur.png"
image_write(mgkimage_blur, mgkimage_blur_location)

plot(sticker(mgkimage_blur_location,
             package="bescea", p_size=28, s_x=1, s_y=1.25, s_width=.2,
             filename="inst/figures/imgfile.png",
             h_color = rgb(255/255,199/255,44/255),
             h_fill = rgb(4/255,30/255,66/255),
             p_y = .7))

save_sticker("images/bescea-hex.png")
