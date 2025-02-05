library(hexSticker)
library(ggplot2)
library(showtext)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## Loading Google fonts (http://www.google.com/fonts) ----
font_add_google("Gochi Hand", "gochi")

## Automatically use showtext to render text for future devices
showtext_auto()

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# get EPA data from this package now that fully formed
df_1991_pm25 = tidypollute::epa_zip_links %>%
  dplyr::filter(year == 1991 &
                  unit_of_analysis == "daily" &
                  analyte == "44201") %>%
  tidypollute::download_stack_epa_airdata(urls=.,
                                          download = T,
                                          stack = T,
                                          # clean_names=T,
                                          output_dir="data/")

df_1991_pm25_filt = df_1991_pm25 %>%
  filter(`state_name` == "Florida") %>%
  filter(`city_name` == "Tampa") %>%
  mutate(dt_wday = lubridate::wday(date_local, label=T))

recs_per_day = df_1991_pm25_filt %>%
  count(date_local)

p <- ggplot(aes(x = date_local, y = arithmetic_mean), data=df_1991_pm25_filt) +
  geom_jitter(size=0.2) +
  geom_smooth(color="darkgreen") +
  theme_void() +
  theme_transparent()

# plot sticker ----
sticker(p,
        h_fill = "green",
        h_color = "darkgreen",
        package="tidypollute",
        p_family = "gochi",
        p_size=24,
        p_y = 1.0,
        s_x=1, s_y=.9,
        s_width=1.5,
        s_height=1,
        filename="inst/figures/logo.png")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# imgurl <- system.file("figures/cat.png", package="hexSticker")
# sticker(imgurl, package="hexSticker", p_size=20, s_x=1, s_y=.75, s_width=.6,
#         filename="inst/figures/imgfile.png")
