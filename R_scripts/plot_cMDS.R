library(ggplot2)
library(tidyverse)

plot_cMDS <- function(df, top_ = 8) {
    
    #' @title Plot Classical Multidimensional Scaling projection
    #'
    #' @description A simple function to project a cMSD plot (scatter plot) 
    #'              highlighting the top 16 RFE conformations
    #'
    #' @parm df data.frame,  A dataframe with the following columns 
    #'                       `rfe_ranking`, `x`, `y`, `volume`
    #' @param num top_,      An integer value to display the top protein conformations
    #'
    #' @retun                A ggplot2 scatter plot
    
    p = ggplot() +
    geom_hline(yintercept = 0, 
               linetype   = "dashed", 
               color      = "#888888") +
    geom_vline(xintercept = 0, 
               linetype   = "dashed", 
               color      = "#888888") +
    (df %>% 
     geom_point(
         mapping = aes(x = x, 
                       y = y, 
                       size   = volume),
                   stroke = 0.5, 
                   shape  = 21,
                   colour ='#61B0B3', fill='#87DADE', 
                   alpha  = 0.6)) + 
    (df %>% 
     filter(rfe_ranking <= top_) %>%
     geom_point(mapping = aes(
                              x = x, 
                              y = y,
                              size = volume, 
                              fill = rfe_ranking),
                            color  = 'black',
                            shape  = 21, 
                            stroke = 0.5) 
    ) +
    scale_fill_gradientn(colors = c("red", "orange", "#374E55")) +
    theme(legend.position = 'none', 
          panel.border = element_rect(colour = "black", 
                                      fill = NA, 
                                      size = 0.8),
          panel.background = element_rect(fill  = "white",
                                         colour = "white",
                                         size   = 1.2, 
                                         linetype = "solid"),
          axis.title.y = element_text(size = 15),
          axis.text.y  = element_text(size = 13, angle = 0),
          panel.grid.major.y = element_line(size = 0.2, 
                                            linetype = 'solid', 
                                            colour   = "grey"), 
          panel.grid.minor.y = element_line(size = 0.2, 
                                            linetype = 'solid', 
                                            colour   = "lightgrey"),
          axis.title.x = element_text(size = 15),
          axis.text.x  = element_text(size = 13, angle = 0),
          panel.grid.major.x = element_line(size = 0.2, 
                                            linetype = 'solid', 
                                            colour   = "grey"), 
          panel.grid.minor.x = element_line(size = 0.2, 
                                            linetype = 'solid', 
                                            colour   = "lightgrey"),
          plot.title = element_text(hjust = 0.5, size = 15)
     ) + 
     scale_radius() +
     labs(x = 'First dimension', 
          y = 'Second dimension')
    return(p)
}