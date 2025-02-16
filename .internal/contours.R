library(ggplot2)
library(akima)  # For interpolation

# Set seed for reproducibility
set.seed(516)

# Generate random topology data
num_points <- 100
x <- runif(num_points, 0, 10)
y <- runif(num_points, 0, 10)
z <- sin(x) * cos(y) + rnorm(num_points, sd = 0.2)
d <- x + rnorm(num_points, sd = 0.2)

# Interpolate data to create a smooth grid
interp_data <- interp(x, y, z, d, nx = 100, ny = 100)

# Convert interpolated data into a dataframe for ggplot
contour_df <- expand.grid(x = interp_data$x, y = interp_data$y)
contour_df$z <- as.vector(interp_data$z)

# Plot contours with theme_void
conplot = ggplot(contour_df, aes(x = x, y = y, z = z)) +
  geom_contour(color = "black") +
  theme_void()

ggsave("man/figures/contour.png", conplot,
       dpi=300,
       width = 5, height=5,
       units = "in")
