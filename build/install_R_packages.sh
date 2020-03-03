#! /bin/bash

Rscript -e "install.packages(pkgs = c('devtools', 'tidyverse', 'argparse', 'pheatmap', 'optparse', 'viridis', 'extrafont', 'rdgal', 'ggrepel', 'showtext'), repos='https://www.stats.bris.ac.uk/R/', dependencies=TRUE, clean = TRUE)"
Rscript -e "install.packages(pkgs = c('hrbrthemes'), repos = 'https://cinc.rud.is', dependencies=TRUE, clean = TRUE)"

Rscript -e "install.packages('BiocManager', repos='https://www.stats.bris.ac.uk/R/')"
Rscript -e "BiocManager::install()"
