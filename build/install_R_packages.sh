#! /bin/bash

Rpackages=( 'devtools' 'tidyverse' 'argparse' 'optparse' 'pheatmap' 'viridis' 'extrafont' 'rdgal' 'ggrepel' 'showtext' 'GGally' 'jsonlite' 'RColorBrewer' 'futile.logger' )

for pkg in ${Rpackages[@]}; do
  echo "Installing $pkg"
  Rscript -e "install.packages( pkgs = c( '${pkg}' ), repos = 'https://www.stats.bris.ac.uk/R/', dependencies = TRUE, clean = TRUE, quiet = TRUE, Ncpus = 2 )"
done

#Rscript -e "install.packages( pkgs = c( 'devtools', 'tidyverse', 'argparse', 'optparse', 'pheatmap', 'viridis', 'extrafont', 'rdgal', 'ggrepel', 'showtext', 'GGally', 'jsonlite', 'RColorBrewer', 'futile.logger' ), repos = 'https://www.stats.bris.ac.uk/R/', dependencies = TRUE, clean = TRUE, quiet = TRUE )"
Rscript -e "install.packages( pkgs = c( 'hrbrthemes' ), repos = 'https://cinc.rud.is', dependencies = TRUE, clean = TRUE, quiet = TRUE )"
Rscript -e "install.packages( 'BiocManager', repos = 'https://www.stats.bris.ac.uk/R/', quiet = TRUE )"
Rscript -e "BiocManager::install( c( 'ensembldb', 'GenomicRanges', 'rhdf5' ), quiet = TRUE )"
