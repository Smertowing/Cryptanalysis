# Cryptanalysis
Cryptanalysis for progressive Vigenere with expected key length

#### Additional assignment to laboratory work on Information Theory, BSUIR

***Text is encrypted as follows. Compiled table, so-called. Vigenere square: the alphabet is written on top and on the left, then a first permutation of the original alphabet is placed in the first line, the second permutation is cyclically shifted by one position, and so on. As a result, we get a table that associates a character with each pair of characters.***


It remains to find the `keyword`. Let us know that the length of a keyword is L characters. Then the text can be divided into L groups, each of which will be encrypted using a single character of the keyword, that is, it will be a simple replacement cipher. In this case, the used permutations of the alphabet will differ only by a shift equal to the sign of the distance between the corresponding symbols of the keyword. Using the methods of frequency cryptanalysis, we will be able to determine these shifts.

[Alexey Lyapeshkin](https://github.com/AlexeyLyapeshkin)
