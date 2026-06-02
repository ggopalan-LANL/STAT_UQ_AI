This repository allows for reproducibility of results in the following paper, which was presented as a poster during the NeurIPS 2024 Workshop on Statistical Frontiers in LLMs and Foundation Models. 

Longjohn, R., Gopalan, G., & Casleton, E. (2025). Statistical uncertainty quantification for aggregate performance metrics in machine learning benchmarks. arXiv preprint arXiv:2501.04234.

Code is contained in self-contained R Markdown files, which can be executed within R Studio. 

The repository also contains an R script to implement a multinomial-Dirichlet Bayesian model for sampling posterior distributions over F1, precision, recall, and accuracy. The approach is to use conjugacy to derive a Dirichlet posterior over true-positive, false-positive, true-negative, and false negative rate, and to sample from these posterior quantities and translate to F-1, precision, recall, and accuracy (based on standard definitions). 

This repository corresponds to O5052, AI Evaluation with UQ.
