source("utils.R")
m_dir <-"Data"
m_files <- list.files(m_dir,"m\\.[0-9]+\\.pathways_mod\\.tsv", full.names = T)
m_files_genes <- list.files(m_dir,"m\\.[0-9]+\\.genes\\.tsv", full.names = T)
m_files_genes <- m_files_genes[-2]

set <- list()
i=1
for (i in 1:length(m_files)){
  file <- readr::read_tsv(m_files[i])
  moduleSize <- nrow(readr::read_tsv(m_files_genes[i]))
  print(moduleSize)
  paths <- file %>%
    dplyr::select(PATHNAME, PATHID, k) %>%
    arrange(desc(k)) %>%
    mutate(simpleName = NA,
           percentOfGenesInThePthw = k / moduleSize,
           PATHNAME = paste0(PATHNAME, " (", PATHID, ")"))
  # View(paths)
  assign(paste0("mp", i), paths)
}

mp1 <- mp1[c(2,4,6,7,11,13,18), ]
mp2 <- mp2[c(2,4,11,14,15,17,18,21,22), ]
mp3 <- mp3[c(3,4,5,11,13,14), ]
mp4 <- mp4[c(3,4,9,11,17), ]
mp5 <- mp5[c(2,9), ]
mp6 <- mp6[c(1,3,15), ]
mp7 <- mp7[c(1,4,15,16,17), ]
mp8 <- mp8[c(2,9), ]
mp9 <- mp9[1, ]

set <- list(mp1, mp2, mp3, mp4, mp5, mp6, mp7,mp8,mp9)

pathNames <-c()
for(i in seq_along(set)){
  pathNames <- c(pathNames, set[[i]]$PATHNAME)
}
pathNames <- unique(pathNames)

set_df <- as.data.frame(matrix(NA, nrow = length(set), ncol=length(pathNames)))
colnames(set_df) <- pathNames
# View(set_df)
for(i in seq_along(set)){
  set_df[i, set[[i]]$PATHNAME] <- set[[i]]$percentOfGenesInThePthw
}
set_df[is.na(set_df)] <- 0
rownames(set_df) <- c(paste("Module", 1:9))

pheatmap::pheatmap(
  set_df,
  cluster_rows=F, cluster_cols=F,
  show_rownames=T, show_colnames=T,
  file="Fig3C_heatmap.pdf", width=3.7, height=5,
  # color = brewer.pal(9,"Spec"))
  color = c("snow2", rev(brewer.pal(11, "Spectral"))))