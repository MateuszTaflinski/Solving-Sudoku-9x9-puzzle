library(readxl)

sudoku_999 <- as.data.frame(read_xlsx("sudoku.xlsx"))
colnames(sudoku_999) <- c(1:81)
plansza <- matrix(sudoku_999[1,], ncol =9, nrow =9, byrow = TRUE)
plansza <- matrix(unlist(plansza), ncol =9, nrow =9, byrow=TRUE)
plansza[plansza==0] <- NA


# funkcja do losowania wiersza i kolumny dla pustej komórki
losowanie_wiersza_kolumny <- function() {
wiersz <- as.numeric(sample(1:9,1))
kolumna <- as.numeric(sample(1:9,1))

if (!is.na(plansza[wiersz, kolumna])) {
repeat {
  wiersz <- as.numeric(sample(1:9,1))
  kolumna <- as.numeric(sample(1:9,1))
  if (is.na(plansza[wiersz,kolumna])) {
  break 
  }
}
}
assign("wiersz", wiersz, envir = .GlobalEnv)
assign("kolumna", kolumna, envir = .GlobalEnv)
}

losowanie_wiersza_kolumny()

# losowanie liczby
losowanie_liczby <- function() {
liczba <- as.numeric(sample(1:9,1))
#return(as.numeric(sample(1:9,1)))
assign("liczba", liczba, envir = .GlobalEnv)
}


## zape³nianie planszy

zapelnianie_planszy <- function(plansza) {


repeat{
  losowanie_wiersza_kolumny()
  losowanie_liczby()
  plansza[wiersz, kolumna] <- liczba
  if (length(plansza[is.na(plansza)]) == 0){
  break
}
}
assign("plansza", plansza, envir = .GlobalEnv)
}

## liczenie b³êdów
liczenie_bledow <- function(rozwiazanie) {

wartosc = 0

for (i in 1:9) {
  wartosc = wartosc + 18 - length(table(rozwiazanie[,i])) - length(table(rozwiazanie[i,]))

}
return(wartosc)
}
# Simulating annealing
start = Sys.time()

p = 100 # liczba plansz sudoku

i = 30000 # liczba iteracji na kazda plansze

macierz_bledow = matrix(NA, i, p)
macierz_temperatury = matrix(NA, i, p)

for (p in 1:p) {
  plansza <- matrix(sudoku_999[p,], ncol =9, nrow =9, byrow = TRUE)
  plansza <- matrix(unlist(plansza), ncol =9, nrow =9, byrow=TRUE)
  plansza[plansza==0] <- NA 


zapelnianie_planszy(plansza)
temperatura = 100


for (i in 1:i) {

wspolczynnik = 0.999
temperatura = temperatura*wspolczynnik

nowe_rozwiazanie = plansza
nowe_rozwiazanie[sample(1:9,1), sample(1:9,1)] <- sample(1:9,1)

bledy_plansza <- liczenie_bledow(plansza)
bledy_nowe_rozwiazanie <- liczenie_bledow(nowe_rozwiazanie)

macierz_bledow[i,p] = bledy_plansza
macierz_temperatury[i,p] = exp((bledy_plansza - bledy_nowe_rozwiazanie)/temperatura)

if (macierz_temperatury[i,p] > 1) {
  plansza <- nowe_rozwiazanie
}else {
  if (runif(1) >  macierz_temperatury[i,p]) {
  next # nic sie nie dzieje  
  } else {
  plansza <- nowe_rozwiazanie
} 
}
}
}

end = Sys.time() - start

# wersja zach³anna

start_2 = Sys.time()

p = 100 # liczba plansz sudoku

i = 30000 # liczba iteracji na kazda plansze

macierz_bledow = matrix(NA, i, p)
macierz_temperatury = matrix(NA, i, p)

for (p in 1:p) {
  plansza <- matrix(sudoku_999[p,], ncol =9, nrow =9, byrow = TRUE)
  plansza <- matrix(unlist(plansza), ncol =9, nrow =9, byrow=TRUE)
  plansza[plansza==0] <- NA 
  
  
  zapelnianie_planszy(plansza)
  temperatura = 100
  
  
  for (i in 1:i) {
    
    wspolczynnik = 0.999
    temperatura = temperatura*wspolczynnik
    
    nowe_rozwiazanie = plansza
    nowe_rozwiazanie[sample(1:9,1), sample(1:9,1)] <- sample(1:9,1)
    
    bledy_plansza <- liczenie_bledow(plansza)
    bledy_nowe_rozwiazanie <- liczenie_bledow(nowe_rozwiazanie)
    
    macierz_bledow[i,p] = bledy_plansza
    macierz_temperatury[i,p] = exp((bledy_plansza - bledy_nowe_rozwiazanie)/temperatura)
    
    if (macierz_temperatury[i,p] > 1) {
      plansza <- nowe_rozwiazanie
    }else {
      next
    }
  }
}

end_2 = Sys.time() - start_2

macierz_bledow_simulating_annealing <- read.table('macierz_bledow_simulating annealing.txt')
macierz_temperatury_simulating_annealing <- read.table('macierz_temperatury_simulating annealing.txt')
macierz_bledow_greedy <- read.table('macierze_bledow_zachlanny.txt')

prawdopodobienstwo_sukcesu_simulating_annealing <- length(macierz_bledow_simulating_annealing[i,][macierz_bledow_simulating_annealing[i,]==0])/p
prawdopodobienstwo_sukcesu_greedy <- length(macierz_bledow_greedy[i,][macierz_bledow_greedy[i,]==0])/p


png(filename="100 Sudoku 9x9 puzzles - Simulating annealing vs greedy algorithm.png", width=1920, height=1080)

plot(rowMeans(macierz_bledow_greedy), type = 'l', col = 'green', ylim = c(0,max(rowMeans(macierz_bledow_simulating_annealing))),
     xlab = 'Iteration', ylab = 'Average of incorrect allocated numbers', main = '100 Sudoku 9x9 puzzles - Simulating annealing vs greedy algorithm')
lines(rowMeans(macierz_bledow_simulating_annealing), col = 'red')
legend('topright', legend=c("Simulating annealing", "Greedy algorithm"),
       col=c("red", "green"), lty=1, cex=1.2)
dev.off()
