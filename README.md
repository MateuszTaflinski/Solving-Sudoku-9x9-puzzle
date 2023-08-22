# Solving-Sudoku-9x9-puzzle
Solving Sudoku puzzles seems to be a problem that cannot be solved by a simple brute force way. Number of possible Sudoku 9x9 grids eqauls to 6.671×10^21, which simply cannot be tested in a reasonable time.

In order to solve a given Sudoku 9x9 puzzle I tryed to use simulating annealing, a metaheuristic which has origin in Physics. I have learnt the algorithm during the course of SGH called Nonclassical methods of Optimasation.
Additionaslly I tested how the results of the algorithm correspond to a greedy alogrithm, which is only able to improve during every iteration.

The image '100 Sudoku 9x9 puzzles - Simulating annealing vs greedy algorithm' in the repo crearly shows that simaulting annealing has way better results in a long term with 95% succes ratio at the last iteration (30 000th).
The greedy alogirthm although has better results at the beginning certainly cannot solve the grid in 30 000 iterations (0% succes ratio).

The time needed to perform 30 000 iteartion for a one puzzle equals to 1 minute and 33 seconds for the simulating annealing and 1 minute 28 seconds for the greedy algorithm. It shows that adding additional logical condition
and a few metrics don't lead to significantly longer time.

Basing on results one can notice that sudoku may be the problem which has local minimums. It means it should be solved for example by one of the metaheuristics.
