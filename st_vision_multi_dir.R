#install.packages('LaplacesDemon')
library(LaplacesDemon)
#setwd('set working directory')
eval_table <- read.csv('eval_results.csv')

#extract data for  TP, TN, FP, FN counts in appropriate format
num_class <- 11
num_model <- 27
model_list <- list(
  'Averaged DINOv2', 
  'Averaged Gemma3 SigLIP', 
  'Averaged GeoGemma SigLIP',
  'Averaged RemoteCLIP', 
  'Cropped Z0 1792-6272 Gemma3 SigLIP', 
  'Cropped Z0 1792-6272 GeoGemma SigLIP', 
  'Cropped Z0 1792-6400 DINOv2', 
  'Cropped Z0 1792-6400 RemoteCLIP', 
  'Cropped Z0 2560-5376 DINOv2', 
  'Cropped Z0 2560-5376 RemoteCLIP', 
  'Cropped Z0 2688-5376 Gemma3 SigLIP', 
  'Cropped Z0 2688-5376 GeoGemma SigLIP', 
  'Cropped Z0 3584-4480 Gemma3 SigLIP', 
  'Cropped Z0 3584-4480 GeoGemma SigLIP', 
  'Cropped Z0 3584-4608 DINOv2', 
  'Cropped Z0 3584-4608 RemoteCLIP', 
  'Cropped Z1 1792-2304 DINOv2', 
  'Cropped Z1 1792-2304 RemoteCLIP', 
  'Cropped Z1 896-2688 Gemma3 SigLIP', 
  'Cropped Z1 896-2688 GeoGemma SigLIP', 
  'Cropped Z2 512-1280 DINOv2', 
  'Cropped Z2 512-1280 RemoteCLIP', 
  'Downsampled DINOv2', 
  'Downsampled Gemma3 SigLIP', 
  'Downsampled RemoteCLIP', 
  'SceneNet RemoteCLIP', 
  'SceneNet MRL RemoteCLIP'
)
confusion_counts <- array(rep(0, num_model*num_class*4), dim = c(num_model, num_class, 4))
#populate confusion mat counts
############################### TP                             TN                              FP                            FN
for(i in 1:num_class){
  for(j in 1:num_model){
    confusion_counts[j,i,] <- c(eval_table[j,3*num_class+i+1], eval_table[j, 2*num_class+i+1], eval_table[j, num_class+i+1], eval_table[j, i+1])
  }
}

one_vec <- rep(1,4)
N_samps <- 1000
class_N <- confusion_counts[1,,1]+confusion_counts[1,,4]

precision_samps <- array(rep(0, num_model*num_class*N_samps), dim = c(num_model,num_class, N_samps))
recall_samps <- array(rep(0, num_model*num_class*N_samps), dim = c(num_model,num_class, N_samps))
F1_samps <- array(rep(0, num_model*num_class*N_samps), dim = c(num_model,num_class, N_samps))

for(i in 1:num_class){
  for(j in 1:num_model){
    post_samps_cur <- rdirichlet(n = N_samps, alpha = confusion_counts[j,i,]+one_vec)
    precision_samps[j,i,] <-  post_samps_cur[,1]/(post_samps_cur[,1]+post_samps_cur[,3])
    recall_samps[j,i,] <- post_samps_cur[,1]/(post_samps_cur[,1]+post_samps_cur[,4])
    F1_samps[j,i,] <-  2*post_samps_cur[,1]/(2*post_samps_cur[,1] + post_samps_cur[,3] + post_samps_cur[,4])
  }
}

#make plots
for(i in 1:num_class){
  for(j in 1:num_model){
    filename <- paste(model_list[j], 'class', i-1, '.pdf', sep = '')
    pdf(filename)
    par(mfrow = c(3,1))
    par(mar = c(2,2,2,2))
    plot(density(precision_samps[j,i,]), xlim = c(0,1), main = paste('model', j-1, ' class', i-1, ' posterior  precision, N = ', class_N[i]), xlab = 'precision')
    plot(density(recall_samps[j,i,]), xlim = c(0,1), main = paste('model', j-1, 'class', i-1, 'posterior  recall, N = ', class_N[i]), xlab = 'recall')
    plot(density(F1_samps[j,i,]), xlim = c(0,1), main = paste('model', j-1, 'class', i-1, 'posterior F1, N = ', class_N[i]), xlab = 'F1')
    dev.off()
  }
}

