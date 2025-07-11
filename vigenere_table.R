# An R function that produces original and extended Vigenère сipher tables.

vigenere_table <- function(type = "original", custom_alphabet = NULL, is_random = FALSE, output = 'dataframe', filename = NULL) {
  
  # Encoding Options
  if (type == 'original') { # Original 26 Capital English Letters Table
    alphabet <- intToUtf8(65:90, multiple = TRUE)
  } else if (type == 'ASCII95') { # Extended ASCII: all printable characters from 32 (space) to 126 codes
    alphabet <- intToUtf8(32:126, multiple = TRUE)
  } else if (type == 'ASCII92') { # Extended ASCII: ", ', \ are removed 
    alphabet <- intToUtf8(setdiff(32:126, utf8ToInt('"\'\\')), multiple = TRUE)
  } else if (type == 'ASCII91') { # Extended ASCII: ", ', \ and empty space are removed 
    alphabet <- intToUtf8(setdiff(33:126, utf8ToInt('"\'\\')), multiple = TRUE)
  } else if (type == 'Base64') { # Base64 (RFC 4648)
    alphabet <- c(LETTERS, letters, 0:9, "+", "/")
  } else if (type == 'Base58') { # Base58 (crypto standard): characters "0 O I l + /" are removed
    alphabet <- strsplit("123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz", "")[[1]]
  } else if (type == 'custom') { 
    if (is.null(custom_alphabet)) stop('Error: `custom_alphabet` must be provided when `type = "custom"`.')
    alphabet <- custom_alphabet
  } else {
    stop('Error: `type` argument is either misspelled or incorrect.')
  }
  
  if (is_random == TRUE) {
    alphabet <- sample(alphabet)
  } else if (is_random != FALSE) {
    stop('Error: `is_random` argument is either misspelled or incorrect.')
  }
  
  n <- length(alphabet)
  
  # Generating Table
  vigenere_table <- matrix(nrow = n, ncol = n)
  for (key_idx in 1:n) {
    for (plain_idx in 1:n) {
      shifted_idx <- ((plain_idx - 1) + (key_idx - 1)) %% n + 1
      vigenere_table[key_idx, plain_idx] <- alphabet[shifted_idx]
    }
  }
  
  rownames(vigenere_table) <- alphabet  # master-key as default 
  colnames(vigenere_table) <- alphabet  # password as default
  vigenere_table <- as.data.frame(vigenere_table)
  
  # Output options
  if (output == 'dataframe') {
    return(vigenere_table)
    
  } else if (output == 'csv') {
    if (is.null(filename)) filename <- "vigenere_table.csv"
    write.csv(vigenere_table, filename, row.names = TRUE, fileEncoding = "UTF-8")
    
  } else if (output == 'pdf') { 
    if (is.null(filename)) filename <- "vigenere_table.pdf"
    library(gridExtra)
    library(grid)
    
    if (n >= 91) {
      width <- 33.1; height <- 23.4  # A1
      cex_core <- 0.4
      cex_header <- 0.5
    } else if (n >= 60) {
      width <- 23.4; height <- 16.5  # A2
      cex_core <- 0.5
      cex_header <- 0.6
    } else if (n >= 45) {
      width <- 16.5; height <- 11.7  # A3
      cex_core <- 0.6
      cex_header <- 0.7
    } else {
      width <- 11.7; height <- 8.3   # A4
      cex_core <- 0.7
      cex_header <- 0.9
    }
    
    tg <- tableGrob(vigenere_table,  theme = ttheme_default(
      core = list(fg_params = list(cex = cex_core)),
      colhead = list(fg_params = list(cex = cex_header)),
      rowhead = list(fg_params = list(cex = cex_header))
    ))
    
    pdf(filename, width = width, height = height)
    grid.newpage()
    grid.draw(tg)
    dev.off()
    
  } else {
    stop('Error: `output` argument is either misspelled or incorrect.')
  }
  
}
