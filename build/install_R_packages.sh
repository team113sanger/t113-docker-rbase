#! /bin/bash

Rscript -e "install.packages( pkgs = c( 'devtools', 
					'tidyverse', 
					'argparse', 
					'optparse', 
					'pheatmap',
					'viridis',
					'extrafont',
					'rdgal',
					'ggrepel',
					'showtext',
					'GGally',
					'jsonlite',
					'RColorBrewer' ), 
				repos = 'https://www.stats.bris.ac.uk/R/', 
				dependencies = TRUE, 
				clean = TRUE )"

Rscript -e "install.packages( pkgs = c( 'hrbrthemes' ), repos = 'https://cinc.rud.is', dependencies = TRUE, clean = TRUE )"
Rscript -e "install.packages( 'BiocManager', repos = 'https://www.stats.bris.ac.uk/R/' )"
Rscript -e "BiocManager::install( c( 'ensembldb', 'GenomicRanges', 'rhdf5' ) )"
