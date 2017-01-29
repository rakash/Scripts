# https://www.r-bloggers.com/principal-component-analysis-in-r/

# Generate scaled 4*5 matrix with random std normal samples
set.seed(101)
mat <- scale(matrix(rnorm(20), 4, 5))
dimnames(mat) <- list(paste("Sample", 1:4), paste("Var", 1:5))

# Perform PCA
myPCA <- prcomp(mat, scale. = F, center = F)
myPCA$rotation # loadings
myPCA$x # scores

# Perform SVD
mySVD <- svd(mat)
mySVD # the diagonal of Sigma mySVD$d is given as a vector
sigma <- matrix(0,4,4) # we have 4 PCs, no need for a 5th column
diag(sigma) <- mySVD$d # sigma is now our true sigma matrix

# Compare PCA scores with the SVD's U*Sigma
theoreticalScores <- mySVD$u %*% sigma
all(round(myPCA$x,5) == round(theoreticalScores,5)) # TRUE

# Compare PCA loadings with the SVD's V
all(round(myPCA$rotation,5) == round(mySVD$v,5)) # TRUE

# Show that mat == U*Sigma*t(V)
recoverMatSVD <- theoreticalScores %*% t(mySVD$v)
all(round(mat,5) == round(recoverMatSVD,5)) # TRUE

#Show that mat == scores*t(loadings)
recoverMatPCA <- myPCA$x %*% t(myPCA$rotation)
all(round(mat,5) == round(recoverMatPCA,5)) # TRUE

# PCA of the wine data set
wine <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data", sep=",")

str(wine)

# Name the variables
colnames(wine) <- c("Cvs","Alcohol","Malic acid","Ash","Alcalinity of ash", "Magnesium", "Total phenols", "Flavanoids", "Nonflavanoid phenols", "Proanthocyanins", "Color intensity", "Hue", "OD280/OD315 of diluted wines", "Proline")

# The first column corresponds to the classes
wineClasses <- factor(wine$Cvs)

# Use pairs
pairs(wine[,-1], col = wineClasses, upper.panel = NULL, pch = 16, cex = 0.5)
legend("topright", bty = "n", legend = c("Cv1","Cv2","Cv3"), pch = 16, col = c("black","red","green"),xpd = T, cex = 2, y.intersp = 0.5)

# hard to look at all 13 vars. hence PCA will help, 

dev.off() # clear the format from the previous plot
winePCA <- prcomp(scale(wine[,-1]))
plot(winePCA$x[,1:2], col = wineClasses)

# repeat the procedure after introducing an outlier in place of the 10th observation.

wineOutlier <- wine
wineOutlier[10,] <- wineOutlier[10,]*10 # change the 10th obs. into an extreme one by multiplying its profile by 10
outlierPCA <- prcomp(scale(wineOutlier[,-1]))
plot(outlierPCA$x[,1:2], col = wineClasses)

# PCA of the wine data set with pcaMethods

source("https://bioconductor.org/biocLite.R")
biocLite("pcaMethods")
library(pcaMethods)

winePCAmethods <- pca(wine[,-1], scale = "uv", center = T, nPcs = 2, method = "svd")
slplot(winePCAmethods, scoresLoadings = c(T,T), scol = wineClasses)

# From the above plot, we can say that 1) Wine from Cv2 (red) has a lighter color intensity, lower alcohol %, a greater OD ratio and hue, compared to the wine from Cv1 and Cv3.
# 2) Wine from Cv3 (green) has a higher content of malic acid and non-flavanoid phenols, and a higher alkalinity of ash compared to the wine from Cv1 (black)

# variance explained per component is stored in a slot named R2

str(winePCAmethods) # slots are marked with @
winePCAmethods@R2


#=========== Housing data 

houses <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/housing/housing.data",header = F, na.string = "?")
colnames(houses) <- c("CRIM", "ZN", "INDUS","CHAS","NOX","RM","AGE","DIS","RAD","TAX","PTRATIO","B","LSTAT","MEDV")

str(houses)
# Perform PCA 
pcaHouses <- prcomp(scale(houses[,-14]))
scoresHouses <- pcaHouses$x

# Fit lm using the first 3 PCs and not other variables
modHouses <- lm(houses$MEDV ~ scoresHouses[,1:3])
summary(modHouses)


# Fit lm using all 14 vars
modHousesFull <- lm(MEDV ~ ., data = houses)
summary(modHousesFull) # R2 = 0.741

# Compare obs. vs. pred. plots
par(mfrow = c(1,2))
plot(houses$MEDV, predict(modHouses), xlab = "Observed MEDV", ylab = "Predicted MEDV", main = "PCR", abline(a = 0, b = 1, col = "red"))
plot(houses$MEDV, predict(modHousesFull), xlab = "Observed MEDV", ylab = "Predicted MEDV", main = "Full model", abline(a = 0, b = 1, col = "red"))
