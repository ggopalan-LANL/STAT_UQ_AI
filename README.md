This repository allows for reproducibility of results in the following paper, which was presented as a poster during the NeurIPS 2024 Workshop on Statistical Frontiers in LLMs and Foundation Models:

Longjohn, R., Gopalan, G., & Casleton, E. (2025). Statistical uncertainty quantification for aggregate performance metrics in machine learning benchmarks. arXiv preprint arXiv:2501.04234.

Code is in self-contained R Markdown files (VTAB_BHM.Rmd, VTAB_interval_plots.RMD, and boot_BHM_sim.Rmd) and can be executed within RStudio.

This repository also shows a statistically-oriented approach, in MLC_UQ.Rmd, for uncertainty quantification on commonly used classification metrics -- precision, recall, and F1. The approach is to use a multinomial-Dirichlet statistical model (see Section 2.2 of the paper referenced above).

This repository corresponds to O5052, AI Evaluation with UQ, as reviewed by the Richard P. Feynman Center for Innovation at Los Alamos National Laboratory.
